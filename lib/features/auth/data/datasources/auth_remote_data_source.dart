import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password, {String deviceName = 'flutter-mobile'});
  Future<UserModel> register(Map<String, dynamic> data);
  Future<UserModel> getProfile();
  Future<void> updateProfile(Map<String, dynamic> data);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> login(String email, String password, {String deviceName = 'flutter-mobile'}) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> register(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.register, data: data);
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await _dio.get(ApiEndpoints.me);
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _dio.post(ApiEndpoints.updateProfile, data: data);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _dio.post(
      ApiEndpoints.changePassword,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      },
    );
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {}
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
});
