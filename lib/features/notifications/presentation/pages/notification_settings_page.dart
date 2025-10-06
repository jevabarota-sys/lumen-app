import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/notification_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final NotificationService _notificationService = NotificationService();
  
  bool _notificationsEnabled = false;
  List<TimeOfDay> _reminderTimes = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 21, minute: 0),
  ];
  int _durationInDays = 30;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final enabled = await _notificationService.areNotificationsEnabled();
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Affirmation Reminders'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard().animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                ),
            const SizedBox(height: 24),
            _buildNotificationToggle().animate().slideX(
                  begin: -0.3,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                ),
            if (_notificationsEnabled) ...[
              const SizedBox(height: 24),
              _buildReminderTimesSection().animate().slideX(
                    begin: 0.3,
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                  ),
              const SizedBox(height: 24),
              _buildDurationSection().animate().slideX(
                    begin: -0.3,
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 600),
                  ),
              const SizedBox(height: 32),
              _buildActionButtons().animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 800),
                  ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary.withOpacity(0.1), AppTheme.accent.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active, color: AppTheme.primary, size: 28),
              const SizedBox(width: 12),
              Text(
                'Daily Affirmations',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Receive personalized affirmations throughout your day to support your growth journey. Set multiple reminders and schedule them months in advance.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.neutral,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Icon(
            _notificationsEnabled ? Icons.notifications : Icons.notifications_off,
            color: _notificationsEnabled ? AppTheme.primary : AppTheme.neutral,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enable Affirmation Reminders',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _notificationsEnabled 
                      ? 'Reminders are active'
                      : 'Turn on to receive daily affirmations',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.neutral,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderTimesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Reminder Times',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_reminderTimes.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: AppTheme.primary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _reminderTimes[index].format(context),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _reminderTimes.length > 1 ? () => _removeTime(index) : null,
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: _reminderTimes.length > 1 ? AppTheme.error : AppTheme.neutral.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          if (_reminderTimes.length < 6)
            TextButton.icon(
              onPressed: _addTime,
              icon: Icon(Icons.add, color: AppTheme.primary),
              label: Text(
                'Add Another Time',
                style: TextStyle(color: AppTheme.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDurationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Duration',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Schedule reminders for $_durationInDays days',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Slider(
            value: _durationInDays.toDouble(),
            min: 7,
            max: 365,
            divisions: 51,
            activeColor: AppTheme.primary,
            label: '$_durationInDays days',
            onChanged: (value) {
              setState(() {
                _durationInDays = value.round();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1 week', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral)),
              Text('1 year', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.neutral)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _scheduleReminders,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Schedule Affirmation Reminders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isLoading ? null : _cancelAllReminders,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.error,
              side: BorderSide(color: AppTheme.error),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancel All Reminders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      await _notificationService.initialize();
      final enabled = await _notificationService.areNotificationsEnabled();
      setState(() {
        _notificationsEnabled = enabled;
      });
      
      if (!enabled) {
        _showPermissionDialog();
      }
    } else {
      await _notificationService.cancelAllAffirmationReminders();
      setState(() {
        _notificationsEnabled = false;
      });
    }
  }

  Future<void> _selectTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTimes[index],
    );
    
    if (picked != null) {
      setState(() {
        _reminderTimes[index] = picked;
      });
    }
  }

  void _addTime() {
    if (_reminderTimes.length < 6) {
      setState(() {
        _reminderTimes.add(const TimeOfDay(hour: 12, minute: 0));
      });
    }
  }

  void _removeTime(int index) {
    if (_reminderTimes.length > 1) {
      setState(() {
        _reminderTimes.removeAt(index);
      });
    }
  }

  Future<void> _scheduleReminders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reminderDateTimes = _reminderTimes.map((time) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, time.hour, time.minute);
      }).toList();

      await _notificationService.scheduleAffirmationReminders(
        reminderTimes: reminderDateTimes,
        durationInDays: _durationInDays,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scheduled ${_reminderTimes.length} daily reminders for $_durationInDays days!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to schedule reminders: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelAllReminders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _notificationService.cancelAllAffirmationReminders();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All reminders have been cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel reminders: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Permission'),
        content: const Text(
          'To receive affirmation reminders, please enable notifications in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
