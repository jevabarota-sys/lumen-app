import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/tarot_engine.dart';
import '../../../../shared/widgets/tarot_card_widget.dart';

class TarotPage extends StatefulWidget {
  const TarotPage({super.key});

  @override
  State<TarotPage> createState() => _TarotPageState();
}

class _TarotPageState extends State<TarotPage> {
  List<TarotCardData>? _drawnCards;
  String? _aiReflection;
  bool _isOneCardSpread = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Tarot Reading'),
        backgroundColor: AppTheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpreadSelector(),
            const SizedBox(height: 24),
            if (_drawnCards == null)
              _buildDrawSection()
            else
              _buildReadingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpreadSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Spread',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSpreadOption(
                    'One Card',
                    'Daily guidance',
                    Icons.crop_portrait,
                    _isOneCardSpread,
                    () => setState(() => _isOneCardSpread = true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSpreadOption(
                    'Three Card',
                    'Past, Present, Future',
                    Icons.view_column,
                    !_isOneCardSpread,
                    () => setState(() => _isOneCardSpread = false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 600));
  }

  Widget _buildSpreadOption(String title, String subtitle, IconData icon,
      bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.1)
              : AppTheme.background,
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.neutral.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.onBackground,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        isSelected ? AppTheme.primary : AppTheme.onBackground,
                  ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppTheme.neutral
                        : AppTheme.onBackground.withOpacity(0.85),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 180,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppTheme.white,
                size: 48,
              ),
            ).animate().scale(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 24),
            Text(
              'Draw Your Cards',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Focus on your question and draw your ${_isOneCardSpread ? 'daily guidance card' : 'three-card spread'}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.neutral,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _drawCards,
                child: Text('Draw ${_isOneCardSpread ? '1 Card' : '3 Cards'}'),
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(
          begin: 0.3,
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
        );
  }

  Widget _buildReadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardsDisplay(),
        const SizedBox(height: 24),
        _buildReflectionCard(),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _drawnCards = null;
                _aiReflection = null;
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
    );
  }

  Widget _buildCardsDisplay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isOneCardSpread ? 'Your Daily Card' : 'Your Three-Card Reading',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (_isOneCardSpread)
              _buildSingleCard(_drawnCards!.first)
            else
              _buildThreeCardSpread(),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
        );
  }

  Widget _buildSingleCard(TarotCardData card) {
    return Center(
      child: Column(
        children: [
          TarotCardWidget(
            card: card,
            isRevealed: true,
            width: 200,
            height: 320,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: Text(
              card.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.onSurface,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeCardSpread() {
    final positions = ['Past', 'Present', 'Future'];
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    TarotCardWidget(
                      card: _drawnCards![index],
                      isRevealed: true,
                      width: 140,
                      height: 220,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppTheme.secondary.withOpacity(0.3)),
                      ),
                      child: Text(
                        positions[index],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondary,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(_drawnCards!.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.secondary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          positions[index],
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.secondary,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _drawnCards![index].name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _drawnCards![index].description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.onSurface,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReflectionCard() {
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
                  'AI Reflection',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _aiReflection ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 400),
        );
  }

  void _drawCards() {
    final userId = 'demo_user';
    final today = DateTime.now();
    final numberOfCards = _isOneCardSpread ? 1 : 3;

    // Always use random draws (isRandom: true)
    final cards =
        TarotEngine.drawCards(userId, today, numberOfCards, isRandom: true);
    final reflection = TarotEngine.generateAIReflection(
        cards, _isOneCardSpread ? 'one_card' : 'three_card');

    setState(() {
      _drawnCards = cards;
      _aiReflection = reflection;
    });
  }
}
