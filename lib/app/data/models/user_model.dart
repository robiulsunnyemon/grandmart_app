// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — User Model
// ════════════════════════════════════════════════════════════════════════════

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final String? profilePicture;
  final bool isVerified;
  final bool isActive;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    this.profilePicture,
    required this.isVerified,
    required this.isActive,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? 'customer',
      profilePicture: json['profile_picture'],
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'profile_picture': profilePicture,
      'is_verified': isVerified,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }
}

class AuthTokenModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final UserModel user;

  AuthTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.user,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      role: json['role'] ?? 'customer',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
