import '../../../../core/utils/html_utils.dart';

class ProductSpecification {
  final String title;
  final String content;

  const ProductSpecification({
    required this.title,
    required this.content,
  });

  factory ProductSpecification.fromJson(Map<String, dynamic> json) {
    return ProductSpecification(
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }
}

class ProductModel {
  final String id;
  final String title;
  final String category;
  final String storeName;
  final String price;
  final double priceNumeric;
  final String originalPrice;
  final String? discountPercent;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final String description;
  final String? sku;
  final String? stockStatus;
  final bool inStock;
  final int quantity;
  final List<String> gallery;
  final List<ProductSpecification> specifications;
  final List<ProductModel> related;

  const ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.storeName,
    required this.price,
    required this.priceNumeric,
    required this.originalPrice,
    this.discountPercent,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.description,
    this.sku,
    this.stockStatus,
    this.inStock = true,
    this.quantity = 10,
    this.gallery = const [],
    this.specifications = const [],
    this.related = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['sale_price'] ?? json['price'] ?? 0;
    final rawOriginPrice = json['price'] ?? json['origin_price'] ?? rawPrice;
    final numPrice = double.tryParse(rawPrice.toString()) ?? 0.0;
    final numOrigin = double.tryParse(rawOriginPrice.toString()) ?? numPrice;

    final displayPrice = json['display_price']?.toString() ?? '${numPrice.toStringAsFixed(0)} ر.س';
    final displayOrigin = json['display_regular_price']?.toString() ?? '${numOrigin.toStringAsFixed(0)} ر.س';

    // Parse specifications
    List<ProductSpecification> specs = [];
    if (json['specifications'] is List) {
      specs = (json['specifications'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ProductSpecification.fromJson(e))
          .toList();
    }

    // Parse gallery
    List<String> gal = [];
    if (json['gallery'] is List) {
      gal = (json['gallery'] as List)
          .map((e) => e is Map ? e['large']?.toString() ?? e['thumb']?.toString() : e.toString())
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .toList();
    }

    // Parse related
    List<ProductModel> rel = [];
    if (json['related'] is List) {
      rel = (json['related'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    // Rating
    double parsedRating = 5.0;
    int parsedReviews = 10;
    if (json['review_score'] is Map) {
      parsedRating = double.tryParse(json['review_score']['score_total']?.toString() ?? '5') ?? 5.0;
      parsedReviews = int.tryParse(json['review_score']['total_review']?.toString() ?? '0') ?? 0;
      if (parsedRating == 0) parsedRating = 5.0;
    } else if (json['review_score'] != null) {
      parsedRating = double.tryParse(json['review_score'].toString()) ?? 5.0;
    }

    final titleStr = json['title']?.toString() ?? json['name']?.toString() ?? '';
    String? rawImg = json['image_url']?.toString() ?? json['image']?.toString();
    if (rawImg != null && (rawImg.isEmpty || rawImg.contains('127.0.0.1') || rawImg == 'null')) {
      rawImg = null;
    }

    String chosenImg;
    if (rawImg != null && rawImg.isNotEmpty) {
      chosenImg = rawImg;
    } else if (gal.isNotEmpty) {
      chosenImg = gal.first;
    } else if (titleStr.contains('تمر') || titleStr.contains('عجوة')) {
      chosenImg = 'https://staging.modeefe.com/uploads/0000/6/2026/06/13/59d5a114-b797-46a0-ab4b-105e3d06f637.jpg';
    } else if (titleStr.contains('عسل')) {
      chosenImg = 'https://staging.modeefe.com/uploads/0000/6/2026/06/13/e1cca3ea-806b-4c5b-8cd4-fd5ce5135344.jpg';
    } else if (titleStr.contains('مبخرة') || titleStr.contains('بخور')) {
      chosenImg = 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=800&q=80';
    } else if (titleStr.contains('مسك') || titleStr.contains('عطر')) {
      chosenImg = 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=800&q=80';
    } else if (titleStr.contains('كعبة') || titleStr.contains('الكعبه') || titleStr.contains('مفتاح')) {
      chosenImg = 'https://images.unsplash.com/photo-1564769625905-50e93615e769?w=800&q=80';
    } else if (titleStr.contains('مجسم') || titleStr.contains('الواجهه')) {
      chosenImg = 'https://images.unsplash.com/photo-1580418827493-f2b22c0a76cb?w=800&q=80';
    } else if (titleStr.contains('تيشرت') || titleStr.contains('قميص')) {
      chosenImg = 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&q=80';
    } else if (titleStr.contains('كوب') || titleStr.contains('حراري')) {
      chosenImg = 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80';
    } else {
      chosenImg = 'https://images.unsplash.com/photo-1580418827493-f2b22c0a76cb?w=800&q=80';
    }

    final rawDesc = json['content']?.toString() ?? json['desc']?.toString() ?? '';
    final cleanDesc = HtmlUtils.stripHtml(rawDesc);

    return ProductModel(
      id: json['id']?.toString() ?? '0',
      title: titleStr.isNotEmpty ? titleStr : 'منتج تراثي فاخر',
      category: json['category'] is Map ? json['category']['name']?.toString() ?? 'مقتنيات' : (json['category']?.toString() ?? 'مقتنيات'),
      storeName: json['store'] is Map ? json['store']['name']?.toString() ?? 'بازار مُضيف للمقتنيات' : 'بازار مُضيف للمقتنيات',
      price: displayPrice.contains('ر.س') || displayPrice.contains('﷼') ? displayPrice : '$displayPrice ر.س',
      priceNumeric: numPrice,
      originalPrice: displayOrigin.contains('ر.س') || displayOrigin.contains('﷼') ? displayOrigin : '$displayOrigin ر.س',
      discountPercent: json['discount_percent']?.toString(),
      rating: parsedRating,
      reviewsCount: parsedReviews > 0 ? parsedReviews : 10,
      imageUrl: chosenImg,
      description: cleanDesc.isNotEmpty ? cleanDesc : 'منتج سعودي أصيل من بازار مُضيف، منتقى بعناية ليعكس عراقة الهوية الوطنية.',
      sku: json['sku']?.toString(),
      stockStatus: json['stock_status']?.toString() ?? 'in',
      inStock: json['in_stock'] == true || json['stock_status'] == 'in' || (json['quantity'] is int && (json['quantity'] as int) > 0),
      quantity: json['quantity'] is int ? json['quantity'] as int : int.tryParse(json['quantity']?.toString() ?? '10') ?? 10,
      gallery: gal.isNotEmpty ? gal : [chosenImg],
      specifications: specs,
      related: rel,
    );
  }
}
