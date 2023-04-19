import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../profile/user_data_profile.dart';

class PostCard extends StatelessWidget {
  final Post post;
  late final String viewImageUser = post.creatorUsername;

  PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        User user = User('', post.creatorUsername, '');
        Get.to(() => UserProfileVisualizer(
              user: user,
            ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://api.dicebear.com/6.x/initials/jpg?seed=$viewImageUser'),
                    radius: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    post.creatorUsername,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                post.content,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Posted on ${post.createdDate}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
