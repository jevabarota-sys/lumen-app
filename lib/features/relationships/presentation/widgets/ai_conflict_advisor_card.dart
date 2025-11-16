import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/ai_advisor.dart';
import '../../../premium/providers/iap_provider.dart';
import '../../../../shared/widgets/premium_banner.dart';

class AIConflictAdvisorCard extends ConsumerStatefulWidget {
  const AIConflictAdvisorCard({super.key});

  @override
  ConsumerState<AIConflictAdvisorCard> createState() => _AIConflictAdvisorCardState();
}

class _AIConflictAdvisorCardState extends ConsumerState<AIConflictAdvisorCard> {
  final _conflictController = TextEditingController();
  String? _advice;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add listener to rebuild when text changes
    _conflictController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) => _buildCard(context, isPremium),
      loading: () => _buildCard(context, false),
      error: (_, __) => _buildCard(context, false),
    );
  }

  Widget _buildCard(BuildContext context, bool isPremium) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: AppTheme.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Conflict Advisor',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        'Get personalized advice for relationship challenges',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.neutral,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!isPremium) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.lock, color: AppTheme.primary, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Premium Feature',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upgrade to Premium to get personalized AI advice for relationship challenges',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.neutral,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showUpgradeDialog(context),
                      child: const Text('Upgrade to Premium'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              TextField(
                controller: _conflictController,
                decoration: const InputDecoration(
                  labelText: 'Describe your situation',
                  hintText:
                      'Tell me about the conflict or challenge you\'re facing...',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _conflictController.text.trim().isNotEmpty && !_isLoading
                      ? _getAdvice
                      : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.white,
                          ),
                        )
                      : const Text('Get AI Advice'),
                ),
              ),
            ],
            if (_advice != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: AppTheme.accent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'AI Advice',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.accent,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _advice!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
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

  void _getAdvice() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final advice = AIAdvisor.generateConflictAdvice(_conflictController.text);

    setState(() {
      _advice = advice;
      _isLoading = false;
    });
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: const Text(
          'Get unlimited access to AI Conflict Advisor and all premium features for \$9.99/month.',
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
              await iapService.purchasePremium();
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _conflictController.dispose();
    super.dispose();
  }
}
