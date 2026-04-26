import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

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

    await cancelAllAffirmationReminders();

    final affirmations = _getAffirmationPool();
    final random = Random();

    for (int day = 0; day < durationInDays; day++) {
      for (int timeIndex = 0; timeIndex < reminderTimes.length; timeIndex++) {
        final reminderTime = reminderTimes[timeIndex];
        final scheduledDate = DateTime.now().add(Duration(days: day));
        final scheduledDateTime = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          reminderTime.hour,
          reminderTime.minute,
        );

        if (scheduledDateTime.isBefore(DateTime.now())) continue;

        final affirmation = customAffirmation ??
            affirmations[random.nextInt(affirmations.length)];

        final notificationId = _generateNotificationId(day, timeIndex);

        await _scheduleNotification(
          id: notificationId,
          title: '✨ Your Daily Affirmation',
          body: affirmation,
          scheduledDate: scheduledDateTime,
          payload: jsonEncode({
            'type': 'affirmation',
            'day': day,
            'timeIndex': timeIndex,
            'affirmation': affirmation,
          }),
        );
      }
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
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleWeeklyAffirmationReminders({
    required List<DateTime> reminderTimes,
    required int durationInWeeks,
  }) async {
    if (!_isInitialized) await initialize();

    await cancelAllAffirmationReminders();

    final affirmations = _getAffirmationPool();
    final random = Random();

    for (int week = 0; week < durationInWeeks; week++) {
      for (int day = 0; day < 7; day++) {
        for (int timeIndex = 0; timeIndex < reminderTimes.length; timeIndex++) {
          final reminderTime = reminderTimes[timeIndex];
          final scheduledDate =
              DateTime.now().add(Duration(days: week * 7 + day));
          final scheduledDateTime = DateTime(
            scheduledDate.year,
            scheduledDate.month,
            scheduledDate.day,
            reminderTime.hour,
            reminderTime.minute,
          );

          if (scheduledDateTime.isBefore(DateTime.now())) continue;

          final affirmation = affirmations[random.nextInt(affirmations.length)];
          final notificationId =
              _generateNotificationId(week * 7 + day, timeIndex);

          await _scheduleNotification(
            id: notificationId,
            title: '🌟 Growth Reminder',
            body: affirmation,
            scheduledDate: scheduledDateTime,
            payload: jsonEncode({
              'type': 'weekly_affirmation',
              'week': week,
              'day': day,
              'timeIndex': timeIndex,
              'affirmation': affirmation,
            }),
          );
        }
      }
    }
  }

  Future<void> schedule369ManifestationReminders({
    required String manifestationText,
    required List<DateTime> reminderTimes,
    required int durationInDays,
  }) async {
    if (!_isInitialized) await initialize();

    await cancel369ManifestationReminders();

    final repetitions = [3, 6, 9]; // 369 method repetitions
    final timeLabels = ['Morning', 'Afternoon', 'Evening'];

    for (int day = 0; day < durationInDays; day++) {
      for (int timeIndex = 0;
          timeIndex < reminderTimes.length && timeIndex < 3;
          timeIndex++) {
        final reminderTime = reminderTimes[timeIndex];
        final scheduledDate = DateTime.now().add(Duration(days: day));
        final scheduledDateTime = DateTime(
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          reminderTime.hour,
          reminderTime.minute,
        );

        if (scheduledDateTime.isBefore(DateTime.now())) continue;

        final notificationId = _generate369NotificationId(day, timeIndex);
        final reps = repetitions[timeIndex];
        final timeLabel = timeLabels[timeIndex];

        await _scheduleNotification(
          id: notificationId,
          title: '✨ 369 Manifestation - $timeLabel',
          body: 'Write your manifestation $reps times: "$manifestationText"',
          scheduledDate: scheduledDateTime,
          payload: jsonEncode({
            'type': '369_manifestation',
            'day': day,
            'timeIndex': timeIndex,
            'repetitions': reps,
            'manifestationText': manifestationText,
            'timeLabel': timeLabel,
          }),
        );
      }
    }
  }

  Future<void> cancel369ManifestationReminders() async {
    final pendingNotifications = await getPendingNotifications();
    for (final notification in pendingNotifications) {
      if (notification.payload?.contains('"type":"369_manifestation"') ==
          true) {
        await _notifications.cancel(notification.id);
      }
    }
  }

  Future<void> cancelAllAffirmationReminders() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelSpecificReminder(int id) async {
    await _notifications.cancel(id);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  int _generateNotificationId(int day, int timeIndex) {
    return (day * 100) + timeIndex;
  }

  int _generate369NotificationId(int day, int timeIndex) {
    return 50000 +
        (day * 100) +
        timeIndex; // Different range for 369 notifications
  }

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
