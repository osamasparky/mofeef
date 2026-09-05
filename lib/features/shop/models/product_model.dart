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

final List<ProductModel> mockProducts = [
  const ProductModel(
    id: 'prod_1',
    title: 'مفتاح الكعبة — نسخة تذكارية مطلية بالذهب',
    category: 'مقتنيات وتحف',
    storeName: 'بازار مُضيف للمقتنيات',
    price: '١,٤٥٠ ر.س',
    priceNumeric: 1450.0,
    originalPrice: '١,٧٩٠ ر.س',
    rating: 5.0,
    reviewsCount: 24,
    imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80',
    description: 'نسخة طبق الأصل فاخرة ومطلية بالذهب عيار ٢٤ قيراط في صندوق مخملي فاخر.',
  ),
  const ProductModel(
    id: 'prod_2',
    title: 'دلة رسلان التراثية الأصلية',
    category: 'حِرَف يدوية',
    storeName: 'حرفيو نجد',
    price: '٣٨٠ ر.س',
    priceNumeric: 380.0,
    originalPrice: '٤٥٠ ر.س',
    rating: 4.9,
    reviewsCount: 18,
    imageUrl: 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=800&q=80',
    description: 'دلة قهوة سعودية نحاسية مصنوعة يدوياً بدقة متناهية مع نقوش تراثية أصيلة.',
  ),
  const ProductModel(
    id: 'prod_3',
    title: 'عود كلمنتان مالينو فاخر',
    category: 'عطور وبخور',
    storeName: 'دار الطيب السعودي',
    price: '٦٥٠ ر.س',
    priceNumeric: 650.0,
    originalPrice: '٨٠٠ ر.س',
    rating: 4.9,
    reviewsCount: 32,
    imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=800&q=80',
    description: 'أجود أنواع العود الطبيعي المحسن بنكهة سويتية مميزة وثبات يدوم طويلاً.',
  ),
  const ProductModel(
    id: 'prod_4',
    title: 'صندوق تمر خلاص ملكي مع مكسرات',
    category: 'مأكولات',
    storeName: 'واحة الأحساء',
    price: '١٩٠ ر.س',
    priceNumeric: 190.0,
    originalPrice: '٢٣٠ ر.س',
    rating: 4.8,
    reviewsCount: 45,
    imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800&q=80',
    description: 'تمور خلاص الأحساء المنتقاة بعناية والمحشوة بأفخر أنواع المكسرات والهيل.',
  ),
];
