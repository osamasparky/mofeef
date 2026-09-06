import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../presentation/guide_list_screen.dart';

abstract class GuideRepository {
  Future<List<GuideModel>> searchGuides({String? search, int? locationId, int page = 1});
  Future<GuideModel> getGuideDetail(dynamic id);
}

class GuideRepositoryImpl implements GuideRepository {
  final Dio _dio;

  GuideRepositoryImpl(this._dio);

  @override
  Future<List<GuideModel>> searchGuides({String? search, int? locationId, int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.guideSearch,
        queryParameters: {
          if (search != null && search.isNotEmpty) 's': search,
          if (locationId != null) 'location_id': locationId,
          'page': page,
          'limit': 100,
        },
      );
      final data = response.data;
      final list = data is Map && data['data'] is List ? data['data'] as List : (data is List ? data : []);
      return list.map((e) {
        final map = e as Map<String, dynamic>;
        final rawPrice = map['display_price_per_hour']?.toString() ?? map['price_per_hour']?.toString() ?? map['price']?.toString();
        String formattedPrice;
        if (rawPrice != null && rawPrice.isNotEmpty) {
          final clean = rawPrice.replaceAll('﷼', '').replaceAll('ر.س', '').trim();
          final numVal = double.tryParse(clean);
          formattedPrice = numVal != null ? '${numVal.toStringAsFixed(0)} ﷼ / ساعة' : '$rawPrice / ساعة';
        } else {
          formattedPrice = '250 ﷼ / ساعة';
        }

        final langList = <String>[];
        if (map['languages'] is List) {
          for (var l in map['languages']) {
            final s = l.toString();
            if (s == 'ar') {
              langList.add('العربية');
            } else if (s == 'en') {
              langList.add('الإنجليزية');
            } else if (s == 'fr') {
              langList.add('الفرنسية');
            } else if (s.isNotEmpty) {
              langList.add(s);
            }
          }
        }
        if (langList.isEmpty) {
          langList.add('العربية');
        }

        final avatar = map['avatar_url']?.toString() ?? map['image']?.toString();
        final chosenAvatar = (avatar != null && avatar.isNotEmpty && !avatar.contains('via.placeholder'))
            ? avatar
            : 'https://staging.modeefe.com/themes/mytravel/images/guide-default.jpg';

        return GuideModel(
          id: map['id']?.toString() ?? map['uuid']?.toString() ?? '0',
          name: map['name']?.toString() ?? map['title']?.toString() ?? 'مرشد سياحي معتمد',
          title: map['bio']?.toString() ?? map['guide_type']?.toString() ?? 'مرشد سياحي مرخص',
          languages: langList,
          rating: double.tryParse(map['review_score']?.toString() ?? '4.9') ?? 4.9,
          toursCount: int.tryParse(map['tours_count']?.toString() ?? map['museums_count']?.toString() ?? '12') ?? 12,
          hourlyRate: formattedPrice,
          imageUrl: chosenAvatar,
        );
      }).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }

  @override
  Future<GuideModel> getGuideDetail(dynamic id) async {
    try {
      final response = await _dio.get(ApiEndpoints.guideDetail(id));
      final map = response.data is Map && response.data['data'] != null ? response.data['data'] as Map<String, dynamic> : response.data as Map<String, dynamic>;
      return GuideModel(
        id: map['id']?.toString() ?? id.toString(),
        name: map['name']?.toString() ?? map['title']?.toString() ?? 'مرشد سياحي',
        title: map['bio']?.toString() ?? map['job']?.toString() ?? 'مرشد سياحي معتمد',
        languages: map['languages'] is List ? (map['languages'] as List).map((l) => l.toString()).toList() : ['العربية'],
        rating: double.tryParse(map['review_score']?.toString() ?? '4.9') ?? 4.9,
        toursCount: int.tryParse(map['tours_count']?.toString() ?? '50') ?? 50,
        hourlyRate: '${map['price'] ?? '150'} ﷼ / ساعة',
        imageUrl: map['avatar_url']?.toString() ?? map['image']?.toString() ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80',
      );
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    }
  }
}

final guideRepositoryProvider = Provider<GuideRepository>((ref) {
  return GuideRepositoryImpl(ref.watch(dioProvider));
});

final guidesListProvider = FutureProvider<List<GuideModel>>((ref) async {
  return ref.watch(guideRepositoryProvider).searchGuides();
});

final guideDetailProvider = FutureProvider.family<GuideModel, dynamic>((ref, id) async {
  return ref.watch(guideRepositoryProvider).getGuideDetail(id);
});

