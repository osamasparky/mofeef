import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../presentation/car_list_screen.dart';

abstract class CarRepository {
  Future<List<CarModel>> searchCars({String? search, int page = 1});
  Future<CarModel> getCarDetail(dynamic id);
}

class CarRepositoryImpl implements CarRepository {
  final Dio _dio;

  CarRepositoryImpl(this._dio);

  @override
  Future<List<CarModel>> searchCars({String? search, int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.carSearch,
        queryParameters: {
          if (search != null && search.isNotEmpty) 's': search,
          'page': page,
          'limit': 10,
        },
      );
      final data = response.data;
      final list = data is Map && data['data'] is List ? data['data'] as List : (data is List ? data : []);
      return list.map((e) {
        final map = e as Map<String, dynamic>;
        return CarModel(
          id: map['id']?.toString() ?? '0',
          title: map['title']?.toString() ?? map['name']?.toString() ?? 'سيارة سياحية',
          category: map['category'] is Map ? map['category']['name']?.toString() ?? 'فاخرة' : 'فاخرة',
          pricePerDay: '${map['price'] ?? '500'} ر.س / يوم',
          passengerCount: int.tryParse(map['passenger']?.toString() ?? '5') ?? 5,
          transmission: map['gear']?.toString() ?? 'أوتوماتيك',
          imageUrl: map['image_url']?.toString() ?? map['image']?.toString() ?? 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800&q=80',
        );
      }).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<CarModel> getCarDetail(dynamic id) async {
    try {
      final response = await _dio.get(ApiEndpoints.carDetail(id));
      final map = response.data is Map && response.data['data'] != null ? response.data['data'] as Map<String, dynamic> : response.data as Map<String, dynamic>;
      return CarModel(
        id: map['id']?.toString() ?? id.toString(),
        title: map['title']?.toString() ?? map['name']?.toString() ?? 'سيارة سياحية',
        category: map['category'] is Map ? map['category']['name']?.toString() ?? 'فاخرة' : 'فاخرة',
        pricePerDay: '${map['price'] ?? '500'} ر.س / يوم',
        passengerCount: int.tryParse(map['passenger']?.toString() ?? '5') ?? 5,
        transmission: map['gear']?.toString() ?? 'أوتوماتيك',
        imageUrl: map['image_url']?.toString() ?? map['image']?.toString() ?? 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800&q=80',
      );
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }
}

final carRepositoryProvider = Provider<CarRepository>((ref) {
  return CarRepositoryImpl(ref.watch(dioProvider));
});

final carsListProvider = FutureProvider<List<CarModel>>((ref) async {
  return ref.watch(carRepositoryProvider).searchCars();
});
