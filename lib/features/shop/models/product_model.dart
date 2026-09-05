class ProductModel {
  final String id;
  final String title;
  final String category;
  final String storeName;
  final String price;
  final double priceNumeric;
  final String originalPrice;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final String description;

  const ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.storeName,
    required this.price,
    required this.priceNumeric,
    required this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.description,
  });
}
