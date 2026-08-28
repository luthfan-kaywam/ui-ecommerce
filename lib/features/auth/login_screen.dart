import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/aurora_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_text.dart';
import '../../providers/app_state_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController(text: 'qiwam@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _obscurePassword = true;
  bool _isButtonTapped = false;

  late final AnimationController _logoAnimController;
  late final Animation<double> _logoScaleAnim;

  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    // Logo entrance animation (scale 0.7 -> 1.0, elasticOut, 600ms)
    _logoAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimController,
        curve: Curves.elasticOut,
      ),
    );

    _logoAnimController.forward();

    // Shimmer sweep animation (2.8s loop)
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _emailFocus.addListener(() {
      setState(() => _isEmailFocused = _emailFocus.hasFocus);
    });

    _passwordFocus.addListener(() {
      setState(() => _isPasswordFocused = _passwordFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _logoAnimController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    HapticFeedback.lightImpact();
    setState(() => _isButtonTapped = true);
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) setState(() => _isButtonTapped = false);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!mounted) return;
    context.auth.login(
      email.isNotEmpty ? email : 'qiwam@gmail.com',
      password.isNotEmpty ? password : 'password123',
    );

    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient Aurora Background
          const Positioned.fill(
            child: AuroraBackground(),
          ),

          // Main Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── LOGO ───────────────────────────────────────────────
                    ScaleTransition(
                      scale: _logoScaleAnim,
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.gradientPrimary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.5),
                                  blurRadius: 28,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Q',
                                style: AppTextStyles.display(32, w: FontWeight.w800).copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GradientText(
                            'QiluthMart',
                            style: AppTextStyles.display(24, w: FontWeight.w800),
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.accent,
                                AppColors.primaryLight,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── TITLE ──────────────────────────────────────────────
                    Text(
                      'Welcome Back!',
                      style: AppTextStyles.display(30, w: FontWeight.w800).copyWith(
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Please sign in to continue shopping',
                      style: AppTextStyles.body(14).copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── FORM CARD ──────────────────────────────────────────
                    GlassCard(
                      borderRadius: 28,
                      bgColor: AppColors.surface.withOpacity(0.88),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email Field
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.surface2,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _isEmailFocused
                                    ? AppColors.accent
                                    : AppColors.accent.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: _isEmailFocused
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.28),
                                        blurRadius: 18,
                                      ),
                                    ]
                                  : [],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.mail_outline_rounded,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    style: AppTextStyles.body(14),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Email Address',
                                      hintStyle: AppTextStyles.body(14).copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Password Field
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.surface2,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _isPasswordFocused
                                    ? AppColors.accent
                                    : AppColors.accent.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: _isPasswordFocused
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.28),
                                        blurRadius: 18,
                                      ),
                                    ]
                                  : [],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lock_outline_rounded,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    obscureText: _obscurePassword,
                                    style: AppTextStyles.body(14),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Password',
                                      hintStyle: AppTextStyles.body(14).copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                              },
                              child: Text(
                                'Forgot Password?',
                                style: AppTextStyles.body(13, w: FontWeight.w600).copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Login Button with Shimmer & Scale animation
                          AnimatedScale(
                            scale: _isButtonTapped ? 0.96 : 1.0,
                            duration: const Duration(milliseconds: 150),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: AppColors.gradientPrimary,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.48),
                                    blurRadius: 24,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: _handleLogin,
                                  child: Stack(
                                    children: [
                                      // Shimmer Overlay
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: AnimatedBuilder(
                                            animation: _shimmerController,
                                            builder: (context, child) {
                                              final shimmerPos = _shimmerController.value;
                                              return ShaderMask(
                                                shaderCallback: (bounds) {
                                                  return LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    stops: [
                                                      (shimmerPos - 0.2).clamp(0.0, 1.0),
                                                      shimmerPos.clamp(0.0, 1.0),
                                                      (shimmerPos + 0.2).clamp(0.0, 1.0),
                                                    ],
                                                    colors: [
                                                      Colors.white.withOpacity(0.0),
                                                      Colors.white.withOpacity(0.3),
                                                      Colors.white.withOpacity(0.0),
                                                    ],
                                                  ).createShader(bounds);
                                                },
                                                blendMode: BlendMode.srcOver,
                                                child: Container(color: Colors.transparent),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      // Text
                                      Center(
                                        child: Text(
                                          'Login',
                                          style: AppTextStyles.display(16, w: FontWeight.w700).copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Social Login Divider
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'Or continue with',
                                  style: AppTextStyles.body(12).copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Social Login Buttons (Google / Facebook)
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => HapticFeedback.lightImpact(),
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface2,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.accent.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'G',
                                          style: AppTextStyles.display(16, w: FontWeight.w800).copyWith(
                                            color: AppColors.accent,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Google',
                                          style: AppTextStyles.body(13, w: FontWeight.w500).copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => HapticFeedback.lightImpact(),
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface2,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.accent.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'f',
                                          style: AppTextStyles.display(16, w: FontWeight.w800).copyWith(
                                            color: AppColors.accent,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Facebook',
                                          style: AppTextStyles.body(13, w: FontWeight.w500).copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign Up Link
                    GestureDetector(
                      onTap: () => HapticFeedback.lightImpact(),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.body(13).copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign Up',
                              style: AppTextStyles.body(13, w: FontWeight.w600).copyWith(
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
