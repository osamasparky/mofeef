import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class MuseumModel {
  final int id;
  final String title;
  final String? content;
  final String? imageUrl;
  final String? bannerUrl;
  final double price;
  final String? workingHours;
  final double rating;
  final int reviewsCount;
  final String? locationName;

  const MuseumModel({
    required this.id,
    required this.title,
    this.content,
    this.imageUrl,
    this.bannerUrl,
    required this.price,
    this.workingHours,
    required this.rating,
    required this.reviewsCount,
    this.locationName,
  });

  String get formattedPrice => price > 0 ? '${price.toStringAsFixed(0)} ر.س' : 'دخول مجاني';

  factory MuseumModel.fromJson(Map<String, dynamic> json) {
    return MuseumModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? json['desc']?.toString(),
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      bannerUrl: json['banner_image']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      workingHours: json['working_hours']?.toString() ?? '٩ص — ٩م',
      rating: double.tryParse(json['review_score']?.toString() ?? json['rating']?.toString() ?? '4.9') ?? 4.9,
      reviewsCount: int.tryParse(json['review_count']?.toString() ?? '24') ?? 24,
      locationName: json['location'] is Map ? json['location']['name']?.toString() : json['location']?.toString(),
    );
  }
}

abstract class MuseumRepository {
  Future<List<MuseumModel>> searchMuseums({String? search, int? locationId, int page = 1});
  Future<MuseumModel> getMuseumDetail(dynamic id);
}

class MuseumRepositoryImpl implements MuseumRepository {
  final Dio _dio;

  MuseumRepositoryImpl(this._dio);

  @override
  Future<List<MuseumModel>> searchMuseums({String? search, int? locationId, int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.museumSearch,
        queryParameters: {
          if (search != null && search.isNotEmpty) 's': search,
          if (locationId != null) 'location_id': locationId,
          'page': page,
          'limit': 10,
        },
      );
      final data = response.data;
      final list = data is Map && data['data'] is List ? data['data'] as List : (data is List ? data : []);
      return list.map((e) => MuseumModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<MuseumModel> getMuseumDetail(dynamic id) async {
    try {
      final response = await _dio.get(ApiEndpoints.museumDetail(id));
      final data = response.data is Map && response.data['data'] != null ? response.data['data'] : response.data;
      return MuseumModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }
}

final museumRepositoryProvider = Provider<MuseumRepository>((ref) {
  return MuseumRepositoryImpl(ref.watch(dioProvider));
});

final museumsListProvider = FutureProvider<List<MuseumModel>>((ref) async {
  return ref.watch(museumRepositoryProvider).searchMuseums();
});
