import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final bool isFollowing;
  final VoidCallback onFollow;
  final VoidCallback onMessage;

  const UserTile({
    super.key,
    required this.user,
    required this.isFollowing,
    required this.onFollow,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.roseLight,
          child: Text(
            user.username[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          user.bio.isNotEmpty ? user.bio : '${user.followerCount} swivan',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFollowing ? Icons.person_remove : Icons.person_add,
                color: AppTheme.rose,
              ),
              onPressed: onFollow,
              tooltip: isFollowing ? 'Retire swivi' : 'Swiv',
            ),
            IconButton(
              icon: const Icon(Icons.message, color: AppTheme.lavender),
              onPressed: onMessage,
              tooltip: 'Voye mesaj',
            ),
          ],
        ),
      ),
    );
  }
}
