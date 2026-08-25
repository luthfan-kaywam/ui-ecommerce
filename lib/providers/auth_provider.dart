import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _userEmail = 'abusetiawan@example.com';
  String _userName = 'Abu Setiawan';

  bool get isAuthenticated => _isAuthenticated;
  String get userEmail => _userEmail;
  String get userName => _userName;

  void login(String email, String password) {
    _isAuthenticated = true;
    _userEmail = email.isNotEmpty ? email : 'abusetiawan@example.com';
    // If email has username part, derive a nice name if needed
    if (email.contains('@')) {
      final namePart = email.split('@').first;
      _userName = namePart[0].toUpperCase() + namePart.substring(1);
    } else {
      _userName = 'Abu Setiawan';
    }
    notifyListeners();
  }

  void updateProfile({required String name, required String email}) {
    if (name.trim().isNotEmpty) {
      _userName = name.trim();
    }
    if (email.trim().isNotEmpty) {
      _userEmail = email.trim();
    }
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _userEmail = '';
    _userName = '';
    notifyListeners();
  }
}
