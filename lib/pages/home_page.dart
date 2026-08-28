import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_screen.dart';

export '../features/dashboard/dashboard_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}
