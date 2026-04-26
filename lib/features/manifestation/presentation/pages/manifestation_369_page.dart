import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/notification_service.dart';
import '../widgets/manifestation_guide_card.dart';
import '../widgets/manifestation_text_editor.dart';
import '../widgets/manifestation_schedule_card.dart';

class Manifestation369Page extends StatefulWidget {
  const Manifestation369Page({super.key});

  @override
  State<Manifestation369Page> createState() => _Manifestation369PageState();
}

class _Manifestation369PageState extends State<Manifestation369Page> {
  final TextEditingController _manifestationController =
      TextEditingController();
  final NotificationService _notificationService = NotificationService();

  bool _isScheduled = false;
  int _selectedDays = 21; // Default 21 days for manifestation
  String _manifestationText = '';
  String _selectedSound = 'Calm Bell';

  // Default 369 method times: 6:30 AM, 12:30 PM, 9:30 PM
  List<TimeOfDay> _selectedTimes = [
    const TimeOfDay(hour: 6, minute: 30), // Morning
    const TimeOfDay(hour: 12, minute: 30), // Afternoon
    const TimeOfDay(hour: 21, minute: 30), // Evening
  ];

  @override
  void initState() {
    super.initState();
    _manifestationText = _getDefaultManifestationText();
    _manifestationController.text = _manifestationText;
  }

  @override
  void dispose() {
    _manifestationController.dispose();
    super.dispose();
  }

  String _getDefaultManifestationText() {
    return "I am attracting abundance and success into my life with ease and gratitude.";
  }

  Future<void> _schedule369Manifestation() async {
    if (_manifestationText.trim().isEmpty) {
      _showSnackBar('Please enter your manifestation text', isError: true);
      return;
    }

    try {
      final reminderTimes = _selectedTimes
          .map((time) => DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                time.hour,
                time.minute,
              ))
          .toList();

      await _notificationService.schedule369ManifestationReminders(
        manifestationText: _manifestationText,
        reminderTimes: reminderTimes,
        durationInDays: _selectedDays,
      );

      setState(() {
        _isScheduled = true;
      });

      _showSnackBar(
          '369 Manifestation reminders scheduled with $_selectedSound sound! 🌟');
    } catch (e) {
      _showSnackBar('Failed to schedule reminders: $e', isError: true);
    }
  }

  Future<void> _cancelSchedule() async {
    try {
      await _notificationService.cancel369ManifestationReminders();
      setState(() {
        _isScheduled = false;
      });
      _showSnackBar('369 Manifestation reminders cancelled');
    } catch (e) {
      _showSnackBar('Failed to cancel reminders: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.error : AppTheme.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _generateAIManifestationText() {
    // AI-generated manifestation suggestions
    final suggestions = [
      "I am worthy of all the abundance and success flowing into my life right now.",
      "Every day I am becoming more aligned with my highest potential and purpose.",
      "I attract positive opportunities and loving relationships with ease and joy.",
      "My dreams are manifesting into reality faster than I ever imagined possible.",
      "I am grateful for the unlimited prosperity and happiness entering my life.",
      "I radiate confidence, love, and success in everything I do today.",
      "The universe is conspiring to bring me everything I desire and more.",
      "I am a powerful creator, and my thoughts shape my beautiful reality.",
      "Abundance flows to me from multiple sources in expected and unexpected ways.",
      "I trust the process of life and know that everything is working out perfectly.",
    ];

    final randomSuggestion =
        suggestions[DateTime.now().millisecond % suggestions.length];
    setState(() {
      _manifestationText = randomSuggestion;
      _manifestationController.text = randomSuggestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('369 Manifestation Method'),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ManifestationGuideCard().animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                ),
            const SizedBox(height: 24),
            ManifestationTextEditor(
              controller: _manifestationController,
              onChanged: (value) {
                setState(() {
                  _manifestationText = value;
                });
              },
              onAIGenerate: _generateAIManifestationText,
            ).animate().slideX(
                  begin: -0.3,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                ),
            const SizedBox(height: 24),
            ManifestationScheduleCard(
              selectedDays: _selectedDays,
              onDaysChanged: (days) {
                setState(() {
                  _selectedDays = days;
                });
              },
              defaultTimes: _selectedTimes,
              isScheduled: _isScheduled,
              onSchedule: _schedule369Manifestation,
              onCancel: _cancelSchedule,
              onTimesChanged: (times) {
                setState(() {
                  _selectedTimes = times;
                });
              },
              onSoundChanged: (sound) {
                setState(() {
                  _selectedSound = sound;
                });
              },
            ).animate().slideX(
                  begin: 0.3,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 400),
                ),
            const SizedBox(height: 32),
            if (_isScheduled) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.success.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.success,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '369 Method Active!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.success,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You\'ll receive 3 daily reminders for $_selectedDays days',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.success,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 600),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
