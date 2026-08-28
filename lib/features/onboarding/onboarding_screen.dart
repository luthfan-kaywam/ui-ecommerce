import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/aurora_background.dart';
import '../../core/widgets/gradient_text.dart';

class OnboardingSlideModel {
  final String icon;
  final String badge;
  final String title;
  final String desc;
  final Color colorFrom;
  final Color colorTo;

  const OnboardingSlideModel({
    required this.icon,
    required this.badge,
    required this.title,
    required this.desc,
    required this.colorFrom,
    required this.colorTo,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // 3D Tilt & Float Controller
  late final AnimationController _tiltController;
  late final Animation<double> _tiltX;
  late final Animation<double> _tiltY;
  late final Animation<double> _floatY;

  // Orbit Controllers
  late final AnimationController _orbit1Controller;
  late final AnimationController _orbit2Controller;

  // CTA Shimmer Controller
  late final AnimationController _shimmerController;

  final List<OnboardingSlideModel> _slides = const [
    OnboardingSlideModel(
      icon: '🛍️',
      badge: 'Koleksi Lengkap',
      title: 'Selamat Datang di QiluthMart',
      desc: 'Pusat belanja online terpercaya dengan ribuan produk pilihan.',
      colorFrom: Color(0xFF4F46E5),
      colorTo: Color(0xFF7C3AED),
    ),
    OnboardingSlideModel(
      icon: '🏷️',
      badge: 'Hemat Setiap Hari',
      title: 'Promo & Diskon Melimpah',
      desc: 'Flash sale, voucher cashback, hingga promo gratis ongkir setiap hari.',
      colorFrom: Color(0xFF7C3AED),
      colorTo: Color(0xFFA855F7),
    ),
    OnboardingSlideModel(
      icon: '🚚',
      badge: 'Aman & Terpercaya',
      title: 'Pengiriman Super Cepat',
      desc: 'Pesanan sampai ke pintu rumahmu melalui kurir mitra terpercaya.',
      colorFrom: Color(0xFFA855F7),
      colorTo: Color(0xFFEC4899),
    ),
  ];

  @override
  void initState() {
    super.initState();

    // 7s Tilt & Float Animation
    _tiltController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    _tiltX = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _tiltController,
        curve: Curves.easeInOut,
      ),
    );

    // Use a slightly different curve/phase progression for tiltY
    _tiltY = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _tiltController,
        curve: const Interval(0.1, 0.9, curve: Curves.easeInOutSine),
      ),
    );

    _floatY = Tween<double>(begin: 0.0, end: -14.0).animate(
      CurvedAnimation(
        parent: _tiltController,
        curve: Curves.easeInOut,
      ),
    );

    // Orbit rings
    _orbit1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _orbit2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    // CTA Shimmer sweep
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tiltController.dispose();
    _orbit1Controller.dispose();
    _orbit2Controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onNext() {
    HapticFeedback.lightImpact();
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _onBack() {
    HapticFeedback.lightImpact();
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _navigateToLogin() {
    HapticFeedback.lightImpact();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final currentSlide = _slides[_currentIndex];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Ambient Aurora Background
          const Positioned.fill(
            child: AuroraBackground(),
          ),

          // 2. 8 Floating Staggered Star Particles
          ...List.generate(8, (index) {
            final leftPercent = [0.12, 0.85, 0.22, 0.78, 0.08, 0.90, 0.28, 0.68][index];
            final topPercent = [0.18, 0.24, 0.42, 0.52, 0.68, 0.72, 0.85, 0.88][index];
            final particleSize = [4.0, 5.0, 3.5, 6.0, 3.0, 5.5, 4.5, 3.8][index];
            final delayMs = index * 400;

            return Positioned(
              left: size.width * leftPercent,
              top: size.height * topPercent,
              child: ParticleWidget(
                size: particleSize,
                delayMs: delayMs,
                color: Colors.white.withOpacity(0.45 + (index % 3) * 0.15),
              ),
            );
          }),

          // 3. Main Content Layout
          SafeArea(
            child: Column(
              children: [
                // TopBar
                _buildTopBar(),

                // PageView for 3D Hero + Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 1),

                          // HERO 3D CARD
                          _buildHero3DCard(slide),

                          const Spacer(flex: 2),

                          // Animated Text Content
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28.0),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 450),
                              transitionBuilder: (child, anim) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.15, 0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: anim,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                  child: FadeTransition(
                                    opacity: anim,
                                    child: child,
                                  ),
                                );
                              },
                              child: _buildSlideContent(slide),
                            ),
                          ),

                          const Spacer(flex: 2),
                        ],
                      );
                    },
                  ),
                ),

                // Bottom Controls: Indicators + CTA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    children: [
                      // Page Indicators
                      _buildPageIndicators(currentSlide),

                      const SizedBox(height: 24),

                      // CTA Button with shimmer
                      _buildCTAButton(currentSlide),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TopBar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (hidden on slide 0)
          AnimatedOpacity(
            opacity: _currentIndex > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: _currentIndex == 0,
              child: GestureDetector(
                onTap: _onBack,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),

          // Skip button
          GestureDetector(
            onTap: _navigateToLogin,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Lewati',
                style: AppTextStyles.body(14, w: FontWeight.w600).copyWith(
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero 3D Card ──────────────────────────────────────────────────────────
  Widget _buildHero3DCard(OnboardingSlideModel slide) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orbit Ring 1 (5s rotate)
          AnimatedBuilder(
            animation: _orbit1Controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _orbit1Controller.value * 2 * math.pi,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: slide.colorFrom.withOpacity(0.35),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            },
          ),

          // Orbit Ring 2 (7s reverse rotate)
          AnimatedBuilder(
            animation: _orbit2Controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_orbit2Controller.value * 2 * math.pi,
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.pink.withOpacity(0.28),
                      width: 1.0,
                    ),
                  ),
                ),
              );
            },
          ),

          // Glow Blob bawah card
          Positioned(
            bottom: 20,
            child: Container(
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                color: slide.colorFrom.withOpacity(0.4),
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: slide.colorFrom.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          // 3D Tilted Floating Glass Card
          AnimatedBuilder(
            animation: _tiltController,
            builder: (context, child) {
              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(_tiltX.value * math.pi / 180)
                ..rotateY(_tiltY.value * math.pi / 180)
                ..translate(0.0, _floatY.value, 0.0);

              return Transform(
                alignment: Alignment.center,
                transform: matrix,
                child: Container(
                  width: 176,
                  height: 176,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.03),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: slide.colorFrom.withOpacity(0.45),
                        blurRadius: 64,
                        spreadRadius: -8,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.05),
                        blurRadius: 1,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0, -8),
                      child: Text(
                        slide.icon,
                        style: const TextStyle(
                          fontSize: 76,
                          fontFamilyFallback: ['Apple Color Emoji', 'Segoe UI Emoji', 'Noto Color Emoji'],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Slide Content: Badge, Title, Desc ─────────────────────────────────────
  Widget _buildSlideContent(OnboardingSlideModel slide) {
    return Column(
      key: ValueKey(slide.badge),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: slide.colorFrom.withOpacity(0.18),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: slide.colorFrom.withOpacity(0.45),
              width: 1,
            ),
          ),
          child: GradientText(
            slide.badge,
            style: AppTextStyles.display(13, w: FontWeight.w600),
            gradient: LinearGradient(
              colors: [slide.colorFrom, slide.colorTo],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Title
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.display(26, w: FontWeight.w800).copyWith(
            height: 1.25,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 12),

        // Desc
        Text(
          slide.desc,
          textAlign: TextAlign.center,
          style: AppTextStyles.body(14, w: FontWeight.w400).copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Page Indicators ───────────────────────────────────────────────────────
  Widget _buildPageIndicators(OnboardingSlideModel currentSlide) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_slides.length, (index) {
        final isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: isActive
                ? LinearGradient(
                    colors: [currentSlide.colorFrom, currentSlide.colorTo],
                  )
                : null,
            color: isActive ? null : Colors.white.withOpacity(0.22),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: currentSlide.colorFrom.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  // ── CTA Button ────────────────────────────────────────────────────────────
  Widget _buildCTAButton(OnboardingSlideModel currentSlide) {
    final isLast = _currentIndex == _slides.length - 1;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [currentSlide.colorFrom, currentSlide.colorTo],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: currentSlide.colorFrom.withOpacity(0.48),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _onNext,
          child: Stack(
            children: [
              // Shimmer Overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
                              Colors.white.withOpacity(0.28),
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

              // Button Content
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLast ? 'Mulai Sekarang' : 'Lanjutkan',
                      style: AppTextStyles.display(16, w: FontWeight.w700).copyWith(
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Particle Widget ─────────────────────────────────────────────────────────
class ParticleWidget extends StatefulWidget {
  final double size;
  final int delayMs;
  final Color color;

  const ParticleWidget({
    super.key,
    required this.size,
    required this.delayMs,
    required this.color,
  });

  @override
  State<ParticleWidget> createState() => _ParticleWidgetState();
}

class _ParticleWidgetState extends State<ParticleWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offsetAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _offsetAnim = Tween<double>(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offsetAnim.value),
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.6),
              blurRadius: widget.size * 1.5,
              spreadRadius: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
