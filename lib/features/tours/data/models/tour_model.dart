class TourModel {
  final int id;
  final String title;
  final String? slug;
  final String? content;
  final String? imageUrl;
  final String? bannerUrl;
  final double price;
  final double? salePrice;
  final String? duration;
  final double rating;
  final int reviewsCount;
  final String? locationName;
  final String? categoryName;
  final bool isFeatured;

  const TourModel({
    required this.id,
    required this.title,
    this.slug,
    this.content,
    this.imageUrl,
    this.bannerUrl,
    required this.price,
    this.salePrice,
    this.duration,
    required this.rating,
    required this.reviewsCount,
    this.locationName,
    this.categoryName,
    this.isFeatured = false,
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

    return TourModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString(),
      content: json['content']?.toString() ?? json['desc']?.toString(),
      imageUrl: img,
      bannerUrl: json['banner_image']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      salePrice: double.tryParse(json['sale_price']?.toString() ?? ''),
      duration: json['duration']?.toString() ?? 'ساعتان',
      rating: parsedRating,
      reviewsCount: parsedReviews,
      locationName: json['location'] is Map ? json['location']['name']?.toString() : (json['location']?.toString() ?? 'العُلا'),
      categoryName: json['category'] is Map ? json['category']['name']?.toString() : (json['category']?.toString() ?? 'تجربة سياحية'),
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
    );
  }
}
