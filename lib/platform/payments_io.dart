import 'package:in_app_purchase/in_app_purchase.dart';

class PlatformPaymentService {
  static final PlatformPaymentService _instance = PlatformPaymentService._();
  factory PlatformPaymentService() => _instance;
  PlatformPaymentService._();

  final InAppPurchase _purchase = InAppPurchase.instance;
  bool _initialized = false;

  static const String monthlyId = 'fanmplus_monthly';
  static const String yearlyId = 'fanmplus_yearly';
  static const String removeAdsId = 'fanmplus_remove_ads';

  Future<void> initialize() async {
    if (_initialized) return;
    final available = await _purchase.isAvailable();
    if (!available) return;
    _initialized = true;
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await _purchase.queryProductDetails({
      monthlyId,
      yearlyId,
      removeAdsId,
    });
    return response.productDetails.map((p) => {
      'id': p.id,
      'title': p.title,
      'description': p.description,
      'price': p.price,
    }).toList();
  }

  Future<bool> purchaseProduct(String productId) async {
    final response = await _purchase.queryProductDetails({productId});
    if (response.productDetails.isEmpty) return false;
    final result = await _purchase.buyConsumable(
      purchaseParam: PurchaseParam(productDetails: response.productDetails.first),
    );
    return result.isNotEmpty;
  }

  Future<void> restorePurchases() async {
    await _purchase.restorePurchases();
  }
}
