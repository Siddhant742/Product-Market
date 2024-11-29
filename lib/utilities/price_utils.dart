// lib/utils/price_utils.dart
class PriceUtils {
  static String calculateDiscount(double originalPrice, double currentPrice) {
    if (originalPrice <= 0) return '0%';
    double discount = ((originalPrice - currentPrice) / originalPrice) * 100;
    return '${discount.toStringAsFixed(0)}%';
  }

  static String formatPrice(double price) {
    return 'NPR ${price.toStringAsFixed(2)}';
  }
}