import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class JournalPreviewCard extends StatelessWidget {
  const JournalPreviewCard({super.key});

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
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_stories,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Reflection Journal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push(AppRoutes.journal),
                  child: const Text('Open'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.neutral.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Entry',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.onBackground.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Today I felt a strong connection to my inner wisdom during meditation. The number 7 energy seems to be guiding me toward...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onBackground,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 16,
                        color: AppTheme.onBackground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AI Insight Available',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.onBackground.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.journal),
                icon: const Icon(Icons.add),
                label: const Text('New Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
