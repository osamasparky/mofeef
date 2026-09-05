import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class WishlistItemModel {
  final int id;
  final int objectId;
  final String objectModel;
  final String title;
  final String? imageUrl;
  final double price;
  final String? location;

  const WishlistItemModel({
    required this.id,
    required this.objectId,
    required this.objectModel,
    required this.title,
    this.imageUrl,
    required this.price,
    this.location,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final service = json['service'] is Map ? json['service'] as Map<String, dynamic> : json;
    return WishlistItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      objectId: json['object_id'] is int ? json['object_id'] : int.tryParse(json['object_id']?.toString() ?? '0') ?? 0,
      objectModel: json['object_model']?.toString() ?? 'tour',
      title: service['title']?.toString() ?? service['name']?.toString() ?? '',
      imageUrl: service['image_url']?.toString() ?? service['image']?.toString(),
      price: double.tryParse(service['price']?.toString() ?? '0') ?? 0.0,
      location: service['location'] is Map ? service['location']['name']?.toString() : service['location']?.toString(),
    );
  }
}

abstract class WishlistRepository {
  Future<List<WishlistItemModel>> getWishlist();
  Future<void> addToWishlist(String serviceType, dynamic id);
  Future<void> removeFromWishlist(String serviceType, dynamic id);
}

class WishlistRepositoryImpl implements WishlistRepository {
  final Dio _dio;

  WishlistRepositoryImpl(this._dio);

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    try {
      final response = await _dio.get(ApiEndpoints.wishlist);
      final data = response.data;
      final list = data is Map && data['data'] is List ? data['data'] as List : (data is List ? data : []);
      return list.map((e) => WishlistItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<void> addToWishlist(String serviceType, dynamic id) async {
    try {
      await _dio.post(ApiEndpoints.addToWishlist(serviceType, id));
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<void> removeFromWishlist(String serviceType, dynamic id) async {
    try {
      await _dio.delete(ApiEndpoints.removeFromWishlist(serviceType, id));
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }
}

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepositoryImpl(ref.watch(dioProvider));
});

final wishlistItemsProvider = FutureProvider<List<WishlistItemModel>>((ref) async {
  return ref.watch(wishlistRepositoryProvider).getWishlist();
});
