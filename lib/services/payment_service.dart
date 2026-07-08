import '../platform/payments.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._();
  factory PaymentService() => _instance;
  PaymentService._();

  final _platform = PlatformPaymentService();

  Future<void> initialize() async => _platform.initialize();

  Future<List<Map<String, dynamic>>> getProducts() async => _platform.getProducts();

  Future<bool> purchaseProduct(String productId) async => _platform.purchaseProduct(productId);

  Future<void> restorePurchases() async => _platform.restorePurchases();
}
