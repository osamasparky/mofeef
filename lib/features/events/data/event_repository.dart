import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../presentation/event_list_screen.dart';

abstract class EventRepository {
  Future<List<EventItemModel>> searchEvents({String? search, int page = 1});
  Future<EventItemModel> getEventDetail(dynamic id);
}

class EventRepositoryImpl implements EventRepository {
  final Dio _dio;

  EventRepositoryImpl(this._dio);

  @override
  Future<List<EventItemModel>> searchEvents({String? search, int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.eventSearch,
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
        return EventItemModel(
          id: map['id']?.toString() ?? '0',
          title: map['title']?.toString() ?? map['name']?.toString() ?? 'فعالية سعودية',
          location: map['location'] is Map ? map['location']['name']?.toString() ?? 'المملكة' : 'المملكة',
          date: map['start_date']?.toString() ?? 'موسم فعاليات',
          price: '${map['price'] ?? '150'} ر.س',
          imageUrl: map['image_url']?.toString() ?? map['image']?.toString() ?? 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=80',
        );
      }).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<EventItemModel> getEventDetail(dynamic id) async {
    try {
      final response = await _dio.get(ApiEndpoints.eventDetail(id));
      final map = response.data is Map && response.data['data'] != null ? response.data['data'] as Map<String, dynamic> : response.data as Map<String, dynamic>;
      return EventItemModel(
        id: map['id']?.toString() ?? id.toString(),
        title: map['title']?.toString() ?? map['name']?.toString() ?? 'فعالية سعودية',
        location: map['location'] is Map ? map['location']['name']?.toString() ?? 'المملكة' : 'المملكة',
        date: map['start_date']?.toString() ?? 'موسم فعاليات',
        price: '${map['price'] ?? '150'} ر.س',
        imageUrl: map['image_url']?.toString() ?? map['image']?.toString() ?? 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=80',
      );
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }
}

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(ref.watch(dioProvider));
});

final eventsListProvider = FutureProvider<List<EventItemModel>>((ref) async {
  return ref.watch(eventRepositoryProvider).searchEvents();
});
