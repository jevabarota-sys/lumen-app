import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ManifestationGuideCard extends StatefulWidget {
  const ManifestationGuideCard({super.key});

  @override
  State<ManifestationGuideCard> createState() => _ManifestationGuideCardState();
}

class _ManifestationGuideCardState extends State<ManifestationGuideCard> {
  bool _isExpanded = false;

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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '369 Manifestation Method',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Nikola Tesla\'s powerful manifestation technique',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.neutral,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How the 369 Method Works:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildStep(
                      context,
                      '1. Morning (6:30 AM)',
                      'Write your manifestation 3 times',
                      'Set your intention for the day with focused energy',
                      Icons.wb_sunny,
                      AppTheme.secondary,
                    ),
                    const SizedBox(height: 12),
                    _buildStep(
                      context,
                      '2. Afternoon (12:30 PM)',
                      'Write your manifestation 6 times',
                      'Reinforce your desire during peak energy hours',
                      Icons.wb_sunny_outlined,
                      AppTheme.accent,
                    ),
                    const SizedBox(height: 12),
                    _buildStep(
                      context,
                      '3. Evening (9:30 PM)',
                      'Write your manifestation 9 times',
                      'Embed your intention into your subconscious before sleep',
                      Icons.nightlight_round,
                      AppTheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppTheme.success.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: AppTheme.success,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pro Tip: Write with intention and emotion. Feel as if your manifestation has already happened!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.success,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    String title,
    String action,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              Text(
                action,
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
    );
  }
}
