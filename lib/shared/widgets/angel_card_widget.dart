import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Beautiful, colorful angel card widget with ethereal gradients and angelic designs
class AngelCardWidget extends StatelessWidget {
  final String cardName;
  final String message;
  final bool isRevealed;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const AngelCardWidget({
    super.key,
    required this.cardName,
    required this.message,
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _getCardColor(cardName).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: isRevealed ? _buildRevealedCard() : _buildCardBack(),
        ),
      ),
    );
  }

  Widget _buildRevealedCard() {
    final gradient = _getCardGradient(cardName);
    final icon = _getCardIcon(cardName);

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // Ethereal glow effect
          Positioned.fill(
            child: CustomPaint(
              painter: _AngelCardGlowPainter(color: _getCardColor(cardName)),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Angel wings decoration at top
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scaleX: -1,
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.favorite,
                      color: Colors.white.withOpacity(0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Main icon with halo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Halo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 48,
                        color: _getCardColor(cardName),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Card name
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    cardName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getCardColor(cardName),
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 12),

                // Decorative stars at bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.star,
                        color: Colors.white.withOpacity(0.7),
                        size: 12,
                      ),
                    ),
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
            Color(0xFFE1BEE7),
            Color(0xFFCE93D8),
            Color(0xFFBA68C8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Ethereal pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _AngelCardBackPainter(),
            ),
          ),

          // Center design
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'ANGEL CARDS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getCardGradient(String cardName) {
    final gradients = {
      'Love': LinearGradient(
        colors: [Color(0xFFF8BBD0), Color(0xFFF06292), Color(0xFFEC407A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'Peace': LinearGradient(
        colors: [Color(0xFFB3E5FC), Color(0xFF4FC3F7), Color(0xFF29B6F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'Abundance': LinearGradient(
        colors: [Color(0xFFFFF9C4), Color(0xFFFFD54F), Color(0xFFFFCA28)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'Healing': LinearGradient(
        colors: [Color(0xFFC8E6C9), Color(0xFF81C784), Color(0xFF66BB6A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'Protection': LinearGradient(
        colors: [Color(0xFFD1C4E9), Color(0xFF9575CD), Color(0xFF7E57C2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'Guidance': LinearGradient(
        colors: [Color(0xFFFFCCBC), Color(0xFFFF8A65), Color(0xFFFF7043)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'Joy': LinearGradient(
        colors: [Color(0xFFFFF59D), Color(0xFFFFEE58), Color(0xFFFFEB3B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'Hope': LinearGradient(
        colors: [Color(0xFFB2EBF2), Color(0xFF4DD0E1), Color(0xFF26C6DA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    };

    return gradients[cardName] ??
        LinearGradient(
          colors: [Color(0xFFE1BEE7), Color(0xFFBA68C8), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
  }

  IconData _getCardIcon(String cardName) {
    final icons = {
      'Love': Icons.favorite,
      'Peace': Icons.spa,
      'Abundance': Icons.auto_awesome,
      'Healing': Icons.healing,
      'Protection': Icons.shield,
      'Guidance': Icons.explore,
      'Faith': Icons.church,
      'Joy': Icons.celebration,
      'Forgiveness': Icons.favorite_border,
      'Courage': Icons.fitness_center,
      'Clarity': Icons.lightbulb,
      'Gratitude': Icons.volunteer_activism,
      'Hope': Icons.star,
      'Transformation': Icons.transform,
      'Wisdom': Icons.menu_book,
      'Balance': Icons.balance,
      'Creativity': Icons.palette,
      'Purpose': Icons.track_changes,
      'Patience': Icons.hourglass_empty,
      'Strength': Icons.fitness_center,
      'Trust': Icons.handshake,
      'Compassion': Icons.favorite,
      'Freedom': Icons.flight,
      'Harmony': Icons.music_note,
      'Inspiration': Icons.wb_incandescent,
      'Miracles': Icons.auto_awesome,
      'New Beginnings': Icons.wb_sunny,
      'Release': Icons.air,
      'Serenity': Icons.self_improvement,
      'Victory': Icons.emoji_events,
    };

    return icons[cardName] ?? Icons.auto_awesome;
  }

  Color _getCardColor(String cardName) {
    final colors = {
      'Love': Color(0xFFE91E63),
      'Peace': Color(0xFF03A9F4),
      'Abundance': Color(0xFFFFC107),
      'Healing': Color(0xFF4CAF50),
      'Protection': Color(0xFF9C27B0),
      'Guidance': Color(0xFFFF5722),
      'Joy': Color(0xFFFFEB3B),
      'Hope': Color(0xFF00BCD4),
    };

    return colors[cardName] ?? Color(0xFF9C27B0);
  }
}

class _AngelCardGlowPainter extends CustomPainter {
  final Color color;

  _AngelCardGlowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw soft glowing circles
    for (int i = 0; i < 5; i++) {
      final opacity = 0.05 - (i * 0.01);
      paint.color = Colors.white.withOpacity(opacity);

      canvas.drawCircle(
        Offset(size.width * 0.3, size.height * 0.3),
        50.0 + (i * 20),
        paint,
      );

      canvas.drawCircle(
        Offset(size.width * 0.7, size.height * 0.7),
        40.0 + (i * 15),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AngelCardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw ethereal wing patterns
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw flowing curves (wings)
    for (int i = 0; i < 3; i++) {
      final path = Path();
      final offset = i * 30.0;

      path.moveTo(centerX - 60 - offset, centerY);
      path.quadraticBezierTo(
        centerX - 80 - offset,
        centerY - 40,
        centerX - 60 - offset,
        centerY - 80,
      );

      path.moveTo(centerX + 60 + offset, centerY);
      path.quadraticBezierTo(
        centerX + 80 + offset,
        centerY - 40,
        centerX + 60 + offset,
        centerY - 80,
      );

      canvas.drawPath(path, paint);
    }

    // Draw stars
    for (var pos in [
      Offset(30, 40),
      Offset(size.width - 30, 40),
      Offset(30, size.height - 40),
      Offset(size.width - 30, size.height - 40),
      Offset(centerX, 30),
      Offset(centerX, size.height - 30),
    ]) {
      _drawStar(canvas, pos, 10, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi) / 5 - math.pi / 2;
      final r = i % 2 == 0 ? radius : radius * 0.5;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
