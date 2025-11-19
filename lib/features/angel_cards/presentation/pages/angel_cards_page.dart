import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/angel_card_engine.dart';
import '../../../premium/providers/iap_provider.dart';
import '../../../../shared/widgets/angel_card_widget.dart';

class AngelCardsPage extends ConsumerStatefulWidget {
  const AngelCardsPage({super.key});

  @override
  ConsumerState<AngelCardsPage> createState() => _AngelCardsPageState();
}

class _AngelCardsPageState extends ConsumerState<AngelCardsPage> {
  List<Map<String, String>>? _drawnCards;
  bool _isDrawing = false;
  int _selectedSpread = 1; // 1 or 3 cards
  String? _aiSummary;

  @override
  Widget build(BuildContext context) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Angel Cards'),
        backgroundColor: AppTheme.surface,
      ),
      body: isPremiumAsync.when(
        data: (isPremium) => _buildContent(context, isPremium),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildContent(context, false),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isPremium) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroCard().animate().fadeIn(
                duration: const Duration(milliseconds: 600),
              ),
          const SizedBox(height: 24),
          _buildSpreadSelector(isPremium).animate().slideX(
                begin: -0.3,
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
              ),
          const SizedBox(height: 24),
          _buildDrawButton(isPremium).animate().fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
              ),
          if (_drawnCards != null) ...[
            const SizedBox(height: 32),
            ..._drawnCards!.asMap().entries.map((entry) {
              final index = entry.key;
              final card = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCardResult(card, index).animate().fadeIn(
                      duration: const Duration(milliseconds: 600),
                      delay: Duration(milliseconds: 600 + (index * 200)),
                    ),
              );
            }).toList(),
            if (_selectedSpread == 3 && _aiSummary != null) ...[
              const SizedBox(height: 24),
              _buildAISummary().animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 1200),
                  ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _drawnCards = null;
                    _aiSummary = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('New Draw'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
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
                    Icons.auto_awesome,
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
                        'Angel Card Reading',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Receive divine guidance from your angels',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.neutral,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Angel cards are a powerful tool for receiving messages of love, guidance, and support from the angelic realm. Each card carries a specific energy and message to help you on your spiritual journey.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpreadSelector(bool isPremium) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Spread',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSpreadOption(
                    context,
                    count: 1,
                    title: 'Single Card',
                    description: 'Quick daily guidance',
                    isLocked: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSpreadOption(
                    context,
                    count: 3,
                    title: '3-Card Spread',
                    description: 'Past, Present, Future',
                    isLocked: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpreadOption(
    BuildContext context, {
    required int count,
    required String title,
    required String description,
    required bool isLocked,
  }) {
    final isSelected = _selectedSpread == count;

    return InkWell(
      onTap: isLocked
          ? () => _showPremiumDialog(context)
          : () {
              setState(() {
                _selectedSpread = count;
                _drawnCards = null;
              });
            },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.1)
              : AppTheme.lightBlue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            if (isLocked)
              Icon(Icons.lock, color: AppTheme.neutral, size: 20)
            else
              Icon(
                Icons.auto_awesome,
                color: isSelected ? AppTheme.primary : AppTheme.neutral,
                size: 20,
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppTheme.primary : null,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutral,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawButton(bool isPremium) {
    final canDraw = true; // Allow all spreads for now

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isDrawing
            ? null
            : canDraw
                ? _drawCards
                : () => _showPremiumDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: AppTheme.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isDrawing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Draw ${_selectedSpread == 1 ? "Card" : "Cards"}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCardResult(Map<String, String> card, int index) {
    final labels = ['Past', 'Present', 'Future'];
    final colors = [AppTheme.secondary, AppTheme.accent, AppTheme.primary];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_selectedSpread == 3) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors[index].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  labels[index],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors[index],
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            // Beautiful angel card widget
            AngelCardWidget(
              cardName: card['name']!,
              message: card['message']!,
              isRevealed: true,
              width: 200,
              height: 320,
            ),
            const SizedBox(height: 24),
            // Message section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.secondary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.message, color: AppTheme.secondary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Message',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card['message']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Guidance section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: AppTheme.accent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Guidance',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accent,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card['guidance']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAISummary() {
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
                    color: AppTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: AppTheme.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Summary & Guidance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _aiSummary ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _drawCards() async {
    setState(() {
      _isDrawing = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final cards = AngelCardEngine.drawCards(
      count: _selectedSpread,
      isRandom: true,
    );

    // Generate AI summary for 3-card spreads
    String? summary;
    if (_selectedSpread == 3 && cards.length == 3) {
      summary = _generateAISummary(cards);
    }

    setState(() {
      _drawnCards = cards;
      _aiSummary = summary;
      _isDrawing = false;
    });
  }

  String _generateAISummary(List<Map<String, String>> cards) {
    final cardNames = cards.map((c) => c['name']).join(', ');
    
    return 'Your three angel cards (${cardNames}) reveal a powerful message about your spiritual journey. '
        'The Past card shows the foundation you\'ve built and lessons learned. '
        'The Present card illuminates your current path and what requires your attention now. '
        'The Future card offers guidance on where your journey is leading. '
        'Together, these angels encourage you to trust in divine timing, stay open to guidance, '
        'and remember that you are supported every step of the way. '
        'Pay special attention to recurring themes across all three cards - '
        'these are the areas where the angels are calling you to focus your energy and intention.';
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text(
          '3-card angel spreads are available with Premium. Upgrade now to unlock unlimited angel card readings and all Premium features!',
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
              final success = await iapService.purchasePremium();
              if (!success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unable to start purchase. Please try again.'),
                  ),
                );
              }
            },
            child: const Text('Upgrade to Premium'),
          ),
        ],
      ),
    );
  }
}
