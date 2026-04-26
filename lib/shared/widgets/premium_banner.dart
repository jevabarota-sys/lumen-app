import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../features/premium/providers/iap_provider.dart';

class PremiumBanner extends ConsumerWidget {
  const PremiumBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        if (isPremium) {
          return const SizedBox.shrink();
        }
        return _buildBanner(context, ref, products);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => _buildBanner(context, ref, products),
    );
  }

  Widget _buildBanner(BuildContext context, WidgetRef ref, List products) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundGradientStart,
            AppTheme.backgroundGradientEnd
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'FREE TIER ACTIVE',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.star,
                color: AppTheme.white,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Unlock Your Full Potential',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Get unlimited access to all features, AI insights, and personalized guidance.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.white.withOpacity(0.9),
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final iapService = ref.read(iapServiceProvider);
              final success = await iapService.purchasePremium();
              if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Unable to start purchase. Please try again.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.white,
              foregroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              products.isNotEmpty
                  ? 'Start Premium - ${products.first.price}/month'
                  : 'Start Premium - \$9.99/month',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
