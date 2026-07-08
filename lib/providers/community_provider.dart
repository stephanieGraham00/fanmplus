import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';

class CommunityState {
  final List<CommunityPost> posts;
  final bool isLoading;

  const CommunityState({
    this.posts = const [],
    this.isLoading = false,
  });

  CommunityState copyWith({
    List<CommunityPost>? posts,
    bool? isLoading,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  CommunityNotifier() : super(const CommunityState());

  void addPost(CommunityPost post) {
    state = state.copyWith(posts: [post, ...state.posts]);
  }

  void toggleLike(String postId, String userId) {
    final updated = state.posts.map((post) {
      if (post.id != postId) return post;
      final likes = List<String>.from(post.likes);
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }
      return post.copyWith(likes: likes);
    }).toList();
    state = state.copyWith(posts: updated);
  }

  void addComment(String postId, Comment comment) {
    final updated = state.posts.map((post) {
      if (post.id != postId) return post;
      return CommunityPost(
        id: post.id,
        userId: post.userId,
        authorName: post.authorName,
        authorAvatar: post.authorAvatar,
        content: post.content,
        likes: post.likes,
        comments: [...post.comments, comment],
        isAnonymous: post.isAnonymous,
        createdAt: post.createdAt,
      );
    }).toList();
    state = state.copyWith(posts: updated);
  }
}

final communityProvider = StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  return CommunityNotifier();
});
