import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  void _createPost() {
    final postController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouvo pòs'),
        content: TextField(
          controller: postController,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Kisa w ap panse?',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              postController.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('Anile'),
          ),
          ElevatedButton(
            onPressed: () {
              if (postController.text.trim().isNotEmpty) {
                final auth = context.read<AuthService>();
                final storage = context.read<StorageService>();
                storage.addPost(PostModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: auth.currentUser!.id,
                  username: auth.currentUser!.isAnonymous
                      ? 'Anonim'
                      : auth.currentUser!.username,
                  content: postController.text.trim(),
                  isAnonymous: auth.currentUser!.isAnonymous,
                ));
                postController.dispose();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Pibliye'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final auth = context.watch<AuthService>();
    final posts = storage.posts;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.rosePale, AppTheme.lavenderPale],
        ),
      ),
      child: posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🌸', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text(
                    'Pa gen pòs ankò',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Se ou ki premye! Kreye yon pòs.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _createPost,
                    icon: const Icon(Icons.add),
                    label: const Text('Kreye premye pòs'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: posts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        FloatingActionButton.small(
                          onPressed: _createPost,
                          backgroundColor: AppTheme.rose,
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }
                final post = posts[index - 1];
                final isLiked = post.likes.contains(auth.currentUser?.id);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: post.isAnonymous
                                  ? Colors.grey.shade300
                                  : AppTheme.roseLight,
                              child: Text(
                                (post.isAnonymous ? 'A' : post.username[0])
                                    .toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.isAnonymous ? 'Anonim' : post.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    _formatTime(post.createdAt),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (post.isAnonymous)
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(Icons.visibility_off,
                                    size: 16, color: Colors.grey),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.content,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                if (auth.currentUser != null) {
                                  storage.toggleLike(
                                    post.id,
                                    auth.currentUser!.id,
                                  );
                                }
                              },
                            ),
                            Text(
                              '${post.likeCount}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.comment,
                                color: Colors.grey, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${post.commentCount}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'kèk segond';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} èdtan';
    return '${diff.inDays} jou';
  }
}
