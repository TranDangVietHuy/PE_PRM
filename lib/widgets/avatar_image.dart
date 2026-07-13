import 'package:flutter/material.dart';

const defaultAvatarPath = 'assets/default_avatar.jpg';

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    super.key,
    this.avatar,
    this.radius = 24,
  });

  final String? avatar;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final value = avatar?.trim() ?? '';
    // final shouldShowDefaultAsset = value.isEmpty || value == defaultAvatarPath;

    return CircleAvatar(
        radius: radius,
        child: ClipOval(
          child: Image.asset(
            value.isEmpty ? defaultAvatarPath : value,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _AvatarPlaceholder(radius: radius),
          ),
        ));
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    // Không tải network/asset tuỳ ý trong widget test; avatar string vẫn lưu trong model.
    return Container(
      width: radius * 2,
      height: radius * 2,
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: radius,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
