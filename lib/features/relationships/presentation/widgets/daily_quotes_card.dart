import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/inspirational_quotes.dart';

class DailyQuotesCard extends StatefulWidget {
  const DailyQuotesCard({super.key});

  @override
  State<DailyQuotesCard> createState() => _DailyQuotesCardState();
}

class _DailyQuotesCardState extends State<DailyQuotesCard> {
  Map<String, String>? _currentQuote;

  @override
  void initState() {
    super.initState();
    _loadDailyQuote();
  }

  void _loadDailyQuote() {
    setState(() {
      _currentQuote = InspirationalQuotes.getDailyQuote();
    });
  }

  void _getRandomQuote() {
    setState(() {
      _currentQuote = InspirationalQuotes.getRandomQuote();
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
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.format_quote,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Inspiration',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Wisdom from successful leaders and thinkers',
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
            if (_currentQuote != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote,
                      color: AppTheme.primary,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentQuote!['quote']!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          '— ${_currentQuote!['author']}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _getRandomQuote,
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Quote'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showAllQuotes,
                    icon: const Icon(Icons.library_books),
                    label: const Text('Browse All'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAllQuotes() {
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
                    'Inspirational Quotes Collection',
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
                  length: 5,
                  child: Column(
                    children: [
                      const TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(text: 'All'),
                          Tab(text: 'Love & Relationships'),
                          Tab(text: 'Success'),
                          Tab(text: 'Motivation'),
                          Tab(text: 'Wisdom'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildQuotesList(InspirationalQuotes.getAllQuotes()),
                            _buildQuotesList(InspirationalQuotes.getQuotesByCategory('love')),
                            _buildQuotesList(InspirationalQuotes.getQuotesByCategory('success')),
                            _buildQuotesList(InspirationalQuotes.getQuotesByCategory('motivation')),
                            _buildQuotesList(InspirationalQuotes.getQuotesByCategory('wisdom')),
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

  Widget _buildQuotesList(List<Map<String, String>> quotes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        final quote = quotes[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              setState(() {
                _currentQuote = quote;
              });
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(12),
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
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        '— ${quote['author']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
