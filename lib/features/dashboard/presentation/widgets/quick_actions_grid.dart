import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
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
        ),
        _buildActionCard(
          context,
          'Tarot Reading',
          'Draw your daily cards',
          Icons.auto_awesome,
          AppTheme.secondary,
          () => context.push(AppRoutes.tarot),
        ),
        _buildActionCard(
          context,
          'Angel Cards',
          'Divine guidance & messages',
          Icons.auto_awesome,
          AppTheme.accent,
          () => context.push(AppRoutes.angelCards),
        ),
        _buildActionCard(
          context,
          '369 Manifestation',
          'Tesla\'s powerful method',
          Icons.auto_fix_high,
          AppTheme.lightPink,
          () => context.push(AppRoutes.manifestation369),
        ),
        _buildActionCard(
          context,
          'Relationships',
          'Compatibility & growth',
          Icons.favorite,
          AppTheme.accent,
          () => context.push(AppRoutes.relationships),
        ),
        _buildActionCard(
          context,
          'Journal',
          'AI reflection & insights',
          Icons.book,
          AppTheme.mediumBlue,
          () => context.push(AppRoutes.journal),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
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
      ),
    );
  }
}
