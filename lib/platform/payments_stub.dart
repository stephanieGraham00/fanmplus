class PlatformPaymentService {
  static final PlatformPaymentService _instance = PlatformPaymentService._();
  factory PlatformPaymentService() => _instance;
  PlatformPaymentService._();

  Future<void> initialize() async {}

  Future<List<Map<String, dynamic>>> getProducts() async => [];

  Future<bool> purchaseProduct(String productId) async => false;

  Future<void> restorePurchases() async {}
}
