import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../models/post_model.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final _postController = TextEditingController();

  final _samplePosts = [
    CommunityPost(
      id: '1', userId: 'u1', authorName: 'Fanm+ Sè', content: 'Kòmanse swiv sik mwen ak Fanm+ AI! Finalman m ap konprann kò m pi byen ♥', likes: ['u2', 'u3'], comments: [], isAnonymous: false, createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    CommunityPost(
      id: '2', userId: 'u2', authorName: 'Sante Fanm', content: 'Èske w te konnen? Fenèt fetil la se 6 jou chak sik. Konesans se pouvwa! ♥', likes: ['u1', 'u3', 'u4'], comments: [], isAnonymous: false, createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    CommunityPost(
      id: '3', userId: 'u3', authorName: 'Dwa Fanm', content: 'Kò w, règ ou. Pèsonn pa gen dwa manyen ou san konsantman ou. ✊', likes: ['u1', 'u2', 'u4', 'u5'], comments: [], isAnonymous: false, createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void _publishPost() {
    if (_postController.text.trim().isEmpty) return;
    final post = CommunityPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      authorName: 'Fanm+ Sè',
      content: _postController.text,
      likes: [],
      comments: [],
      isAnonymous: false,
      createdAt: DateTime.now(),
    );
    ref.read(communityProvider.notifier).addPost(post);
    _postController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('♥ Post pibliye!'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityProvider);
    final posts = [..._samplePosts, ...communityState.posts];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kominote', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 4),
              Text('Pataje ak sè w yo ♥', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),

              // Post composer
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _postController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Pataje ak sè w yo...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: AppColors.secondaryLight.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('🌍 Piblik', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _publishPost,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('💌 Pibliye', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Posts feed
              ...posts.map((post) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.primaryGradient),
                                child: Center(child: Text(post.authorName[0], style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold))),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.authorName, style: AppTextStyles.titleSmall),
                                  Text(post.createdAt.format(pattern: 'MMM dd'), style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(post.content, style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => ref.read(communityProvider.notifier).toggleLike(post.id, 'current_user'),
                                child: Row(
                                  children: [
                                    Icon(
                                      post.likes.contains('current_user') ? Icons.favorite : Icons.favorite_border,
                                      size: 18,
                                      color: post.likes.contains('current_user') ? AppColors.primary : AppColors.textHint,
                                    ),
                                    const SizedBox(width: 4),
                                    Text('${post.likeCount}', style: AppTextStyles.bodySmall),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Row(
                                children: [
                                  const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.textHint),
                                  const SizedBox(width: 4),
                                  Text('${post.comments.length}', style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
