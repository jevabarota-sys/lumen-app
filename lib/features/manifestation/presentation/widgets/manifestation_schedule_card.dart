import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ManifestationScheduleCard extends StatelessWidget {
  final int selectedDays;
  final ValueChanged<int> onDaysChanged;
  final List<TimeOfDay> defaultTimes;
  final bool isScheduled;
  final VoidCallback onSchedule;
  final VoidCallback onCancel;

  const ManifestationScheduleCard({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
    required this.defaultTimes,
    required this.isScheduled,
    required this.onSchedule,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: AppTheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Schedule Your 369 Practice',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Text(
              'Daily Reminder Times:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            ...defaultTimes.asMap().entries.map((entry) {
              final index = entry.key;
              final time = entry.value;
              final labels = ['Morning', 'Afternoon', 'Evening'];
              final repetitions = ['3 times', '6 times', '9 times'];
              final icons = [Icons.wb_sunny, Icons.wb_sunny_outlined, Icons.nightlight_round];
              final colors = [AppTheme.secondary, AppTheme.accent, AppTheme.primary];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors[index].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors[index].withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      icons[index],
                      color: colors[index],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${labels[index]} - ${time.format(context)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors[index],
                            ),
                          ),
                          Text(
                            'Write your manifestation ${repetitions[index]}',
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
            }).toList(),
            
            const SizedBox(height: 16),
            
            Text(
              'Duration:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$selectedDays days',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      Text(
                        _getDurationDescription(selectedDays),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutral,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: selectedDays.toDouble(),
                    min: 7,
                    max: 90,
                    divisions: 11,
                    activeColor: AppTheme.primary,
                    inactiveColor: AppTheme.border,
                    onChanged: (value) {
                      onDaysChanged(value.round());
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '7 days',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutral,
                        ),
                      ),
                      Text(
                        '90 days',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutral,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isScheduled ? onCancel : onSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScheduled ? AppTheme.error : AppTheme.primary,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isScheduled ? Icons.cancel : Icons.notifications_active,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isScheduled ? 'Cancel 369 Practice' : 'Start 369 Practice',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDurationDescription(int days) {
    if (days <= 7) return 'Quick start';
    if (days <= 21) return 'Habit building';
    if (days <= 30) return 'Monthly practice';
    if (days <= 60) return 'Deep transformation';
    return 'Life-changing journey';
  }
}
