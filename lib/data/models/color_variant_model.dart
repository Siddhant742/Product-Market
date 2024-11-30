class ColorVariant {
  final String id;
  final double price;
  final double strikePrice;
  final int offPercent;
  final int minOrder;
  final int maxOrder;
  final String productCode;
  final Map<String, dynamic> color;

  ColorVariant({
    required this.id,
    required this.price,
    required this.strikePrice,
    required this.offPercent,
    required this.minOrder,
    required this.maxOrder,
    required this.productCode,
    required this.color,
  });

  factory ColorVariant.fromJson(Map<String, dynamic> json) {
    // Handle potential null or missing values with proper defaults
    return ColorVariant(
      id: json['_id'] ?? '',
      // Convert numeric values safely using null-aware operators and type checking
      price: _parseDouble(json['price']),
      strikePrice: _parseDouble(json['strikePrice']),
      offPercent: _parseInt(json['offPercent']),
      minOrder: _parseInt(json['minOrder']),
      maxOrder: _parseInt(json['maxOrder']),
      productCode: json['productCode'] ?? '',
      // Ensure color is always a Map<String, dynamic>, even if empty
      color: (json['color'] as Map<String, dynamic>?) ?? {},
    );
  }

  // Helper method to safely parse doubles
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper method to safely parse integers
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Add a method to safely get color name
  String getColorName() {
    return color['name']?.toString() ?? 'Unknown';
  }

  // Add a method to safely get color value
  List<String> getColorValues() {
    final colorValues = color['colorValue'];
    if (colorValues is List) {
      return colorValues.map((e) => e.toString()).toList();
    }
    return [];
  }
}