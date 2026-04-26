import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../premium/providers/iap_provider.dart';

class AppMenuPage extends ConsumerWidget {
  const AppMenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Features'),
        backgroundColor: AppTheme.surface,
      ),
      body: isPremiumAsync.when(
        data: (isPremium) => _buildMenu(context, ref, isPremium),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildMenu(context, ref, false),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, WidgetRef ref, bool isPremium) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Free Features Section
          _buildSectionHeader(context, 'Free Features', '\$0/month'),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            icon: Icons.dashboard,
            title: 'Basic Dashboard',
            description: 'Access your personalized dashboard',
            isFree: true,
            isPremium: isPremium,
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.dashboard);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.auto_awesome,
            title: 'Daily Tarot Card',
            description: 'Draw one tarot card per day',
            isFree: true,
            isPremium: isPremium,
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.tarot);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.calculate,
            title: 'Basic Numerology',
            description: 'Calculate your core numbers',
            isFree: true,
            isPremium: isPremium,
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.numerology);
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.book,
            title: 'Limited Journal Entries',
            description:
                'Up to ${AppConstants.maxFreeJournalEntries} journal entries',
            isFree: true,
            isPremium: isPremium,
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.journal);
            },
          ),

          const SizedBox(height: 32),

          // Premium Features Section
          _buildSectionHeader(context, 'Premium Features', '\$9.99/month'),
          const SizedBox(height: 12),
          _buildMenuItem(
            context,
            icon: Icons.dashboard_customize,
            title: 'Full Dashboard with AI Insights',
            description: 'Advanced AI-powered personalized insights',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              if (isPremium) {
                Navigator.pop(context);
                context.go(AppRoutes.dashboard);
              } else {
                _showUpgradeDialog(context, ref);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.auto_awesome,
            title: 'Unlimited Tarot & Angel Cards',
            description: 'Unlimited card draws with detailed AI readings',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              if (isPremium) {
                Navigator.pop(context);
                context.push(AppRoutes.tarot);
              } else {
                _showUpgradeDialog(context, ref);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.calculate,
            title: 'Advanced Numerology Forecasts',
            description: 'Detailed forecasts and compatibility analysis',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              if (isPremium) {
                Navigator.pop(context);
                context.push(AppRoutes.numerology);
              } else {
                _showUpgradeDialog(context, ref);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.book,
            title: 'Unlimited AI Journal Entries',
            description: 'Unlimited entries with AI reflection',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              if (isPremium) {
                Navigator.pop(context);
                context.push(AppRoutes.journal);
              } else {
                _showUpgradeDialog(context, ref);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.auto_fix_high,
            title: '369 Manifestation Method',
            description: 'Daily reminders with custom times & sounds',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              if (isPremium) {
                Navigator.pop(context);
                context.push(AppRoutes.manifestation369);
              } else {
                _showUpgradeDialog(context, ref);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.notifications_active,
            title: 'Personalized Affirmation Notifications',
            description: 'Custom push notifications with affirmations',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              if (isPremium) {
                Navigator.pop(context);
                context.push(AppRoutes.notificationSettings);
              } else {
                _showUpgradeDialog(context, ref);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.favorite,
            title: 'Relationship Compatibility Calculator',
            description: 'Romantic & friendship compatibility analysis',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              if (isPremium) {
                Navigator.pop(context);
                context.push(AppRoutes.relationships);
              } else {
                _showUpgradeDialog(context, ref);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.psychology,
            title: 'AI Conflict Resolution Advisor',
            description: 'Get AI-powered relationship advice',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              if (isPremium) {
                Navigator.pop(context);
                context.push(AppRoutes.relationships);
              } else {
                _showUpgradeDialog(context, ref);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.format_quote,
            title: 'Daily Inspirational Quotes',
            description: 'Access to full quote library',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              if (isPremium) {
                Navigator.pop(context);
                context.push(AppRoutes.relationships);
              } else {
                _showUpgradeDialog(context, ref);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.support_agent,
            title: 'Priority Support',
            description: 'Get faster response times',
            isFree: false,
            isPremium: isPremium,
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.support);
            },
          ),

          const SizedBox(height: 32),

          if (!isPremium) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showUpgradeDialog(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Upgrade to Premium - \$9.99/month',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
          ),
          const Spacer(),
          Text(
            price,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isFree,
    required bool isPremium,
    required VoidCallback onTap,
  }) {
    final isLocked = !isFree && !isPremium;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLocked
                      ? AppTheme.neutral.withOpacity(0.1)
                      : AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isLocked ? AppTheme.neutral : AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isLocked ? AppTheme.neutral : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.neutral,
                          ),
                    ),
                  ],
                ),
              ),
              if (isLocked)
                Icon(
                  Icons.lock,
                  color: AppTheme.neutral,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unlock all Premium features for \$9.99/month:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildFeatureBullet('Unlimited tarot & angel cards'),
            _buildFeatureBullet('Advanced AI insights'),
            _buildFeatureBullet('369 manifestation method'),
            _buildFeatureBullet('Relationship compatibility'),
            _buildFeatureBullet('AI conflict advisor'),
            _buildFeatureBullet('Daily inspirational quotes'),
            _buildFeatureBullet('Priority support'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final iapService = ref.read(iapServiceProvider);
              final success = await iapService.purchasePremium();
              if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Unable to start purchase. Please try again.'),
                  ),
                );
              }
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppTheme.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
