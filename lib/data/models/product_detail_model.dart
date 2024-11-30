class ProductDetail {
  final String id;
  final String title;
  final double price;
  final double strikePrice;
  final double offPercent;
  final String description;
  final List<String> images;
  final List colorAttributes;
  final List colorVariants;
  final int stock;
  final Map<String, String> specifications;
  final double rating;
  final String ingredients;
  final String howToUse;

  ProductDetail({
    required this.id,
    required this.title,
    required this.price,
    required this.strikePrice,
    required this.offPercent,
    required this.description,
    required this.images,
    required this.colorAttributes,
    required this.colorVariants,
    required this.stock,
    required this.specifications,
    required this.rating,
    required this.ingredients,
    required this.howToUse,
  });

  factory ProductDetail.fromJson(Map json) {
    return ProductDetail(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      strikePrice: (json['strikePrice'] ?? 0.0).toDouble(),
      offPercent: (json['offPercent'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      colorAttributes: List.from(json['colorAttributes'] ?? []),
      colorVariants: List.from(json['colorVariants'] ?? []),
      stock: json['stock'] ?? 0,
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      rating: (json['ratings'] ?? 0.0).toDouble(),
      ingredients: json['ingredient'] ?? '',
      howToUse: json['howToUse'] ?? '',
    );
  }
}