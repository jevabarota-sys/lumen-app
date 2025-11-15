import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../premium/providers/iap_provider.dart';

class QuickActionsGrid extends ConsumerWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);
    
    return isPremiumAsync.when(
      data: (isPremium) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _buildActionCard(
            context,
            'Numerology',
            'Calculate your numbers',
            Icons.calculate,
            AppTheme.primary,
            () => context.push(AppRoutes.numerology),
            isPremium: true,
          ),
          _buildActionCard(
            context,
            'Tarot Reading',
            'Draw your daily cards',
            Icons.auto_awesome,
            AppTheme.secondary,
            () => context.push(AppRoutes.tarot),
            isPremium: true,
          ),
          _buildActionCard(
            context,
            'Angel Cards',
            'Divine guidance & messages',
            Icons.auto_awesome,
            AppTheme.accent,
            () => context.push(AppRoutes.angelCards),
            isPremium: true,
          ),
          _buildActionCard(
            context,
            '369 Manifestation',
            'Tesla\'s powerful method',
            Icons.auto_fix_high,
            AppTheme.lightPink,
            isPremium 
              ? () => context.push(AppRoutes.manifestation369)
              : () => _showPremiumDialog(context),
            isPremium: isPremium,
            isPremiumFeature: true,
          ),
          _buildActionCard(
            context,
            'Relationships',
            'Compatibility & growth',
            Icons.favorite,
            AppTheme.accent,
            () => context.push(AppRoutes.relationships),
            isPremium: true,
          ),
          _buildActionCard(
            context,
            'Journal',
            'AI reflection & insights',
            Icons.book,
            AppTheme.mediumBlue,
            () => context.push(AppRoutes.journal),
            isPremium: true,
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _buildActionCard(context, 'Numerology', 'Calculate your numbers', Icons.calculate, AppTheme.primary, () => context.push(AppRoutes.numerology), isPremium: true),
          _buildActionCard(context, 'Tarot Reading', 'Draw your daily cards', Icons.auto_awesome, AppTheme.secondary, () => context.push(AppRoutes.tarot), isPremium: true),
          _buildActionCard(context, 'Angel Cards', 'Divine guidance & messages', Icons.auto_awesome, AppTheme.accent, () => context.push(AppRoutes.angelCards), isPremium: true),
          _buildActionCard(context, '369 Manifestation', 'Tesla\'s powerful method', Icons.auto_fix_high, AppTheme.lightPink, () => context.push(AppRoutes.manifestation369), isPremium: true),
          _buildActionCard(context, 'Relationships', 'Compatibility & growth', Icons.favorite, AppTheme.accent, () => context.push(AppRoutes.relationships), isPremium: true),
          _buildActionCard(context, 'Journal', 'AI reflection & insights', Icons.book, AppTheme.mediumBlue, () => context.push(AppRoutes.journal), isPremium: true),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    required bool isPremium,
    bool isPremiumFeature = false,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutral,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isPremiumFeature && !isPremium)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.lock, size: 12, color: AppTheme.white),
                      SizedBox(width: 4),
                      Text(
                        'Premium',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 10,
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

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text(
          '369 Manifestation Method is a Premium feature.\n\nUpgrade to Premium to unlock:\n• 369 Manifestation with daily reminders\n• AI Conflict Resolution Advisor\n• Advanced Relationship Insights\n• Unlimited tarot & angel cards\n• And much more!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(AppRoutes.premium);
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }
}
