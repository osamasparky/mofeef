import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(Map<String, dynamic> data);
  Future<UserModel> getProfile();
  Future<void> updateProfile(Map<String, dynamic> data);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> logout();
  Future<String?> getSavedToken();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final Ref _ref;

  AuthRepositoryImpl(this._remoteDataSource, this._ref);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final user = await _remoteDataSource.login(email, password);
      if (user.token != null) {
        final storage = _ref.read(secureStorageProvider);
        await storage.write(key: 'auth_token', value: user.token!);
      }
      return user;
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<UserModel> register(Map<String, dynamic> data) async {
    try {
      final user = await _remoteDataSource.register(data);
      if (user.token != null) {
        final storage = _ref.read(secureStorageProvider);
        await storage.write(key: 'auth_token', value: user.token!);
      }
      return user;
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      return await _remoteDataSource.getProfile();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.updateProfile(data);
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _remoteDataSource.changePassword(currentPassword, newPassword);
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } finally {
      final storage = _ref.read(secureStorageProvider);
      await storage.delete(key: 'auth_token');
    }
  }

  @override
  Future<String?> getSavedToken() async {
    final storage = _ref.read(secureStorageProvider);
    return await storage.read(key: 'auth_token');
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref,
  );
});
