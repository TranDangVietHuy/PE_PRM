import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/user_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: UserManagerApp()));
}

class UserManagerApp extends StatelessWidget {
  const UserManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UserListScreen(),
    );
  }
}
