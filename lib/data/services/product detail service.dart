import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/product_detail_model.dart';

class ProductService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://oriflamenepal.com/api',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ))..interceptors.add(PrettyDioLogger(
    request: true,
    requestBody: true,
    requestHeader: true,
    responseBody: true,
    responseHeader: true,
    error: true,
    compact: false,
  ));

  Future<ProductDetail> getProductDetail(String productId) async {
    try {
      final response = await _dio.get('/product/for-public/$productId');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return ProductDetail.fromJson(data['data']);
      } else {
        throw Exception('Failed to load product details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error fetching product details: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }
}
