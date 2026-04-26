import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../services/iap_service.dart';

// Test mode state for Premium features
final testPremiumModeProvider = StateProvider<bool>((ref) => false);

final iapServiceProvider = Provider<IapService>((ref) {
  final service = IapService();
  ref.onDispose(() => service.dispose());
  return service;
});

final iapInitializationProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(iapServiceProvider);
  await service.initialize();
});

final isPremiumProvider = FutureProvider<bool>((ref) async {
  // Check test mode first
  final testMode = ref.watch(testPremiumModeProvider);
  if (testMode) return true;

  final service = ref.watch(iapServiceProvider);
  return await service.isPremium();
});

final productsProvider = Provider<List<ProductDetails>>((ref) {
  final service = ref.watch(iapServiceProvider);
  return service.products;
});

final purchaseUpdatesProvider = StreamProvider<PurchaseDetails>((ref) {
  final service = ref.watch(iapServiceProvider);
  return service.purchaseUpdates;
});
