import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.statusCode]);

  factory ServerFailure.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('انتهت مهلة الاتصال بالخادم، يرجى المحاولة مرة أخرى.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'حدث خطأ في الخادم ($statusCode)';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        } else if (data is Map && data['error'] != null) {
          message = data['error'].toString();
        }
        return ServerFailure(message, statusCode);
      case DioExceptionType.cancel:
        return const ServerFailure('تم إلغاء الطلب.');
      case DioExceptionType.connectionError:
        return const ServerFailure('تعذر الاتصال بالإنترنت، يرجى التحقق من اتصالك.');
      default:
        return const ServerFailure('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.');
    }
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'لا يوجد اتصال بالإنترنت']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً']);
}
