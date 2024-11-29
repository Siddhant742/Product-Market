// // lib/models/product_detail.dart
// class ProductDetail {
//   final String id;
//   final String name;
//   final double price;
//   final double originalPrice;
//   final String description;
//   final List<String> images;
//   final List<String> variants;
//   final int stock;
//   final Map<String, String> specifications;
//   final double rating;
//   final String ingredients;
//   final String howToUse;
//
//   ProductDetail({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.originalPrice,
//     required this.description,
//     required this.images,
//     required this.variants,
//     required this.stock,
//     required this.specifications,
//     required this.rating,
//     required this.ingredients,
//     required this.howToUse,
//   });
//
//   factory ProductDetail.fromJson(Map<String, dynamic> json) {
//     return ProductDetail(
//       id: json['id'] ?? '',
//       name: json['title'] ?? '',
//       price: (json['price'] ?? 0.0).toDouble(),
//       originalPrice: (json['original_price'] ?? 0.0).toDouble(),
//       description: json['description'] ?? '',
//       images: List<String>.from(json['images'] ?? []),
//       variants: List<String>.from(json['variants'] ?? []),
//       stock: json['stock'] ?? 0,
//       specifications: Map<String, String>.from(json['specifications'] ?? {}),
//       rating: (json['rating'] ?? 0.0).toDouble(),
//       ingredients: json['ingredient'] ?? '',
//       howToUse: json['howToUse'] ?? '',
//     );
//   }
// }

class ProductDetail {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final String description;
  final List<String> images;
  final List colorAttributes;
  final int stock;
  final Map<String, String> specifications;
  final double rating;
  final String ingredients;
  final String howToUse;

  ProductDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.images,
    required this.colorAttributes,
    required this.stock,
    required this.specifications,
    required this.rating,
    required this.ingredients,
    required this.howToUse,
  });

  factory ProductDetail.fromJson(Map json) {
    return ProductDetail(
      id: json['_id'] ?? '',
      name: json['title'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      originalPrice: (json['strikePrice'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      colorAttributes: List.from(json['colorAttributes'] ?? []),
      stock: json['stock'] ?? 0,
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      rating: (json['ratings'] ?? 0.0).toDouble(),
      ingredients: json['ingredient'] ?? '',
      howToUse: json['howToUse'] ?? '',
    );
  }
}