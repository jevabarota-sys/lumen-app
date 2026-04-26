import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/journal_entry_model.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final List<JournalEntryModel> _entries = [
    JournalEntryModel(
      id: '1',
      userId: 'demo_user',
      title: 'Morning Reflection',
      content:
          'Today I felt a strong connection to my inner wisdom during meditation. The number 7 energy seems to be guiding me toward deeper understanding of myself and my purpose.',
      tags: ['meditation', 'wisdom', 'purpose'],
      aiSummary:
          'This entry reflects a spiritual awakening and connection to inner guidance.',
      aiAffirmations: [
        'I trust my inner wisdom to guide me',
        'I am open to spiritual growth and understanding',
        'My intuition leads me to my highest good'
      ],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    JournalEntryModel(
      id: '2',
      userId: 'demo_user',
      title: 'Gratitude Practice',
      content:
          'Grateful for the small moments today - the warm coffee, the smile from a stranger, the way the light filtered through my window. These simple joys remind me of the abundance in my life.',
      tags: ['gratitude', 'mindfulness', 'joy'],
      aiSummary:
          'A beautiful practice of finding joy in everyday moments and cultivating gratitude.',
      aiAffirmations: [
        'I find joy in simple moments',
        'Gratitude fills my heart with abundance',
        'I notice and appreciate life\'s small gifts'
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('AI Reflection Journal'),
        backgroundColor: AppTheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewEntryDialog,
          ),
        ],
      ),
      body: _entries.isEmpty ? _buildEmptyState() : _buildEntriesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewEntryDialog,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.auto_stories,
                size: 60,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Start Your Journey',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onBackground,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Begin documenting your thoughts, feelings, and insights. Our AI will help you discover patterns and provide personalized affirmations.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.onBackground.withOpacity(0.9),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showNewEntryDialog,
              icon: const Icon(Icons.add),
              label: const Text('Write First Entry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        return _buildEntryCard(entry, index);
      },
    );
  }

  Widget _buildEntryCard(JournalEntryModel entry, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showEntryDetails(entry),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Text(
                    _formatDate(entry.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutral,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                entry.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (entry.tags != null && entry.tags!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: entry.tags!.map((tag) => _buildTag(tag)).toList(),
                ),
              ],
              if (entry.aiSummary != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 16,
                        color: AppTheme.accent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.aiSummary!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().slideX(
          begin: index % 2 == 0 ? -0.3 : 0.3,
          duration: const Duration(milliseconds: 600),
          delay: Duration(milliseconds: index * 100),
        );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '#$tag',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.secondary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showNewEntryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NewEntrySheet(
        onSave: (title, content, tags) {
          final newEntry = JournalEntryModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: 'demo_user',
            title: title,
            content: content,
            tags: tags,
            aiSummary: _generateAISummary(content),
            aiAffirmations: _generateAIAffirmations(content),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          setState(() {
            _entries.insert(0, newEntry);
          });
        },
      ),
    );
  }

  void _showEntryDetails(JournalEntryModel entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EntryDetailsSheet(entry: entry),
    );
  }

  String _generateAISummary(String content) {
    if (content.toLowerCase().contains('grateful') ||
        content.toLowerCase().contains('gratitude')) {
      return 'This entry reflects a practice of gratitude and appreciation for life\'s blessings.';
    } else if (content.toLowerCase().contains('meditation') ||
        content.toLowerCase().contains('spiritual')) {
      return 'This entry shows spiritual growth and connection to inner wisdom.';
    } else if (content.toLowerCase().contains('challenge') ||
        content.toLowerCase().contains('difficult')) {
      return 'This entry explores personal challenges and opportunities for growth.';
    } else {
      return 'This entry captures important thoughts and feelings on your personal journey.';
    }
  }

  List<String> _generateAIAffirmations(String content) {
    if (content.toLowerCase().contains('grateful') ||
        content.toLowerCase().contains('gratitude')) {
      return [
        'I am grateful for all the abundance in my life',
        'I notice and appreciate life\'s simple pleasures',
        'Gratitude fills my heart with joy and peace'
      ];
    } else if (content.toLowerCase().contains('meditation') ||
        content.toLowerCase().contains('spiritual')) {
      return [
        'I trust my inner wisdom to guide me',
        'I am connected to my highest self',
        'Spiritual growth flows naturally through me'
      ];
    } else {
      return [
        'I am growing and evolving every day',
        'My thoughts and feelings are valid and important',
        'I am on the perfect path for my journey'
      ];
    }
  }
}

class _NewEntrySheet extends StatefulWidget {
  final Function(String title, String content, List<String> tags) onSave;

  const _NewEntrySheet({required this.onSave});

  @override
  State<_NewEntrySheet> createState() => _NewEntrySheetState();
}

class _NewEntrySheetState extends State<_NewEntrySheet> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.neutral.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'New Entry',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _saveEntry,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Give your entry a title...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Your thoughts...',
                        hintText: 'What\'s on your mind today?',
                        alignLabelWithHint: true,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagController,
                          decoration: const InputDecoration(
                            labelText: 'Add tag',
                            hintText: 'e.g., gratitude, meditation',
                          ),
                          onSubmitted: _addTag,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _addTag(_tagController.text),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  if (_tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _tags
                          .map((tag) => Chip(
                                label: Text(tag),
                                onDeleted: () {
                                  setState(() {
                                    _tags.remove(tag);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _saveEntry() {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      widget.onSave(_titleController.text, _contentController.text, _tags);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }
}

class _EntryDetailsSheet extends StatelessWidget {
  final JournalEntryModel entry;

  const _EntryDetailsSheet({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.neutral.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                  if (entry.tags != null && entry.tags!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Tags',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: entry.tags!
                          .map((tag) => Chip(label: Text('#$tag')))
                          .toList(),
                    ),
                  ],
                  if (entry.aiSummary != null) ...[
                    const SizedBox(height: 24),
                    _buildAISection(
                      context,
                      'AI Summary',
                      entry.aiSummary!,
                      Icons.psychology,
                      AppTheme.accent,
                    ),
                  ],
                  if (entry.aiAffirmations != null &&
                      entry.aiAffirmations!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildAffirmationsSection(context, entry.aiAffirmations!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAISection(BuildContext context, String title, String content,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationsSection(
      BuildContext context, List<String> affirmations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Personal Affirmations',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...affirmations.map((affirmation) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        affirmation,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
