import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/premium_banner.dart';
import '../widgets/todays_focus_card.dart';
import '../widgets/growth_paths_card.dart';
import '../widgets/journal_preview_card.dart';
import '../widgets/quick_actions_grid.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Good Morning',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.neutral,
                  ),
            ),
            Text(
              'Sarah',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PremiumBanner().animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                ),
            const SizedBox(height: 24),
            const TodaysFocusCard().animate().slideX(
                  begin: -0.3,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                ),
            const SizedBox(height: 16),
            const GrowthPathsCard().animate().slideX(
                  begin: 0.3,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 400),
                ),
            const SizedBox(height: 16),
            const JournalPreviewCard().animate().slideX(
                  begin: -0.3,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 600),
                ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const QuickActionsGrid().animate().fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 800),
                ),
          ],
        ),
      ),
    );
  }
}
