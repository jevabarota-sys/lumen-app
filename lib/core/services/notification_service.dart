import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  Future<void> _queue = Future.value();

  static const _schemaVersionKey = 'notification_schema_version';
  static const _schemaVersion = 2;
  static const _affirmationScheduleKey = 'reminder_schedule_affirmation';
  static const _manifestationScheduleKey = 'reminder_schedule_369';
  static const _affirmationTypes = {'affirmation', 'weekly_affirmation'};
  static const _manifestationTypes = {'369_manifestation'};
  static const _affirmationIdBase = 100000;
  static const _manifestationIdBase = 200000;

  // iOS keeps at most 64 pending notifications per app; Android caps alarms
  // at roughly 500.
  int get _maxPendingPerSchedule =>
      defaultTargetPlatform == TargetPlatform.iOS ? 30 : 150;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
    _isInitialized = true;

    // Platforms cap pending notifications (64 on iOS), so only a rolling
    // window of one-shot reminders is scheduled; top it up on every launch.
    if (!kIsWeb) {
      unawaited(_serialized(() async {
        try {
          final prefs = await SharedPreferences.getInstance();
          await _removeLegacyDuplicateReminders(prefs);
          await _refreshAffirmationReminders();
          await _refresh369ManifestationReminders();
        } catch (e) {
          debugPrint('Failed to refresh scheduled reminders: $e');
        }
      }));
    }
  }

  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.notification.request();
      await Permission.scheduleExactAlarm.request();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
  }

  Future<void> scheduleAffirmationReminders({
    required List<DateTime> reminderTimes,
    required int durationInDays,
    String? customAffirmation,
  }) async {
    if (!_isInitialized) await initialize();

    await _serialized(() async {
      await _saveSchedule(
        _affirmationScheduleKey,
        _encodeSchedule(
          reminderTimes: reminderTimes,
          durationInDays: durationInDays,
          text: customAffirmation,
        ),
      );
      await _refreshAffirmationReminders();
    });
  }

  Future<void> scheduleWeeklyAffirmationReminders({
    required List<DateTime> reminderTimes,
    required int durationInWeeks,
  }) {
    return scheduleAffirmationReminders(
      reminderTimes: reminderTimes,
      durationInDays: durationInWeeks * 7,
    );
  }

  Future<void> schedule369ManifestationReminders({
    required String manifestationText,
    required List<DateTime> reminderTimes,
    required int durationInDays,
  }) async {
    if (!_isInitialized) await initialize();

    await _serialized(() async {
      await _saveSchedule(
        _manifestationScheduleKey,
        _encodeSchedule(
          reminderTimes: reminderTimes.take(3).toList(),
          durationInDays: durationInDays,
          text: manifestationText,
        ),
      );
      await _refresh369ManifestationReminders();
    });
  }

  Future<void> cancel369ManifestationReminders() {
    return _serialized(() async {
      await _saveSchedule(_manifestationScheduleKey, null);
      await _cancelByTypes(_manifestationTypes);
    });
  }

  /// Cancels every scheduled reminder, including 369 manifestation reminders.
  Future<void> cancelAllAffirmationReminders() {
    return _serialized(() async {
      await _saveSchedule(_affirmationScheduleKey, null);
      await _saveSchedule(_manifestationScheduleKey, null);
      await _notifications.cancelAll();
    });
  }

  Future<void> cancelSpecificReminder(int id) async {
    await _notifications.cancel(id);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  Future<void> _refreshAffirmationReminders() async {
    final schedule = await _loadSchedule(_affirmationScheduleKey);
    if (schedule == null) return;
    await _cancelByTypes(_affirmationTypes);

    final occurrences = upcomingOccurrences(
      times: schedule.times,
      startDate: schedule.startDate,
      durationInDays: schedule.durationInDays,
      now: DateTime.now(),
      limit: _maxPendingPerSchedule,
    );
    if (occurrences.isEmpty) {
      await _saveSchedule(_affirmationScheduleKey, null);
      return;
    }

    final affirmations = _getAffirmationPool();
    final random = Random();
    for (var i = 0; i < occurrences.length; i++) {
      final occurrence = occurrences[i];
      final affirmation =
          schedule.text ?? affirmations[random.nextInt(affirmations.length)];
      await _scheduleNotification(
        id: _affirmationIdBase + i,
        title: '✨ Your Daily Affirmation',
        body: affirmation,
        scheduledDate: occurrence.time,
        payload: jsonEncode({
          'type': 'affirmation',
          'timeIndex': occurrence.timeIndex,
          'affirmation': affirmation,
        }),
      );
    }
  }

  Future<void> _refresh369ManifestationReminders() async {
    final schedule = await _loadSchedule(_manifestationScheduleKey);
    if (schedule == null) return;
    await _cancelByTypes(_manifestationTypes);

    final occurrences = upcomingOccurrences(
      times: schedule.times,
      startDate: schedule.startDate,
      durationInDays: schedule.durationInDays,
      now: DateTime.now(),
      limit: _maxPendingPerSchedule,
    );
    if (occurrences.isEmpty) {
      await _saveSchedule(_manifestationScheduleKey, null);
      return;
    }

    const repetitions = [3, 6, 9];
    const timeLabels = ['Morning', 'Afternoon', 'Evening'];
    final manifestationText = schedule.text ?? '';
    for (var i = 0; i < occurrences.length; i++) {
      final timeIndex = occurrences[i].timeIndex;
      final reps = repetitions[timeIndex];
      final timeLabel = timeLabels[timeIndex];
      await _scheduleNotification(
        id: _manifestationIdBase + i,
        title: '✨ 369 Manifestation - $timeLabel',
        body: 'Write your manifestation $reps times: "$manifestationText"',
        scheduledDate: occurrences[i].time,
        payload: jsonEncode({
          'type': '369_manifestation',
          'timeIndex': timeIndex,
          'repetitions': reps,
          'manifestationText': manifestationText,
          'timeLabel': timeLabel,
        }),
      );
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'affirmation_reminders',
      'Affirmation Reminders',
      channelDescription: 'Daily affirmation reminders for personal growth',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF3B82F6),
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      notificationDetails,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Returns the next one-shot reminder times (at most [limit]) for a
  /// schedule that runs [durationInDays] days from [startDate].
  @visibleForTesting
  static List<({DateTime time, int timeIndex})> upcomingOccurrences({
    required List<TimeOfDay> times,
    required DateTime startDate,
    required int durationInDays,
    required DateTime now,
    required int limit,
  }) {
    final result = <({DateTime time, int timeIndex})>[];
    for (var day = 0; day < durationInDays; day++) {
      final dayOccurrences = <({DateTime time, int timeIndex})>[
        for (var i = 0; i < times.length; i++)
          (
            time: DateTime(
              startDate.year,
              startDate.month,
              startDate.day + day,
              times[i].hour,
              times[i].minute,
            ),
            timeIndex: i,
          ),
      ]..sort((a, b) => a.time.compareTo(b.time));

      for (final occurrence in dayOccurrences) {
        if (!occurrence.time.isAfter(now)) continue;
        result.add(occurrence);
        if (result.length >= limit) return result;
      }
    }
    return result;
  }

  Future<void> _cancelByTypes(Set<String> types) async {
    final pending = await getPendingNotifications();
    for (final notification in pending) {
      if (types.contains(_payloadType(notification.payload))) {
        await _notifications.cancel(notification.id);
      }
    }
  }

  /// Older builds scheduled every day of a schedule as a *daily repeating*
  /// notification, so N days produced N notifications at each reminder time.
  /// Keep one repeating reminder per time slot and drop the duplicates.
  Future<void> _removeLegacyDuplicateReminders(SharedPreferences prefs) async {
    if ((prefs.getInt(_schemaVersionKey) ?? 1) >= _schemaVersion) return;

    final pending = await getPendingNotifications();
    final kept = <String, int>{};
    for (final notification in pending) {
      final payload = _decodePayload(notification.payload);
      if (payload == null) continue;
      final slot = '${payload['type']}:${payload['timeIndex']}';
      final keptId = kept[slot];
      if (keptId == null || notification.id < keptId) {
        if (keptId != null) await _notifications.cancel(keptId);
        kept[slot] = notification.id;
      } else {
        await _notifications.cancel(notification.id);
      }
    }

    await prefs.setInt(_schemaVersionKey, _schemaVersion);
  }

  Future<void> _serialized(Future<void> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.catchError((Object e) {
      debugPrint('Notification scheduling failed: $e');
    });
    return result;
  }

  Map<String, dynamic> _encodeSchedule({
    required List<DateTime> reminderTimes,
    required int durationInDays,
    String? text,
  }) {
    final now = DateTime.now();
    return {
      'times': [
        for (final time in reminderTimes) [time.hour, time.minute],
      ],
      'startDate': DateTime(now.year, now.month, now.day).toIso8601String(),
      'durationInDays': durationInDays,
      if (text != null) 'text': text,
    };
  }

  Future<void> _saveSchedule(String key, Map<String, dynamic>? schedule) async {
    final prefs = await SharedPreferences.getInstance();
    if (schedule == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, jsonEncode(schedule));
    }
  }

  Future<_ReminderSchedule?> _loadSchedule(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return _ReminderSchedule(
        times: [
          for (final t in json['times'] as List)
            TimeOfDay(hour: t[0] as int, minute: t[1] as int),
        ],
        startDate: DateTime.parse(json['startDate'] as String),
        durationInDays: json['durationInDays'] as int,
        text: json['text'] as String?,
      );
    } catch (e) {
      debugPrint('Discarding invalid reminder schedule $key: $e');
      await prefs.remove(key);
      return null;
    }
  }

  static Map<String, dynamic>? _decodePayload(String? payload) {
    if (payload == null) return null;
    try {
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  static String? _payloadType(String? payload) =>
      _decodePayload(payload)?['type'] as String?;

  List<String> _getAffirmationPool() {
    return [
      "I am worthy of love, success, and happiness in all areas of my life.",
      "Every challenge I face is an opportunity for growth and learning.",
      "I trust my intuition and make decisions with confidence and clarity.",
      "I am grateful for this moment and all the possibilities it holds.",
      "My potential is limitless, and I am constantly evolving into my best self.",
      "I choose peace over worry and love over fear in every situation.",
      "I am resilient, strong, and capable of overcoming any obstacle.",
      "Today I will focus on progress, not perfection, in my journey.",
      "I attract positive energy and opportunities into my life effortlessly.",
      "I am exactly where I need to be, and everything is unfolding perfectly.",
      "My thoughts create my reality, and I choose to think positively.",
      "I release what no longer serves me and embrace new possibilities.",
      "I am connected to my inner wisdom and trust my path forward.",
      "Every breath I take fills me with peace, strength, and purpose.",
      "I celebrate my unique gifts and share them confidently with the world.",
      "I am open to receiving abundance in all forms - love, joy, and prosperity.",
      "My heart is full of gratitude for the lessons and blessings in my life.",
      "I choose to see beauty and opportunity in every experience today.",
      "I am becoming more aligned with my authentic self each day.",
      "I trust the timing of my life and know that everything happens for a reason.",
      "I radiate confidence, kindness, and positive energy wherever I go.",
      "I am worthy of my dreams and have the power to make them reality.",
      "Today I will be gentle with myself and celebrate small victories.",
      "I am surrounded by love and support, even when I cannot see it.",
      "My inner light shines brightly and illuminates the path ahead.",
      "I choose to focus on what I can control and release what I cannot.",
      "I am grateful for my body, mind, and spirit and treat them with respect.",
      "Every day brings new opportunities for joy, growth, and connection.",
      "I trust in my ability to navigate life's challenges with grace and wisdom.",
      "I am a magnet for miracles and positive transformations in my life.",
    ];
  }

  Future<bool> areNotificationsEnabled() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await Permission.notification.isGranted;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.checkPermissions();
      return result?.isEnabled ?? false;
    }
    return false;
  }
}

class _ReminderSchedule {
  const _ReminderSchedule({
    required this.times,
    required this.startDate,
    required this.durationInDays,
    this.text,
  });

  final List<TimeOfDay> times;
  final DateTime startDate;
  final int durationInDays;
  final String? text;
}
