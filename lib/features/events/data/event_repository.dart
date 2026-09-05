import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/html_utils.dart';
import '../../tours/data/models/tour_model.dart';

class EventTicketType {
  final String code;
  final String name;
  final String? nameAr;
  final double price;
  final int maxNumber;

  const EventTicketType({
    required this.code,
    required this.name,
    this.nameAr,
    required this.price,
    this.maxNumber = 10,
  });

  String getDisplayName(bool isAr) {
    if (isAr && nameAr != null && nameAr!.isNotEmpty) return nameAr!;
    return name;
  }

  factory EventTicketType.fromJson(Map<String, dynamic> json) {
    return EventTicketType(
      code: json['code']?.toString() ?? 'ticket_standard',
      name: json['name']?.toString() ?? 'تذكرة قياسية',
      nameAr: json['name_ar']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '100') ?? 100.0,
      maxNumber: int.tryParse(json['number']?.toString() ?? '10') ?? 10,
    );
  }
}

class EventItemModel {
  final String id;
  final String title;
  final String location;
  final String date;
  final String price;
  final double priceNumeric;
  final double? salePrice;
  final String imageUrl;
  final String description;
  final String duration;
  final String? startTime;
  final String? endTime;
  final List<String> gallery;
  final List<EventTicketType> ticketTypes;
  final List<ExtraPriceModel> extraPrices;

  const EventItemModel({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.priceNumeric,
    this.salePrice,
    required this.imageUrl,
    required this.description,
    this.duration = '٤ ساعات',
    this.startTime,
    this.endTime,
    this.gallery = const [],
    this.ticketTypes = const [],
    this.extraPrices = const [],
  });

  factory EventItemModel.fromJson(Map<String, dynamic> map) {
    final rawPrice = double.tryParse(map['price']?.toString() ?? '150') ?? 150.0;
    final sale = map['sale_price'] != null ? double.tryParse(map['sale_price'].toString()) : null;

    // Gallery
    List<String> gal = [];
    if (map['gallery'] is List) {
      gal = (map['gallery'] as List)
          .whereType<String>()
          .where((e) => e.isNotEmpty && !e.contains('127.0.0.1'))
          .toList();
    }

    String img = map['image_url']?.toString() ?? map['image']?.toString() ?? '';
    if (img.isEmpty || img.contains('127.0.0.1')) {
      img = gal.isNotEmpty ? gal.first : 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=80';
    }

    // Tickets
    List<EventTicketType> tickets = [];
    if (map['ticket_types'] is List) {
      tickets = (map['ticket_types'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => EventTicketType.fromJson(e))
          .toList();
    }

    // Extras
    List<ExtraPriceModel> extras = [];
    if (map['extra_price'] is List) {
      extras = (map['extra_price'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ExtraPriceModel.fromJson(e))
          .toList();
    }

    final rawContent = map['content']?.toString() ?? map['desc']?.toString() ?? '';
    final cleanDesc = HtmlUtils.stripHtml(rawContent);

    return EventItemModel(
      id: map['id']?.toString() ?? '0',
      title: map['title']?.toString() ?? map['name']?.toString() ?? 'فعالية سعودية',
      location: map['location'] is Map ? map['location']['name']?.toString() ?? map['location']['title']?.toString() ?? 'المملكة' : (map['location']?.toString() ?? 'المملكة'),
      date: map['start_date']?.toString() ?? map['date']?.toString() ?? 'موسم الفعاليات',
      price: '${(sale ?? rawPrice).toStringAsFixed(0)} ر.س',
      priceNumeric: sale ?? rawPrice,
      salePrice: sale,
      imageUrl: img,
      description: cleanDesc.isNotEmpty ? cleanDesc : 'فعالية سياحية وثقافية غنية بالعروض الحية والأنشطة الترفيهية.',
      duration: map['duration']?.toString() ?? '٤ ساعات',
      startTime: map['start_time']?.toString(),
      endTime: map['end_time']?.toString(),
      gallery: gal,
      ticketTypes: tickets,
      extraPrices: extras,
    );
  }
}

abstract class EventRepository {
  Future<List<EventItemModel>> searchEvents({String? search, int? locationId, int page = 1});
  Future<EventItemModel> getEventDetail(dynamic id);
}

class EventRepositoryImpl implements EventRepository {
  final Dio _dio;

  EventRepositoryImpl(this._dio);

  @override
  Future<List<EventItemModel>> searchEvents({String? search, int? locationId, int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.eventSearch,
        queryParameters: {
          if (search != null && search.isNotEmpty) 's': search,
          if (locationId != null) 'location_id': locationId,
          'page': page,
          'limit': 12,
        },
      );
      final data = response.data;
      final list = data is Map && data['data'] is List ? data['data'] as List : (data is List ? data : []);
      return list.map((e) => EventItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<EventItemModel> getEventDetail(dynamic id) async {
    try {
      final response = await _dio.get(ApiEndpoints.eventDetail(id));
      final map = response.data is Map && response.data['data'] != null ? response.data['data'] as Map<String, dynamic> : response.data as Map<String, dynamic>;
      return EventItemModel.fromJson(map);
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

final eventDetailProvider = FutureProvider.family<EventItemModel, dynamic>((ref, id) async {
  return ref.watch(eventRepositoryProvider).getEventDetail(id);
});
