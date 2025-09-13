class ProfileModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? bio;
  final String? avatarUrl;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? email;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.bio,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.email,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  String get displayName {
    if (username?.isNotEmpty == true) return username!;
    if (firstName?.isNotEmpty == true && lastName?.isNotEmpty == true) {
      return '$firstName $lastName';
    }
    if (firstName?.isNotEmpty == true) return firstName!;
    if (lastName?.isNotEmpty == true) return lastName!;
    return email?.split('@').first ?? 'User';
  }

  String get fullName {
    if (firstName?.isNotEmpty == true && lastName?.isNotEmpty == true) {
      return '$firstName $lastName';
    }
    return displayName;
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.tryParse(json['date_of_birth']) 
          : null,
      email: json['email'],
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      postsCount: json['posts_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'bio': bio,
      'avatar_url': avatarUrl,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T')[0],
      'email': email,
      'followers_count': followersCount,
      'following_count': followingCount,
      'posts_count': postsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? bio,
    String? avatarUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? email,
    int? followersCount,
    int? followingCount,
    int? postsCount,
  }) {
    return ProfileModel(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
