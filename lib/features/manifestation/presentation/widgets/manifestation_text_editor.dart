import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ManifestationTextEditor extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onAIGenerate;

  const ManifestationTextEditor({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onAIGenerate,
  });

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
                  Icons.edit,
                  color: AppTheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Your Manifestation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAIGenerate,
                  icon: Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: AppTheme.secondary,
                  ),
                  label: Text(
                    'AI Inspire',
                    style: TextStyle(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your manifestation in present tense...\n\nExample: "I am attracting abundance and success into my life with ease and gratitude."',
                  hintStyle: TextStyle(
                    color: AppTheme.neutral.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    color: AppTheme.secondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tips: Use present tense, be specific, include emotions, and keep it positive!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Character count: ${controller.text.length}/200',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: controller.text.length > 200 
                    ? AppTheme.error 
                    : AppTheme.neutral.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
