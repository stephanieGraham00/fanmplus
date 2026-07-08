import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../theme/app_theme.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback? onComment;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLike,
    this.onComment,
  });

  @override
  Widget build(BuildContext context) {
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
                  backgroundColor:
                      post.isAnonymous ? Colors.grey.shade300 : AppTheme.roseLight,
                  child: Text(
                    (post.isAnonymous ? 'A' : post.username[0]).toUpperCase(),
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
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (post.isAnonymous)
                  const Icon(Icons.visibility_off, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content, style: const TextStyle(fontSize: 15)),
            if (post.imageUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.broken_image, size: 48)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: onLike,
                ),
                Text('${post.likeCount}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment, color: Colors.grey),
                  onPressed: onComment,
                ),
                Text('${post.commentCount}',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
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
