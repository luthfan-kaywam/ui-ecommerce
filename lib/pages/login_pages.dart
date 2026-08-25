import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../widgets/custom_text_field.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.auth;
      authProvider.login(_emailController.text.trim(), _passwordController.text);

      // Clear navigation stack and redirect to dashboard cleanly
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    }
  }

  // Header Widget
  Widget _buildHeader() {
    return const Column(
      children: [
        Icon(
          Icons.eco_rounded,
          size: 65,
          color: Color(0xFF653993),
        ),
        SizedBox(height: 16),
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please sign in to continue shopping',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF8E8E93),
          ),
        ),
      ],
    );
  }

  // Email Field using CustomTextField
  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      hintText: 'Email',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email tidak boleh kosong';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }

  // Password Field using CustomTextField
  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      hintText: 'Password',
      prefixIcon: Icons.lock_outline,
      isPassword: true,
      obscureText: _obscurePassword,
      onToggleVisibility: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        if (value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }

  // Elevated Login Button
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF653993),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Forgot Password Link
  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fitur Reset Password akan dikirimkan ke email Anda.'),
            backgroundColor: Color(0xFF653993),
          ),
        );
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: Color(0xFF653993),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Signup Link
  Widget _buildSignupLink() {
    return TextButton(
      onPressed: () {
        _handleLogin(); // Auto login for seamless experience or redirect
      },
      child: const Text(
        "Don't have an account? Sign Up",
        style: TextStyle(
          color: Color(0xFF653993),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6FD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 36),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 28),
                  _buildLoginButton(),
                  const SizedBox(height: 16),
                  _buildForgotPasswordLink(),
                  const SizedBox(height: 16),
                  _buildSignupLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}