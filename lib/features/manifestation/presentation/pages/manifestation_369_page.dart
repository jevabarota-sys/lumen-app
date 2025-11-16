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
  final TextEditingController _manifestationController = TextEditingController();
  final NotificationService _notificationService = NotificationService();
  
  bool _isScheduled = false;
  int _selectedDays = 21; // Default 21 days for manifestation
  String _manifestationText = '';
  String _selectedSound = 'Calm Bell';
  
  // Default 369 method times: 6:30 AM, 12:30 PM, 9:30 PM
  List<TimeOfDay> _selectedTimes = [
    const TimeOfDay(hour: 6, minute: 30),   // Morning
    const TimeOfDay(hour: 12, minute: 30),  // Afternoon  
    const TimeOfDay(hour: 21, minute: 30),  // Evening
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
      final reminderTimes = _selectedTimes.map((time) => DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        time.hour,
        time.minute,
      )).toList();

      await _notificationService.schedule369ManifestationReminders(
        manifestationText: _manifestationText,
        reminderTimes: reminderTimes,
        durationInDays: _selectedDays,
      );

      setState(() {
        _isScheduled = true;
      });

      _showSnackBar('369 Manifestation reminders scheduled with $_selectedSound sound! 🌟');
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
    
    final randomSuggestion = suggestions[DateTime.now().millisecond % suggestions.length];
    setState(() {
      _manifestationText = randomSuggestion;
      _manifestationController.text = randomSuggestion;
    });
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.auto_fix_high, color: AppTheme.primary),
            const SizedBox(width: 12),
            const Text('369 Manifestation Method'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'What is the 369 Method?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'The 369 manifestation method is based on Nikola Tesla\'s belief in the power of these numbers. It\'s a simple yet powerful technique to manifest your desires into reality.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'How it works:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              _buildInfoBullet(context, '3 times in the morning', 'Write your manifestation 3 times when you wake up'),
              _buildInfoBullet(context, '6 times in the afternoon', 'Write it 6 times during the day'),
              _buildInfoBullet(context, '9 times in the evening', 'Write it 9 times before bed'),
              const SizedBox(height: 16),
              Text(
                'Best Practices:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              _buildInfoBullet(context, 'Be specific', 'Write your desire in present tense as if it\'s already happened'),
              _buildInfoBullet(context, 'Feel the emotion', 'Connect with the feeling of having your desire'),
              _buildInfoBullet(context, 'Stay consistent', 'Practice for 33 or 45 days without skipping'),
              _buildInfoBullet(context, 'Trust the process', 'Let go of attachment to the outcome'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppTheme.accent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Example: "I am living in my dream home filled with love and abundance"',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.accent,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBullet(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutral,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
