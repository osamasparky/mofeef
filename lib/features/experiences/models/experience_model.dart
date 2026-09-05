class ExperienceModel {
  final String id;
  final String title;
  final String category;
  final String location;
  final String price;
  final double priceNumeric;
  final String duration;
  final double rating;
  final String imageUrl;
  final String description;
  final String workingHours;
  final List<String> gallery;

  const ExperienceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.price,
    required this.priceNumeric,
    required this.duration,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.workingHours,
    this.gallery = const [],
  });

  factory ExperienceModel.fromTour(dynamic tour) {
    return ExperienceModel(
      id: tour.id.toString(),
      title: tour.title,
      category: tour.categoryName ?? 'تجربة سياحية',
      location: tour.locationName ?? 'المملكة العربية السعودية',
      price: tour.formattedPrice,
      priceNumeric: tour.salePrice ?? tour.price,
      duration: tour.duration ?? 'ساعتان',
      rating: tour.rating,
      imageUrl: tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
      description: tour.content ?? '',
      workingHours: '٩ص — ٩م',
    );
  }
}
