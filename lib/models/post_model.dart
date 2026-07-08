class PostModel {
  final String id;
  final String userId;
  final String username;
  final String content;
  final String imageUrl;
  final List<String> likes;
  final List<Comment> comments;
  final DateTime createdAt;
  final bool isAnonymous;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    this.imageUrl = '',
    this.likes = const [],
    this.comments = const [],
    DateTime? createdAt,
    this.isAnonymous = false,
  }) : createdAt = createdAt ?? DateTime.now();

  int get likeCount => likes.length;
  int get commentCount => comments.length;

  PostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? content,
    String? imageUrl,
    List<String>? likes,
    List<Comment>? comments,
    DateTime? createdAt,
    bool? isAnonymous,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'username': username,
        'content': content,
        'imageUrl': imageUrl,
        'likes': likes,
        'comments': comments.map((c) => c.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'isAnonymous': isAnonymous,
      };

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        username: json['username'] as String,
        content: json['content'] as String,
        imageUrl: json['imageUrl'] as String? ?? '',
        likes: List<String>.from(json['likes'] as List? ?? []),
        comments: (json['comments'] as List? ?? [])
            .map((c) => Comment.fromJson(c as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        isAnonymous: json['isAnonymous'] as bool? ?? false,
      );
}

class Comment {
  final String id;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'username': username,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] as String,
        userId: json['userId'] as String,
        username: json['username'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
