import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class BookingItemModel {
  final int id;
  final String code;
  final String serviceTitle;
  final String serviceType;
  final String startDate;
  final String? endDate;
  final double total;
  final String status;
  final int totalGuests;

  const BookingItemModel({
    required this.id,
    required this.code,
    required this.serviceTitle,
    required this.serviceType,
    required this.startDate,
    this.endDate,
    required this.total,
    required this.status,
    required this.totalGuests,
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> json) {
    final service = json['service'] is Map ? json['service'] as Map<String, dynamic> : json;
    return BookingItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      code: json['code']?.toString() ?? 'MDF-${json['id']}',
      serviceTitle: service['title']?.toString() ?? service['name']?.toString() ?? 'حجز رحلة',
      serviceType: json['object_model']?.toString() ?? 'tour',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString(),
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'confirmed',
      totalGuests: int.tryParse(json['total_guests']?.toString() ?? '1') ?? 1,
    );
  }
}

class TicketModel {
  final int id;
  final String ticketCode;
  final String bookingCode;
  final String title;
  final String date;
  final String? qrUrl;

  const TicketModel({
    required this.id,
    required this.ticketCode,
    required this.bookingCode,
    required this.title,
    required this.date,
    this.qrUrl,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      ticketCode: json['ticket_code']?.toString() ?? json['id']?.toString() ?? '',
      bookingCode: json['booking_code']?.toString() ?? '',
      title: json['title']?.toString() ?? 'تذكرة دخول',
      date: json['date']?.toString() ?? '',
      qrUrl: json['qr_url']?.toString(),
    );
  }
}

abstract class BookingRepository {
  Future<Map<String, dynamic>> addToCart({
    required int serviceId,
    required String serviceType,
    required String startDate,
    int? guests,
    Map<String, dynamic>? extraData,
  });
  Future<Map<String, dynamic>> doCheckout(Map<String, dynamic> bookingData);
  Future<List<BookingItemModel>> getBookingHistory({String status = ''});
  Future<List<TicketModel>> getMyTickets();
}

class BookingRepositoryImpl implements BookingRepository {
  final Dio _dio;

  BookingRepositoryImpl(this._dio);

  @override
  Future<Map<String, dynamic>> addToCart({
    required int serviceId,
    required String serviceType,
    required String startDate,
    int? guests,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final payload = {
        'service_id': serviceId,
        'service_type': serviceType,
        'start_date': startDate,
        if (guests != null) 'guests': guests,
        ...?extraData,
      };
      final response = await _dio.post(ApiEndpoints.addToCartBooking, data: payload);
      return response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : {};
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> doCheckout(Map<String, dynamic> bookingData) async {
    try {
      final response = await _dio.post(ApiEndpoints.doCheckout, data: bookingData);
      return response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : {};
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<List<BookingItemModel>> getBookingHistory({String status = ''}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.bookingHistory,
        queryParameters: {if (status.isNotEmpty) 'status': status},
      );
      final data = response.data;
      final list = data is Map && data['data'] is List ? data['data'] as List : (data is List ? data : []);
      return list.map((e) => BookingItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<List<TicketModel>> getMyTickets() async {
    try {
      final response = await _dio.get(ApiEndpoints.myTickets);
      final data = response.data;
      final list = data is Map && data['data'] is List ? data['data'] as List : (data is List ? data : []);
      return list.map((e) => TicketModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl(ref.watch(dioProvider));
});

final bookingHistoryProvider = FutureProvider.family<List<BookingItemModel>, String>((ref, status) async {
  return ref.watch(bookingRepositoryProvider).getBookingHistory(status: status);
});

final myTicketsProvider = FutureProvider<List<TicketModel>>((ref) async {
  return ref.watch(bookingRepositoryProvider).getMyTickets();
});
