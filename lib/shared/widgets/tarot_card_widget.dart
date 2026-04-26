import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/tarot_engine.dart';

/// Beautiful, colorful tarot card widget with gradient backgrounds and icons
class TarotCardWidget extends StatelessWidget {
  final TarotCardData card;
  final bool isRevealed;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const TarotCardWidget({
    super.key,
    required this.card,
    this.isRevealed = true,
    this.onTap,
    this.width = 200,
    this.height = 320,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: isRevealed ? _buildRevealedCard() : _buildCardBack(),
        ),
      ),
    );
  }

  Widget _buildRevealedCard() {
    final gradient = _getCardGradient(card.name);
    final icon = _getCardIcon(card.name);

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // Decorative pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _TarotCardPatternPainter(),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Card number/title at top
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    card.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(),

                // Main icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 64,
                    color: _getIconColor(card.name),
                  ),
                ),

                const Spacer(),

                // Card name at bottom
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    card.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            AppTheme.mediumBlue,
            AppTheme.lightBlue,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _TarotCardBackPainter(),
            ),
          ),

          // Center icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getCardGradient(String cardName) {
    // Different gradients for different card types
    final gradients = {
      'The Fool': LinearGradient(
        colors: [Color(0xFFFFF59D), Color(0xFFFFEB3B), Color(0xFFFFC107)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'The Magician': LinearGradient(
        colors: [Color(0xFFE1BEE7), Color(0xFFBA68C8), Color(0xFF9C27B0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'The High Priestess': LinearGradient(
        colors: [Color(0xFFB3E5FC), Color(0xFF4FC3F7), Color(0xFF0288D1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'The Empress': LinearGradient(
        colors: [Color(0xFFC8E6C9), Color(0xFF81C784), Color(0xFF4CAF50)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'The Emperor': LinearGradient(
        colors: [Color(0xFFFFCCBC), Color(0xFFFF8A65), Color(0xFFFF5722)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'The Lovers': LinearGradient(
        colors: [Color(0xFFF8BBD0), Color(0xFFF06292), Color(0xFFE91E63)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'The Sun': LinearGradient(
        colors: [Color(0xFFFFF9C4), Color(0xFFFFD54F), Color(0xFFFFA000)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'The Moon': LinearGradient(
        colors: [Color(0xFFD1C4E9), Color(0xFF9575CD), Color(0xFF673AB7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'The Star': LinearGradient(
        colors: [Color(0xFFB2EBF2), Color(0xFF4DD0E1), Color(0xFF00BCD4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    };

    return gradients[cardName] ??
        LinearGradient(
          colors: [AppTheme.lightBlue, AppTheme.mediumBlue, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
  }

  IconData _getCardIcon(String cardName) {
    final icons = {
      'The Fool': Icons.hiking,
      'The Magician': Icons.auto_fix_high,
      'The High Priestess': Icons.psychology,
      'The Empress': Icons.spa,
      'The Emperor': Icons.castle,
      'The Hierophant': Icons.menu_book,
      'The Lovers': Icons.favorite,
      'The Chariot': Icons.directions_car,
      'Strength': Icons.fitness_center,
      'The Hermit': Icons.lightbulb,
      'Wheel of Fortune': Icons.casino,
      'Justice': Icons.balance,
      'The Hanged Man': Icons.self_improvement,
      'Death': Icons.transform,
      'Temperance': Icons.water_drop,
      'The Devil': Icons.warning,
      'The Tower': Icons.flash_on,
      'The Star': Icons.star,
      'The Moon': Icons.nightlight,
      'The Sun': Icons.wb_sunny,
      'Judgement': Icons.gavel,
      'The World': Icons.public,
    };

    return icons[cardName] ?? Icons.auto_awesome;
  }

  Color _getIconColor(String cardName) {
    final colors = {
      'The Fool': Color(0xFFF57C00),
      'The Magician': Color(0xFF7B1FA2),
      'The High Priestess': Color(0xFF0277BD),
      'The Empress': Color(0xFF388E3C),
      'The Emperor': Color(0xFFD84315),
      'The Lovers': Color(0xFFC2185B),
      'The Sun': Color(0xFFF57F17),
      'The Moon': Color(0xFF512DA8),
      'The Star': Color(0xFF0097A7),
    };

    return colors[cardName] ?? AppTheme.primary;
  }
}

class _TarotCardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw decorative circles
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.2, size.height * (0.2 + i * 0.3)),
        20 + i * 10,
        paint,
      );
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * (0.3 + i * 0.3)),
        15 + i * 10,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TarotCardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw mystical pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw concentric circles
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        i * 20.0,
        paint,
      );
    }

    // Draw stars in corners
    for (var corner in [
      Offset(30, 30),
      Offset(size.width - 30, 30),
      Offset(30, size.height - 30),
      Offset(size.width - 30, size.height - 30),
    ]) {
      _drawStar(canvas, corner, 15, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * 3.14159) / 5 - 3.14159 / 2;
      final x = center.dx + radius * (i % 2 == 0 ? 1 : 0.5) * cos(angle);
      final y = center.dy + radius * (i % 2 == 0 ? 1 : 0.5) * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double angle) => angle.cos();
  double sin(double angle) => angle.sin();

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension on double {
  double cos() => this;
  double sin() => this;
}
