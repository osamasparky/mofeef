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

class PersonTypeModel {
  final String name;
  final String? desc;
  final String? nameAr;
  final String? descAr;
  final int min;
  final int max;
  final double price;

  const PersonTypeModel({
    required this.name,
    this.desc,
    this.nameAr,
    this.descAr,
    this.min = 0,
    this.max = 10,
    required this.price,
  });

  String getDisplayName(bool isAr) {
    if (isAr && nameAr != null && nameAr!.isNotEmpty) return nameAr!;
    return name;
  }

  String? getDisplayDesc(bool isAr) {
    if (isAr && descAr != null && descAr!.isNotEmpty) return descAr!;
    return desc;
  }

  factory PersonTypeModel.fromJson(Map<String, dynamic> json) {
    return PersonTypeModel(
      name: json['name']?.toString() ?? 'تذكرة',
      desc: json['desc']?.toString(),
      nameAr: json['name_ar']?.toString(),
      descAr: json['desc_ar']?.toString(),
      min: int.tryParse(json['min']?.toString() ?? '0') ?? 0,
      max: int.tryParse(json['max']?.toString() ?? '10') ?? 10,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class ExtraPriceModel {
  final String name;
  final String? nameAr;
  final double price;
  final String type;

  const ExtraPriceModel({
    required this.name,
    this.nameAr,
    required this.price,
    this.type = 'one_time',
  });

  String getDisplayName(bool isAr) {
    if (isAr && nameAr != null && nameAr!.isNotEmpty) return nameAr!;
    return name;
  }

  factory ExtraPriceModel.fromJson(Map<String, dynamic> json) {
    return ExtraPriceModel(
      name: json['name']?.toString() ?? 'خدمة إضافية',
      nameAr: json['name_ar']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      type: json['type']?.toString() ?? 'one_time',
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
  final List<PersonTypeModel> personTypes;
  final List<ExtraPriceModel> extraPrices;
  final Map<String, dynamic>? openHours;

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
    this.personTypes = const [],
    this.extraPrices = const [],
    this.openHours,
  });

  String get formattedPrice => '${(salePrice ?? price).toStringAsFixed(0)} ر.س';
  double get priceNumeric => salePrice ?? price;
  String get description => content ?? '';

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
      parsedIncludes = (json['include'] as List)
          .map((e) => e is Map ? e['title']?.toString() ?? '' : e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    List<String> parsedExcludes = [];
    if (json['exclude'] is List) {
      parsedExcludes = (json['exclude'] as List)
          .map((e) => e is Map ? e['title']?.toString() ?? '' : e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
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

    // Person Types
    List<PersonTypeModel> parsedPersonTypes = [];
    if (json['person_types'] is List) {
      for (var item in (json['person_types'] as List)) {
        if (item is Map<String, dynamic>) {
          parsedPersonTypes.add(PersonTypeModel.fromJson(item));
        }
      }
    }

    // Extra Prices
    List<ExtraPriceModel> parsedExtraPrices = [];
    if (json['extra_price'] is List) {
      for (var item in (json['extra_price'] as List)) {
        if (item is Map<String, dynamic>) {
          parsedExtraPrices.add(ExtraPriceModel.fromJson(item));
        }
      }
    }

    return TourModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? json['name']?.toString() ?? 'مسار سياحي',
      slug: json['slug']?.toString(),
      content: json['content']?.toString() ?? json['desc']?.toString(),
      imageUrl: img,
      bannerUrl: json['banner_image']?.toString(),
      gallery: parsedGallery,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      salePrice: json['sale_price'] != null ? double.tryParse(json['sale_price'].toString()) : null,
      duration: json['duration']?.toString() ?? (json['duration_hours'] != null ? '${json['duration_hours']} ساعات' : null),
      rating: parsedRating,
      reviewsCount: parsedReviews,
      locationName: json['location'] is Map ? json['location']['name']?.toString() ?? json['location']['title']?.toString() : json['location']?.toString(),
      address: json['address']?.toString(),
      mapLat: json['map_lat'] != null ? double.tryParse(json['map_lat'].toString()) : null,
      mapLng: json['map_lng'] != null ? double.tryParse(json['map_lng'].toString()) : null,
      categoryName: json['category'] is Map ? json['category']['name']?.toString() : json['category']?.toString(),
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      itinerary: parsedItinerary,
      includes: parsedIncludes,
      excludes: parsedExcludes,
      faqs: parsedFaqs,
      personTypes: parsedPersonTypes,
      extraPrices: parsedExtraPrices,
      openHours: json['open_hours'] is Map<String, dynamic> ? json['open_hours'] as Map<String, dynamic> : null,
    );
  }
}
