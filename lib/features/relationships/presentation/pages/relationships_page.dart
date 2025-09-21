import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/compatibility_calculator_card.dart';
import '../widgets/ai_conflict_advisor_card.dart';
import '../widgets/self_growth_card.dart';
import '../widgets/relationship_insights_card.dart';
import '../widgets/daily_quotes_card.dart';

class RelationshipsPage extends StatelessWidget {
  const RelationshipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Relationships & Growth'),
        backgroundColor: AppTheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Relationship Tools',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: 16),
            const CompatibilityCalculatorCard().animate().slideX(
              begin: -0.3,
              duration: const Duration(milliseconds: 600),
            ),
            const SizedBox(height: 16),
            const AIConflictAdvisorCard().animate().slideX(
              begin: 0.3,
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
            ),
            const SizedBox(height: 24),
            Text(
              'Personal Growth',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: 16),
            const SelfGrowthCard().animate().slideX(
              begin: -0.3,
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
            ),
            const SizedBox(height: 16),
            const RelationshipInsightsCard().animate().slideX(
              begin: 0.3,
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 600),
            ),
            const SizedBox(height: 24),
            Text(
              'Daily Inspiration',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: 16),
            const DailyQuotesCard().animate().slideX(
              begin: -0.3,
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 800),
            ),
          ],
        ),
      ),
    );
  }
}
