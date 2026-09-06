import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
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

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final status = data['status'];
      final code = data['code']?.toString();
      final msg = data['message']?.toString();

      // Check if API returned status 0 or error code with HTTP 200
      if (status == 0 || status == false || (code != null && code != 'success' && code != '200')) {
        String errorMsg = msg ?? 'فشل تسجيل الدخول، يرجى التأكد من البيانات المدخلة';
        if (code == 'email_not_verified') {
          errorMsg = 'يرجى تأكيد بريدك الإلكتروني أولاً لتتمكن من تسجيل الدخول';
        } else if (code == 'invalid_credentials' || msg == 'Password is not correct') {
          errorMsg = 'كلمة المرور أو البريد الإلكتروني غير صحيح';
        }
        throw ServerFailure(errorMsg);
      }
    }

    return UserModel.fromJson(data is Map<String, dynamic> ? data : {});
  }

  @override
  Future<UserModel> register(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.register, data: data);
    final resData = response.data;
    if (resData is Map<String, dynamic>) {
      final status = resData['status'];
      final msg = resData['message']?.toString();
      if (status == 0 || status == false) {
        throw ServerFailure(msg ?? 'فشل إنشاء الحساب، يرجى المحاولة لاحقاً');
      }
    }
    return UserModel.fromJson(resData is Map<String, dynamic> ? resData : {});
  }

  @override
  Future<UserModel> getProfile() async {
    // Try /user first, then /auth/me
    try {
      final response = await _dio.get(ApiEndpoints.currentUser);
      final data = response.data;
      if (data is Map<String, dynamic> && (data['status'] == 1 || data['status'] == true || data['data'] != null || data['user'] != null)) {
        return UserModel.fromJson(data);
      }
    } catch (_) {}

    final response = await _dio.get(ApiEndpoints.me);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return UserModel.fromJson(data);
    }
    return UserModel.fromJson({});
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
