import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/ai_advisor.dart';

class AIConflictAdvisorCard extends StatefulWidget {
  const AIConflictAdvisorCard({super.key});

  @override
  State<AIConflictAdvisorCard> createState() => _AIConflictAdvisorCardState();
}

class _AIConflictAdvisorCardState extends State<AIConflictAdvisorCard> {
  final _conflictController = TextEditingController();
  String? _advice;
  bool _isLoading = false;

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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
            TextField(
              controller: _conflictController,
              decoration: const InputDecoration(
                labelText: 'Describe your situation',
                hintText: 'Tell me about the conflict or challenge you\'re facing...',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _conflictController.text.isNotEmpty && !_isLoading
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
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
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

  @override
  void dispose() {
    _conflictController.dispose();
    super.dispose();
  }
}
