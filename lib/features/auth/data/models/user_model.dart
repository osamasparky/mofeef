class UserModel {
  final int id;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? role;
  final String? token;

  const UserModel({
    required this.id,
    this.name,
    this.firstName,
    this.lastName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.role,
    this.token,
  });

  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return email.split('@').first;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle nested user/data if present
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;

    return UserModel(
      id: data['id'] is int ? data['id'] : int.tryParse(data['id']?.toString() ?? '0') ?? 0,
      name: data['name']?.toString(),
      firstName: data['first_name']?.toString(),
      lastName: data['last_name']?.toString(),
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString(),
      avatarUrl: data['avatar_url']?.toString() ?? data['avatar']?.toString(),
      role: data['role']?.toString(),
      token: json['access_token']?.toString() ?? json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'role': role,
    };
  }
}
