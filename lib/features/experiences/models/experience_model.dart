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
}

final List<ExperienceModel> mockExperiences = [
  const ExperienceModel(
    id: 'exp_1',
    title: 'المتحف الوطني السعودي',
    category: 'متحف',
    location: 'الرياض — مركز الملك عبدالعزيز التاريخي',
    price: '٥٠ ر.س',
    priceNumeric: 50.0,
    duration: 'ساعتان',
    rating: 4.9,
    imageUrl: 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
    description: 'تجربة ثقافية غامرة تستعرض تاريخ شبه الجزيرة العربية عبر العصور، مع معارض تفاعلية وكنوز أثرية نادرة.',
    workingHours: '٩ص — ٩م',
    gallery: [
      'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
      'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=800&q=80',
    ],
  ),
  const ExperienceModel(
    id: 'exp_2',
    title: 'مناطيد فوق سماء العُلا',
    category: 'مغامرة',
    location: 'العُلا — مدائن صالح',
    price: '١,٢٠٠ ر.س',
    priceNumeric: 1200.0,
    duration: '٣ ساعات',
    rating: 4.9,
    imageUrl: 'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=800&q=80',
    description: 'حلّق مع شروق الشمس فوق المعالم الجيولوجية والأثرية الساحرة لمحافظة العُلا في تجربة لا تُنسى.',
    workingHours: '٥ص — ٩ص',
  ),
  const ExperienceModel(
    id: 'exp_3',
    title: 'ليالي السوق التراثي بالدرعية',
    category: 'ثقافة',
    location: 'الدرعية التاريخية — حي البجيري',
    price: '٢٥٠ ر.س',
    priceNumeric: 250.0,
    duration: '٤ ساعات',
    rating: 4.8,
    imageUrl: 'https://images.unsplash.com/photo-1586724237569-f3d0c1dee8c6?w=800&q=80',
    description: 'استمتع بأجواء نجدية ساحرة، وتذوق القهوة السعودية وأشهى الأطباق التراثية في قلب الدرعية التاريخية.',
    workingHours: '٤م — ١٢ص',
  ),
  const ExperienceModel(
    id: 'exp_4',
    title: 'جولة درب زبيدة التاريخية',
    category: 'رحلة أثرية',
    location: 'حائل — طريق القوافل القديم',
    price: '٤٥٠ ر.س',
    priceNumeric: 450.0,
    duration: 'يوم كامل',
    rating: 4.7,
    imageUrl: 'https://images.unsplash.com/photo-1518684079-3c830dcef090?w=800&q=80',
    description: 'استكشف مسارات الحج القديمة والبرك والمعالم المائية التاريخية مع مرشدين سياحيين سعوديين معتمدين.',
    workingHours: '٧ص — ٦م',
  ),
];
