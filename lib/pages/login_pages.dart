import 'package:flutter/material.dart';
import '../features/auth/login_screen.dart';

export '../features/auth/login_screen.dart';

class LoginPages extends StatelessWidget {
  const LoginPages({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}