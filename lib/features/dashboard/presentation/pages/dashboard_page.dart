import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/premium_banner.dart';
import '../../../premium/providers/iap_provider.dart';
import '../widgets/todays_focus_card.dart';
import '../widgets/growth_paths_card.dart';
import '../widgets/journal_preview_card.dart';
import '../widgets/quick_actions_grid.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testPremiumMode = ref.watch(testPremiumModeProvider);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Good Morning',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.neutral,
                  ),
            ),
            Text(
              'Sarah',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          // Settings Button
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push(AppRoutes.settings);
            },
            tooltip: 'Settings',
          ),
          // Menu Button
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              context.push(AppRoutes.menu);
            },
            tooltip: 'Features Menu',
          ),
          // Premium Test Button
          IconButton(
            icon: Icon(
              testPremiumMode ? Icons.star : Icons.star_outline,
              color: testPremiumMode ? Colors.amber : null,
            ),
            onPressed: () {
              ref.read(testPremiumModeProvider.notifier).state = !testPremiumMode;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    testPremiumMode 
                      ? 'Premium Test Mode: OFF' 
                      : 'Premium Test Mode: ON',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Toggle Premium Test Mode',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              context.push(AppRoutes.notificationSettings);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outlined),
            onPressed: () => _showProfileMenu(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PremiumBanner().animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                ),
            const SizedBox(height: 24),
            const TodaysFocusCard().animate().slideX(
                  begin: -0.3,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                ),
            const SizedBox(height: 16),
            const GrowthPathsCard().animate().slideX(
                  begin: 0.3,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 400),
                ),
            const SizedBox(height: 16),
            const JournalPreviewCard().animate().slideX(
                  begin: -0.3,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 600),
                ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onBackground,
                  ),
            ),
            const SizedBox(height: 16),
            const QuickActionsGrid().animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 800),
                ),
          ],
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              subtitle: const Text('jevabarota@gmail.com'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Support'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.support);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _showSettingsDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteAccountDialog(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoutes.auth);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Push Notifications'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Email Notifications'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion request submitted. You will receive a confirmation email.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
