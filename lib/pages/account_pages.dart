import 'package:flutter/material.dart';
import '../features/profile/profile_screen.dart';

export '../features/profile/profile_screen.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}