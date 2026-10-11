import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/ai_advisor.dart';
import '../../../../core/utils/inspirational_quotes.dart';

class RelationshipInsightsCard extends StatefulWidget {
  const RelationshipInsightsCard({super.key});

  @override
  State<RelationshipInsightsCard> createState() =>
      _RelationshipInsightsCardState();
}

class _RelationshipInsightsCardState extends State<RelationshipInsightsCard> {
  List<String>? _dailyTips;
  Map<String, String>? _dailyQuote;

  @override
  void initState() {
    super.initState();
    _loadDailyContent();
  }

  void _loadDailyContent() {
    setState(() {
      _dailyTips = AIAdvisor.generateDailyRelationshipTips();
      _dailyQuote = InspirationalQuotes.getDailyQuote();
    });
  }

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
                    color: AppTheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.insights,
                    color: AppTheme.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Relationship Insights',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        'Daily tips and insights for better relationships',
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.secondary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.today, color: AppTheme.secondary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Today\'s Relationship Tip',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_dailyTips != null)
                    Text(
                      _dailyTips!.first,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                      Icon(Icons.favorite, color: AppTheme.accent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Relationship Wisdom',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accent,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Strong relationships are built on trust, communication, and mutual respect. Remember that every relationship requires effort from both people to thrive.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
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
                      Icon(Icons.format_quote,
                          color: AppTheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Daily Inspiration',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_dailyQuote != null) ...[
                    Text(
                      '"${_dailyQuote!['quote']}"',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '— ${_dailyQuote!['author']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loadDailyContent,
                    child: const Text('New Tip'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _showQuotesDialog,
                    child: const Text('More Quotes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQuotesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Inspirational Quotes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Love'),
                          Tab(text: 'Success'),
                          Tab(text: 'Motivation'),
                          Tab(text: 'Wisdom'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildQuotesList('love'),
                            _buildQuotesList('success'),
                            _buildQuotesList('motivation'),
                            _buildQuotesList('wisdom'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuotesList(String category) {
    final quotes = InspirationalQuotes.getQuotesByCategory(category);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        final quote = quotes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${quote['quote']}"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '— ${quote['author']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
