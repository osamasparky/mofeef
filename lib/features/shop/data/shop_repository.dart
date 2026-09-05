import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/product_model.dart';

abstract class ShopRepository {
  Future<List<ProductModel>> searchProducts({String? search, int? categoryId, int page = 1});
  Future<ProductModel> getProductDetail(dynamic id);
}

class ShopRepositoryImpl implements ShopRepository {
  final Dio _dio;

  ShopRepositoryImpl(this._dio);

  @override
  Future<List<ProductModel>> searchProducts({String? search, int? categoryId, int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.productSearch,
        queryParameters: {
          if (search != null && search.isNotEmpty) 's': search,
          if (categoryId != null) 'cat_id[]': categoryId,
          'page': page,
          'limit': 10,
        },
      );
      final data = response.data;
      final list = data is Map && data['data'] is List ? data['data'] as List : (data is List ? data : []);
      return list.map((e) {
        final map = e as Map<String, dynamic>;
        return ProductModel(
          id: map['id']?.toString() ?? '0',
          title: map['title']?.toString() ?? map['name']?.toString() ?? '',
          category: map['category'] is Map ? map['category']['name']?.toString() ?? 'مقتنيات' : 'مقتنيات',
          storeName: map['store'] is Map ? map['store']['name']?.toString() ?? 'بازار مُضيف' : 'بازار مُضيف',
          price: '${map['price'] ?? '0'} ر.س',
          priceNumeric: double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
          originalPrice: '${map['origin_price'] ?? map['price'] ?? '0'} ر.س',
          rating: double.tryParse(map['review_score']?.toString() ?? '5.0') ?? 5.0,
          reviewsCount: int.tryParse(map['review_count']?.toString() ?? '10') ?? 10,
          imageUrl: map['image_url']?.toString() ?? map['image']?.toString() ?? 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80',
          description: map['content']?.toString() ?? map['desc']?.toString() ?? 'منتج سعودي أصيل من بازار مُضيف.',
        );
      }).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<ProductModel> getProductDetail(dynamic id) async {
    try {
      final response = await _dio.get(ApiEndpoints.productDetail(id));
      final data = response.data is Map && response.data['data'] != null ? response.data['data'] as Map<String, dynamic> : response.data as Map<String, dynamic>;
      return ProductModel(
        id: data['id']?.toString() ?? id.toString(),
        title: data['title']?.toString() ?? data['name']?.toString() ?? '',
        category: data['category'] is Map ? data['category']['name']?.toString() ?? 'مقتنيات' : 'مقتنيات',
        storeName: data['store'] is Map ? data['store']['name']?.toString() ?? 'بازار مُضيف' : 'بازار مُضيف',
        price: '${data['price'] ?? '0'} ر.س',
        priceNumeric: double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
        originalPrice: '${data['origin_price'] ?? data['price'] ?? '0'} ر.س',
        rating: double.tryParse(data['review_score']?.toString() ?? '5.0') ?? 5.0,
        reviewsCount: int.tryParse(data['review_count']?.toString() ?? '10') ?? 10,
        imageUrl: data['image_url']?.toString() ?? data['image']?.toString() ?? '',
        description: data['content']?.toString() ?? data['desc']?.toString() ?? '',
      );
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }
}

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepositoryImpl(ref.watch(dioProvider));
});

final productsListProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.watch(shopRepositoryProvider).searchProducts();
});
