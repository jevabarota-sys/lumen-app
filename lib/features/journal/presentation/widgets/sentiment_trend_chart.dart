import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/sentiment_analyzer.dart';

/// Beautiful sentiment trend chart showing mood over time
class SentimentTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> journalEntries;

  const SentimentTrendChart({
    super.key,
    required this.journalEntries,
  });

  @override
  Widget build(BuildContext context) {
    if (journalEntries.isEmpty) {
      return _buildEmptyState(context);
    }

    final trendAnalysis = SentimentAnalyzer.analyzeTrends(journalEntries);
    final scores = trendAnalysis['scores'] as List<double>;
    final averageScore = trendAnalysis['averageScore'] as double;
    final trend = trendAnalysis['trend'] as String;
    final dominantEmotion = trendAnalysis['dominantEmotion'] as String;

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
                    Icons.show_chart,
                    color: AppTheme.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sentiment Trends',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        'Your emotional journey over time',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.neutral,
                            ),
                      ),
                    ],
                  ),
                ),
                _buildTrendIndicator(trend),
              ],
            ),
            const SizedBox(height: 24),
            
            // Chart
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 0.5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.border.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= scores.length) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${value.toInt() + 1}',
                              style: TextStyle(
                                color: AppTheme.neutral,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.5,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          String label = '';
                          if (value == 1.0) label = 'Very Positive';
                          else if (value == 0.5) label = 'Positive';
                          else if (value == 0.0) label = 'Neutral';
                          else if (value == -0.5) label = 'Negative';
                          else if (value == -1.0) label = 'Very Negative';
                          
                          return Text(
                            label,
                            style: TextStyle(
                              color: AppTheme.neutral,
                              fontSize: 9,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: AppTheme.border.withOpacity(0.3),
                    ),
                  ),
                  minX: 0,
                  maxX: (scores.length - 1).toDouble(),
                  minY: -1,
                  maxY: 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: scores.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.secondary,
                          AppTheme.accent,
                          AppTheme.primary,
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: _getColorForScore(spot.y),
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primary.withOpacity(0.1),
                            AppTheme.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: AppTheme.surface,
                      tooltipBorder: BorderSide(color: AppTheme.border),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final sentiment = _getSentimentLabel(spot.y);
                          return LineTooltipItem(
                            'Entry ${spot.x.toInt() + 1}\n$sentiment',
                            TextStyle(
                              color: _getColorForScore(spot.y),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Average',
                    _getSentimentLabel(averageScore),
                    _getColorForScore(averageScore),
                    Icons.analytics,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Dominant',
                    _capitalizeFirst(dominantEmotion),
                    AppTheme.accent,
                    Icons.favorite,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Insight
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.lightBlue.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      SentimentAnalyzer.generateTrendInsight(trendAnalysis),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.onSurface,
                            height: 1.5,
                          ),
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

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.show_chart,
              size: 64,
              color: AppTheme.neutral.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Sentiment Data Yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutral,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Write more journal entries to see your emotional trends',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.neutral,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(String trend) {
    IconData icon;
    Color color;
    
    if (trend == 'improving') {
      icon = Icons.trending_up;
      color = AppTheme.success;
    } else if (trend == 'declining') {
      icon = Icons.trending_down;
      color = AppTheme.error;
    } else {
      icon = Icons.trending_flat;
      color = AppTheme.neutral;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            _capitalizeFirst(trend),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.neutral,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getColorForScore(double score) {
    if (score > 0.3) {
      return AppTheme.success;
    } else if (score < -0.3) {
      return AppTheme.error;
    } else {
      return AppTheme.neutral;
    }
  }

  String _getSentimentLabel(double score) {
    if (score > 0.6) return 'Very Positive';
    if (score > 0.3) return 'Positive';
    if (score > -0.3) return 'Neutral';
    if (score > -0.6) return 'Negative';
    return 'Very Negative';
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
