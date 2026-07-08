import 'package:equatable/equatable.dart';

class CommunityPost extends Equatable {
  final String id;
  final String userId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final List<String> likes;
  final List<Comment> comments;
  final bool isAnonymous;
  final DateTime createdAt;

  const CommunityPost({
    required this.id,
    required this.userId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    this.likes = const [],
    this.comments = const [],
    this.isAnonymous = false,
    required this.createdAt,
  });

  int get likeCount => likes.length;

  factory CommunityPost.fromMap(Map<String, dynamic> map, String id) {
    return CommunityPost(
      id: id,
      userId: map['user_id'] as String? ?? '',
      authorName: map['author_name'] as String? ?? 'Anonymous',
      authorAvatar: map['author_avatar'] as String?,
      content: map['content'] as String? ?? '',
      likes: (map['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      comments: (map['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      isAnonymous: map['is_anonymous'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'author_name': authorName,
      'author_avatar': authorAvatar,
      'content': content,
      'likes': likes,
      'comments': comments.map((c) => c.toMap()).toList(),
      'is_anonymous': isAnonymous,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, userId, content, likes, comments, isAnonymous];
}

class Comment extends Equatable {
  final String id;
  final String userId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.userId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      authorName: map['author_name'] as String? ?? '',
      content: map['content'] as String? ?? '',
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'author_name': authorName,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, userId, authorName, content];
}
