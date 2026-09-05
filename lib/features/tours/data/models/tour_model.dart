class ItineraryItem {
  final String title;
  final String? desc;
  final String? content;
  final String? image;

  const ItineraryItem({
    required this.title,
    this.desc,
    this.content,
    this.image,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      title: json['title']?.toString() ?? '',
      desc: json['desc']?.toString(),
      content: json['content']?.toString(),
      image: json['image']?.toString(),
    );
  }
}

class FaqItem {
  final String title;
  final String content;

  const FaqItem({required this.title, required this.content});

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }
}

class TourModel {
  final int id;
  final String title;
  final String? slug;
  final String? content;
  final String? imageUrl;
  final String? bannerUrl;
  final List<String> gallery;
  final double price;
  final double? salePrice;
  final String? duration;
  final double rating;
  final int reviewsCount;
  final String? locationName;
  final String? address;
  final double? mapLat;
  final double? mapLng;
  final String? categoryName;
  final bool isFeatured;
  final List<ItineraryItem> itinerary;
  final List<String> includes;
  final List<String> excludes;
  final List<FaqItem> faqs;

  const TourModel({
    required this.id,
    required this.title,
    this.slug,
    this.content,
    this.imageUrl,
    this.bannerUrl,
    this.gallery = const [],
    required this.price,
    this.salePrice,
    this.duration,
    required this.rating,
    required this.reviewsCount,
    this.locationName,
    this.address,
    this.mapLat,
    this.mapLng,
    this.categoryName,
    this.isFeatured = false,
    this.itinerary = const [],
    this.includes = const [],
    this.excludes = const [],
    this.faqs = const [],
  });

  String get formattedPrice => '${(salePrice ?? price).toStringAsFixed(0)} ر.س';

  factory TourModel.fromJson(Map<String, dynamic> json) {
    double parsedRating = 4.8;
    int parsedReviews = 12;

    if (json['review_score'] is Map) {
      parsedRating = double.tryParse(json['review_score']['score_total']?.toString() ?? '4.8') ?? 4.8;
      parsedReviews = int.tryParse(json['review_score']['total_review']?.toString() ?? '12') ?? 12;
    } else if (json['review_score'] != null) {
      parsedRating = double.tryParse(json['review_score']?.toString() ?? '4.8') ?? 4.8;
    }

    String? img = json['image_url']?.toString() ?? json['image']?.toString();
    if (img == null || img.isEmpty || img.contains('127.0.0.1')) {
      img = 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80';
    }

    // Gallery
    List<String> parsedGallery = [];
    if (json['gallery'] is List) {
      for (var item in (json['gallery'] as List)) {
        if (item != null && item.toString().isNotEmpty && !item.toString().contains('127.0.0.1')) {
          parsedGallery.add(item.toString());
        }
      }
    }
    if (parsedGallery.isEmpty && img.isNotEmpty) {
      parsedGallery.add(img);
    }

    // Itinerary
    List<ItineraryItem> parsedItinerary = [];
    if (json['itinerary'] is List) {
      for (var item in (json['itinerary'] as List)) {
        if (item is Map<String, dynamic>) {
          parsedItinerary.add(ItineraryItem.fromJson(item));
        }
      }
    }

    // Includes & Excludes
    List<String> parsedIncludes = [];
    if (json['include'] is List) {
      for (var item in (json['include'] as List)) {
        if (item is Map && item['title'] != null) {
          parsedIncludes.add(item['title'].toString());
        } else if (item is String) {
          parsedIncludes.add(item);
        }
      }
    }

    List<String> parsedExcludes = [];
    if (json['exclude'] is List) {
      for (var item in (json['exclude'] as List)) {
        if (item is Map && item['title'] != null) {
          parsedExcludes.add(item['title'].toString());
        } else if (item is String) {
          parsedExcludes.add(item);
        }
      }
    }

    // FAQs
    List<FaqItem> parsedFaqs = [];
    if (json['faqs'] is List) {
      for (var item in (json['faqs'] as List)) {
        if (item is Map<String, dynamic>) {
          parsedFaqs.add(FaqItem.fromJson(item));
        }
      }
    }

    return TourModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString(),
      content: json['content']?.toString() ?? json['desc']?.toString(),
      imageUrl: img,
      bannerUrl: json['banner_image']?.toString(),
      gallery: parsedGallery,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      salePrice: double.tryParse(json['sale_price']?.toString() ?? ''),
      duration: json['duration']?.toString() ?? 'ساعتان',
      rating: parsedRating,
      reviewsCount: parsedReviews,
      locationName: json['location'] is Map ? json['location']['name']?.toString() : (json['location']?.toString() ?? 'المملكة العربية السعودية'),
      address: json['address']?.toString(),
      mapLat: double.tryParse(json['map_lat']?.toString() ?? ''),
      mapLng: double.tryParse(json['map_lng']?.toString() ?? ''),
      categoryName: json['category'] is Map ? json['category']['name']?.toString() : (json['category']?.toString() ?? 'مسار سياحي'),
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      itinerary: parsedItinerary,
      includes: parsedIncludes,
      excludes: parsedExcludes,
      faqs: parsedFaqs,
    );
  }
}
