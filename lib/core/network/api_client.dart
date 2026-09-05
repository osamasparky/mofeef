import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../localization/locale_provider.dart';
import 'mock_api_interceptor.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final currentLocale = ref.watch(localeProvider);
  final langCode = currentLocale.languageCode;

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': langCode,
        'X-Locale': langCode,
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Automatically inject current language code into query parameters if not present
        if (!options.queryParameters.containsKey('lang')) {
          options.queryParameters['lang'] = langCode;
        }
        options.headers['Accept-Language'] = langCode;
        options.headers['X-Locale'] = langCode;

        final token = await storage.read(key: 'auth_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        return handler.next(error);
      },
    ),
  );

  dio.interceptors.add(MockApiInterceptor());

  return dio;
});
