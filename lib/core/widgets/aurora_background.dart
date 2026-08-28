import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AuroraBackground extends StatefulWidget {
  final Widget? child;

  const AuroraBackground({super.key, this.child});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _controller3;

  late final Animation<Offset> _animation1;
  late final Animation<Offset> _animation2;
  late final Animation<Offset> _animation3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 13),
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 17),
    )..repeat(reverse: true);

    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 11),
    )..repeat(reverse: true);

    _animation1 = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(22, -38),
    ).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );

    _animation2 = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-32, 28),
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _animation3 = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(16, 35),
    ).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  Widget _buildBlob({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final opacityFactor = isDark ? 1.0 : 0.45;

    return Stack(
      children: [
        // Blob 1
        Positioned(
          top: -90,
          left: -80,
          child: AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation1.value,
                child: child,
              );
            },
            child: _buildBlob(
              size: 340,
              color: AppColors.primary.withValues(alpha: 0.28 * opacityFactor),
            ),
          ),
        ),

        // Blob 2
        Positioned(
          top: screenHeight * 0.22,
          right: -100,
          child: AnimatedBuilder(
            animation: _animation2,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation2.value,
                child: child,
              );
            },
            child: _buildBlob(
              size: 400,
              color: AppColors.primaryLight.withValues(alpha: 0.20 * opacityFactor),
            ),
          ),
        ),

        // Blob 3
        Positioned(
          bottom: screenHeight * 0.36,
          left: -60,
          child: AnimatedBuilder(
            animation: _animation3,
            builder: (context, child) {
              return Transform.translate(
                offset: _animation3.value,
                child: child,
              );
            },
            child: _buildBlob(
              size: 300,
              color: AppColors.primary.withValues(alpha: 0.16 * opacityFactor),
            ),
          ),
        ),

        // Blob 4 (Static or subtle ambient)
        Positioned(
          bottom: -60,
          right: -40,
          child: _buildBlob(
            size: 280,
            color: AppColors.pink.withValues(alpha: 0.18 * opacityFactor),
          ),
        ),

        if (widget.child != null) widget.child!,
      ],
    );
  }
}
