import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/avatar_image.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: AvatarImage(
                  key: const Key('detail_avatar'),
                  avatar: user.avatar,
                  radius: 64,
                ),
              ),
              const SizedBox(height: 24),
              // Không gộp label và value vào cùng một Text.
              // Testcase cần thấy đúng Text(user.fullName) và Text(user.email).
              Text('ID: ${user.id}', key: const Key('detail_id')),
              const SizedBox(height: 12),
              const Text('Họ và tên'),
              const SizedBox(height: 4),
              Text(user.fullName, key: const Key('detail_fullname')),
              const SizedBox(height: 12),
              const Text('Email'),
              const SizedBox(height: 4),
              Text(user.email, key: const Key('detail_email')),
            ],
          ),
        ),
      ),
    );
  }
}
