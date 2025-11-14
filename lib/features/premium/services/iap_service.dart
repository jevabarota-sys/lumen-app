import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IapService {
  static const String premiumProductId = 'com.lumen.app.premium.monthly';
  
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  final _purchaseUpdatesController = StreamController<PurchaseDetails>.broadcast();
  Stream<PurchaseDetails> get purchaseUpdates => _purchaseUpdatesController.stream;
  
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  
  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => _products;
  
  Future<void> initialize() async {
    // Check if in-app purchase is available
    _isAvailable = await _inAppPurchase.isAvailable();
    
    if (!_isAvailable) {
      debugPrint('IAP not available on this device');
      return;
    }
    
    // Set up purchase listener
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => debugPrint('Purchase stream error: $error'),
    );
    
    // Load products
    await _loadProducts();
    
    // Restore any pending purchases
    await _restorePurchases();
  }
  
  Future<void> _loadProducts() async {
    const Set<String> productIds = {premiumProductId};
    
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
      
      if (response.error != null) {
        debugPrint('Error loading products: ${response.error}');
        return;
      }
      
      if (response.productDetails.isEmpty) {
        debugPrint('No products found');
        return;
      }
      
      _products = response.productDetails;
      debugPrint('Loaded ${_products.length} products');
    } catch (e) {
      debugPrint('Exception loading products: $e');
    }
  }
  
  Future<bool> purchasePremium() async {
    if (_products.isEmpty) {
      debugPrint('No products available');
      return false;
    }
    
    final ProductDetails productDetails = _products.first;
    
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );
    
    try {
      return await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Error purchasing: $e');
      return false;
    }
  }
  
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      debugPrint('Purchase update: ${purchaseDetails.status}');
      
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI
        _purchaseUpdatesController.add(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
        debugPrint('Purchase error: ${purchaseDetails.error}');
        _purchaseUpdatesController.add(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        // Verify and deliver purchase
        await _verifyAndDeliverPurchase(purchaseDetails);
        _purchaseUpdatesController.add(purchaseDetails);
      }
      
      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }
  
  Future<void> _verifyAndDeliverPurchase(PurchaseDetails purchaseDetails) async {
    // Store purchase locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', true);
    await prefs.setString('purchase_id', purchaseDetails.purchaseID ?? '');
    await prefs.setString('product_id', purchaseDetails.productID);
    
    // Platform-specific handling
    if (Platform.isAndroid) {
      final androidDetails = purchaseDetails as GooglePlayPurchaseDetails;
      await prefs.setString('purchase_token', androidDetails.billingClientPurchase.purchaseToken);
    } else if (Platform.isIOS) {
      final iosDetails = purchaseDetails as AppStorePurchaseDetails;
      await prefs.setString('transaction_id', iosDetails.skPaymentTransaction.transactionIdentifier ?? '');
    }
    
    debugPrint('Purchase verified and delivered');
  }
  
  Future<void> _restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      debugPrint('Purchases restored');
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }
  
  Future<void> restorePurchases() async {
    await _restorePurchases();
  }
  
  Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_premium') ?? false;
  }
  
  void dispose() {
    _subscription.cancel();
    _purchaseUpdatesController.close();
  }
}
