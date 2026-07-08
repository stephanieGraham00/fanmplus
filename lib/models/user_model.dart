class UserModel {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String avatarUrl;
  final bool isAnonymous;
  final List<String> followers;
  final List<String> following;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.bio = '',
    this.avatarUrl = '',
    this.isAnonymous = false,
    this.followers = const [],
    this.following = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get followerCount => followers.length;
  int get followingCount => following.length;

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? bio,
    String? avatarUrl,
    bool? isAnonymous,
    List<String>? followers,
    List<String>? following,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'bio': bio,
        'avatarUrl': avatarUrl,
        'isAnonymous': isAnonymous,
        'followers': followers,
        'following': following,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        bio: json['bio'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String? ?? '',
        isAnonymous: json['isAnonymous'] as bool? ?? false,
        followers: List<String>.from(json['followers'] as List? ?? []),
        following: List<String>.from(json['following'] as List? ?? []),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
