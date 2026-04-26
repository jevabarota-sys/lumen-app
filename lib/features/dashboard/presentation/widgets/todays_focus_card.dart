import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/daily_focus_generator.dart';

class TodaysFocusCard extends StatefulWidget {
  const TodaysFocusCard({super.key});

  @override
  State<TodaysFocusCard> createState() => _TodaysFocusCardState();
}

class _TodaysFocusCardState extends State<TodaysFocusCard> {
  late Map<String, String> _dailyFocus;
  late String _dailyTip;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _generateDailyFocus();
  }

  void _generateDailyFocus() {
    // Generate AI-powered daily focus
    _dailyFocus = DailyFocusGenerator.generateDailyFocus(
      lifePathNumber: 7, // TODO: Get from user profile
      recentJournalTopics: null, // TODO: Get from recent journal entries
      currentMood: null, // TODO: Get from user's current mood
      date: DateTime.now(),
    );

    _dailyTip = DailyFocusGenerator.generateDailyTip(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.wb_sunny,
                    color: AppTheme.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Today's Focus",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                if (_isCompleted)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            color: AppTheme.success, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Done',
                          style: TextStyle(
                            color: AppTheme.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _dailyFocus['title'] ?? 'Practice Mindful Breathing',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _dailyFocus['description'] ??
                  'Take 10 minutes today to focus on your breath.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurface,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.lightBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: AppTheme.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _dailyTip,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isCompleted
                        ? null
                        : () {
                            setState(() {
                              _isCompleted = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Great job! Keep up the good work! 🌟'),
                                backgroundColor: AppTheme.success,
                              ),
                            );
                          },
                    child: Text(_isCompleted ? 'Completed' : 'Mark Complete'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    context.push(AppRoutes.journal);
                  },
                  child: const Text('Journal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
