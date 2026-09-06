import 'dart:convert';

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
    if (name != null && name!.trim().isNotEmpty) return name!.trim();
    if (firstName != null || lastName != null) {
      final combined = '${firstName ?? ''} ${lastName ?? ''}'.trim();
      if (combined.isNotEmpty) return combined;
    }
    if (email.isNotEmpty && email.contains('@')) {
      return email.split('@').first;
    }
    return 'مسافر مُضيف';
  }

  factory UserModel.fromJson(Map<String, dynamic> json, {String? fallbackToken}) {
    // 1. Extract token (could be at root or in nested object)
    final token = json['access_token']?.toString() ??
        json['token']?.toString() ??
        json['user']?['token']?.toString() ??
        json['data']?['token']?.toString() ??
        fallbackToken;

    // 2. Extract user data map
    dynamic rawData = json['user'] ?? json['data'] ?? json;
    if (rawData is Map<String, dynamic> && rawData.containsKey('user') && rawData['user'] is Map) {
      rawData = rawData['user'];
    }
    final Map<String, dynamic> data = rawData is Map<String, dynamic> ? rawData : json;

    final idVal = data['id'] ?? json['id'];
    final id = idVal is int ? idVal : (int.tryParse(idVal?.toString() ?? '0') ?? 0);

    final fName = data['first_name']?.toString() ?? json['first_name']?.toString();
    final lName = data['last_name']?.toString() ?? json['last_name']?.toString();
    final rawName = data['name']?.toString() ??
        data['display_name']?.toString() ??
        data['user_name']?.toString() ??
        json['name']?.toString() ??
        json['display_name']?.toString();

    final email = data['email']?.toString() ?? json['email']?.toString() ?? '';
    final phone = data['phone']?.toString() ?? json['phone']?.toString();
    final avatar = data['avatar_url']?.toString() ??
        data['avatar']?.toString() ??
        json['avatar_url']?.toString() ??
        json['avatar']?.toString();
    final role = data['role']?.toString() ?? data['role_id']?.toString() ?? json['role']?.toString();

    return UserModel(
      id: id,
      name: rawName,
      firstName: fName,
      lastName: lName,
      email: email,
      phone: phone,
      avatarUrl: avatar,
      role: role,
      token: token,
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
      'token': token,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserModel.fromJsonString(String str) => UserModel.fromJson(jsonDecode(str) as Map<String, dynamic>);
}
