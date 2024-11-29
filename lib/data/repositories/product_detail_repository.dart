// lib/repositories/product_repository.dart
import '../models/product_detail_model.dart';
import '../services/product detail service.dart';

class ProductRepository {
  final ProductService _service;

  ProductRepository(this._service);

  Future<ProductDetail> getProductDetail(String productId) async {
    try {
      return await _service.getProductDetail(productId);
    } catch (e) {
      rethrow;
    }
  }
}