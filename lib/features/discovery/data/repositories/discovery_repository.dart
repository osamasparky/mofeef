import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/discovery_remote_data_source.dart';
import '../models/discovery_models.dart';

abstract class DiscoveryRepository {
  Future<List<ServiceCategoryModel>> getServices();
  Future<List<LocationModel>> getLocations({String search = '', int page = 1});
  Future<List<NewsItemModel>> getNews();
  Future<Map<String, dynamic>> getHomeLayout();
}

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final DiscoveryRemoteDataSource _remoteDataSource;

  DiscoveryRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ServiceCategoryModel>> getServices() async {
    try {
      return await _remoteDataSource.getServices();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<List<LocationModel>> getLocations({String search = '', int page = 1}) async {
    try {
      return await _remoteDataSource.getLocations(search: search, page: page);
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<List<NewsItemModel>> getNews() async {
    try {
      return await _remoteDataSource.getNews();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getHomeLayout() async {
    try {
      return await _remoteDataSource.getHomeLayout();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }
}

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepositoryImpl(ref.watch(discoveryRemoteDataSourceProvider));
});

// Async Providers
final servicesProvider = FutureProvider<List<ServiceCategoryModel>>((ref) async {
  return ref.watch(discoveryRepositoryProvider).getServices();
});

final locationsProvider = FutureProvider<List<LocationModel>>((ref) async {
  return ref.watch(discoveryRepositoryProvider).getLocations();
});

final newsProvider = FutureProvider<List<NewsItemModel>>((ref) async {
  return ref.watch(discoveryRepositoryProvider).getNews();
});
