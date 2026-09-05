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
    return TourModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString(),
      content: json['content']?.toString() ?? json['desc']?.toString(),
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      bannerUrl: json['banner_image']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      salePrice: double.tryParse(json['sale_price']?.toString() ?? ''),
      duration: json['duration']?.toString(),
      rating: double.tryParse(json['review_score']?.toString() ?? json['rating']?.toString() ?? '4.8') ?? 4.8,
      reviewsCount: int.tryParse(json['review_count']?.toString() ?? '12') ?? 12,
      locationName: json['location'] is Map ? json['location']['name']?.toString() : json['location']?.toString(),
      categoryName: json['category'] is Map ? json['category']['name']?.toString() : json['category']?.toString(),
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
    );
  }
}
