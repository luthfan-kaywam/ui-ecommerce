import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'gradient_text.dart';
import '../../providers/app_state_provider.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final bool isVisible;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.isVisible = true,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _lastTappedIndex = -1;

  void _handleTap(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _lastTappedIndex = index;
    });
    widget.onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.cart.totalItemCount;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const double barHeight = 70.0;
    final totalHeight = barHeight + bottomPadding;

    final bgColor = isDark
        ? const Color(0xFF100E20).withValues(alpha: 0.88)
        : Colors.white.withValues(alpha: 0.88);

    final glowColor = isDark
        ? AppColors.accent.withValues(alpha: 0.25)
        : const Color(0xFF6366F1).withValues(alpha: 0.35);

    return AnimatedSlide(
      offset: widget.isVisible ? Offset.zero : const Offset(0, 1.4),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        height: totalHeight + 28, // Extra room for the elevated FAB
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Glassmorphic Nav Bar with Organic Curved Notch
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: totalHeight,
              child: Stack(
                children: [
                  // Clipped Glassmorphic Surface
                  ClipPath(
                    clipper: const OrganicCurvedNotchClipper(
                      notchRadius: 36,
                      notchDepth: 28,
                      cornerRadius: 22,
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        height: totalHeight,
                        color: bgColor,
                      ),
                    ),
                  ),

                  // Glowing Border along the Curved Notch Path
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, totalHeight),
                    painter: CurvedNotchBorderPainter(
                      glowColor: glowColor,
                      notchRadius: 36,
                      notchDepth: 28,
                      cornerRadius: 22,
                    ),
                  ),

                  // Navigation Action Items Row
                  Container(
                    height: barHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Home Tab (Beranda)
                        _buildNavItem(
                          index: 0,
                          icon: Icons.home_rounded,
                          label: 'Beranda',
                          isActive: widget.currentIndex == 0,
                          isDark: isDark,
                        ),

                        // Center Spacer for Notch and FAB
                        const SizedBox(width: 80),

                        // Profile Tab (Profil)
                        _buildNavItem(
                          index: 2,
                          icon: Icons.person_rounded,
                          label: 'Profil',
                          isActive: widget.currentIndex == 2,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Prominent Circular Floating Action Button (Cart FAB) in Notch Cutoff
            Positioned(
              bottom: totalHeight - 34,
              child: GestureDetector(
                onTap: () => _handleTap(1),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 1.0,
                    end: widget.currentIndex == 1 ? 1.06 : 1.0,
                  ),
                  duration: const Duration(milliseconds: 220),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Gradient Button Container with Glow BoxShadow
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF4F46E5),
                              Color(0xFF7C3AED),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4F46E5).withValues(alpha: 0.55),
                              blurRadius: 24,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),

                      // Animated Cart Badge Count
                      if (cartCount > 0)
                        Positioned(
                          top: -3,
                          right: -3,
                          child: AnimatedScale(
                            scale: cartCount > 0 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.gradientPink,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.pink.withValues(alpha: 0.6),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$cartCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
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
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isDark,
  }) {
    final inactiveColor = const Color(0xFF94A3B8);
    final isTapped = _lastTappedIndex == index;

    return GestureDetector(
      onTap: () => _handleTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isTapped && isActive ? 1.0 : (isActive ? 1.04 : 0.94),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: SizedBox(
          width: 68,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                width: 44,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: isActive
                      ? (isDark
                          ? AppColors.gradientPrimary
                          : const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                            ))
                      : null,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                            blurRadius: 14,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 22,
                    color: isActive ? Colors.white : inactiveColor,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.display(
                  10,
                  w: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? (isDark ? AppColors.accent : const Color(0xFF6366F1))
                      : inactiveColor,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Organic Curved Notch Custom Clipper ─────────────────────────────────────
class OrganicCurvedNotchClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchDepth;
  final double cornerRadius;

  const OrganicCurvedNotchClipper({
    this.notchRadius = 36.0,
    this.notchDepth = 28.0,
    this.cornerRadius = 22.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final r = notchRadius;
    final d = notchDepth;

    path.moveTo(0, 0);

    // Left straight line to start of notch transition
    path.lineTo(centerX - r - 20, 0);

    // Smooth organic Bezier curve into the notch cutoff
    path.cubicTo(
      centerX - r - 8, 0,
      centerX - r, d * 0.35,
      centerX - r + 8, d * 0.8,
    );
    path.cubicTo(
      centerX - r + 16, d,
      centerX - 18, d,
      centerX, d,
    );
    path.cubicTo(
      centerX + 18, d,
      centerX + r - 16, d,
      centerX + r - 8, d * 0.8,
    );
    path.cubicTo(
      centerX + r, d * 0.35,
      centerX + r + 8, 0,
      centerX + r + 20, 0,
    );

    // Right straight line to top right edge
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant OrganicCurvedNotchClipper oldClipper) {
    return oldClipper.notchRadius != notchRadius ||
        oldClipper.notchDepth != notchDepth ||
        oldClipper.cornerRadius != cornerRadius;
  }
}

// ── Glowing Border Custom Painter ───────────────────────────────────────────
class CurvedNotchBorderPainter extends CustomPainter {
  final Color glowColor;
  final double notchRadius;
  final double notchDepth;
  final double cornerRadius;

  CurvedNotchBorderPainter({
    required this.glowColor,
    this.notchRadius = 36.0,
    this.notchDepth = 28.0,
    this.cornerRadius = 22.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final r = notchRadius;
    final d = notchDepth;

    final borderPath = Path();
    borderPath.moveTo(0, 0);
    borderPath.lineTo(centerX - r - 20, 0);

    borderPath.cubicTo(
      centerX - r - 8, 0,
      centerX - r, d * 0.35,
      centerX - r + 8, d * 0.8,
    );
    borderPath.cubicTo(
      centerX - r + 16, d,
      centerX - 18, d,
      centerX, d,
    );
    borderPath.cubicTo(
      centerX + 18, d,
      centerX + r - 16, d,
      centerX + r - 8, d * 0.8,
    );
    borderPath.cubicTo(
      centerX + r, d * 0.35,
      centerX + r + 8, 0,
      centerX + r + 20, 0,
    );
    borderPath.lineTo(size.width, 0);

    final paint = Paint()
      ..color = glowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawPath(borderPath, paint);
  }

  @override
  bool shouldRepaint(covariant CurvedNotchBorderPainter oldDelegate) {
    return oldDelegate.glowColor != glowColor ||
        oldDelegate.notchRadius != notchRadius ||
        oldDelegate.notchDepth != notchDepth;
  }
}
