import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ManifestationScheduleCard extends StatefulWidget {
  final int selectedDays;
  final ValueChanged<int> onDaysChanged;
  final List<TimeOfDay> defaultTimes;
  final bool isScheduled;
  final VoidCallback onSchedule;
  final VoidCallback onCancel;
  final ValueChanged<List<TimeOfDay>>? onTimesChanged;
  final ValueChanged<String>? onSoundChanged;

  const ManifestationScheduleCard({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
    required this.defaultTimes,
    required this.isScheduled,
    required this.onSchedule,
    required this.onCancel,
    this.onTimesChanged,
    this.onSoundChanged,
  });

  @override
  State<ManifestationScheduleCard> createState() =>
      _ManifestationScheduleCardState();
}

class _ManifestationScheduleCardState extends State<ManifestationScheduleCard> {
  late List<TimeOfDay> _selectedTimes;
  String _selectedSound = 'Calm Bell';

  final List<String> _availableSounds = [
    'Calm Bell',
    'Gentle Chime',
    'Soft Gong',
    'Crystal Bowl',
    'Wind Chimes',
    'Tibetan Bell',
    'Ocean Wave',
    'Forest Birds',
    'Meditation Tone',
    'Zen Garden',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTimes = List.from(widget.defaultTimes);
  }

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
            ..._selectedTimes.asMap().entries.map((entry) {
              final index = entry.key;
              final time = entry.value;
              final labels = ['Morning', 'Afternoon', 'Evening'];
              final repetitions = ['3 times', '6 times', '9 times'];
              final icons = [
                Icons.wb_sunny,
                Icons.wb_sunny_outlined,
                Icons.nightlight_round
              ];
              final colors = [
                AppTheme.secondary,
                AppTheme.accent,
                AppTheme.primary
              ];

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors[index].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors[index].withOpacity(0.3)),
                ),
                child: InkWell(
                  onTap: widget.isScheduled
                      ? null
                      : () => _selectTime(context, index),
                  borderRadius: BorderRadius.circular(8),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colors[index],
                                  ),
                            ),
                            Text(
                              'Write your manifestation ${repetitions[index]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.neutral,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (!widget.isScheduled)
                        Icon(
                          Icons.edit,
                          color: colors[index],
                          size: 16,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            Text(
              'Notification Sound:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: DropdownButton<String>(
                value: _selectedSound,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.music_note),
                items: _availableSounds.map((sound) {
                  return DropdownMenuItem<String>(
                    value: sound,
                    child: Row(
                      children: [
                        Icon(Icons.volume_up,
                            size: 16, color: AppTheme.primary),
                        const SizedBox(width: 8),
                        Text(sound),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: widget.isScheduled
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSound = value;
                          });
                          widget.onSoundChanged?.call(value);
                        }
                      },
              ),
            ),
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
                        '${widget.selectedDays} days',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                      ),
                      Text(
                        _getDurationDescription(widget.selectedDays),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.neutral,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: widget.selectedDays.toDouble(),
                    min: 7,
                    max: 90,
                    divisions: 11,
                    activeColor: AppTheme.primary,
                    inactiveColor: AppTheme.border,
                    onChanged: (value) {
                      widget.onDaysChanged(value.round());
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
                onPressed:
                    widget.isScheduled ? widget.onCancel : widget.onSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.isScheduled ? AppTheme.error : AppTheme.primary,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.isScheduled
                          ? Icons.cancel
                          : Icons.notifications_active,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isScheduled
                          ? 'Cancel 369 Practice'
                          : 'Start 369 Practice',
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

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimes[index],
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: AppTheme.white,
              surface: AppTheme.surface,
              onSurface: AppTheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTimes[index]) {
      setState(() {
        _selectedTimes[index] = picked;
      });
      widget.onTimesChanged?.call(_selectedTimes);
    }
  }
}
