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
      title: 'User Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F766E),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const UserListScreen(),
    );
  }
}
