class ServiceCategoryModel {
  final int id;
  final String name;
  final String? slug;
  final String? icon;

  const ServiceCategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.icon,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      slug: json['slug']?.toString(),
      icon: json['icon']?.toString(),
    );
  }
}

class LocationModel {
  final int id;
  final String name;
  final String? slug;
  final String? imageUrl;
  final String? bannerUrl;

  const LocationModel({
    required this.id,
    required this.name,
    this.slug,
    this.imageUrl,
    this.bannerUrl,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      slug: json['slug']?.toString(),
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      bannerUrl: json['banner_image']?.toString(),
    );
  }
}

class NewsItemModel {
  final int id;
  final String title;
  final String? content;
  final String? imageUrl;
  final String? createdAt;

  const NewsItemModel({
    required this.id,
    required this.title,
    this.content,
    this.imageUrl,
    this.createdAt,
  });

  factory NewsItemModel.fromJson(Map<String, dynamic> json) {
    return NewsItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? json['desc']?.toString(),
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
