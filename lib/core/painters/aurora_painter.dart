import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuroraPainter extends CustomPainter {
  final double animationValue;
  final double scrollOffset;
  final bool showGrid;

  AuroraPainter({
    required this.animationValue,
    this.scrollOffset = 0.0,
    this.showGrid = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Deep Space Background
    final bgPaint = Paint()..color = AppTheme.background;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Draw Subtle Grid Pattern (Diagonal / Mesh)
    if (showGrid) {
      final gridPaint = Paint()
        ..color = const Color(0xFF818CF8).withValues(alpha: 0.035)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      const spacing = 40.0;
      for (double x = -size.height; x < size.width + size.height; x += spacing) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x + size.height, size.height),
          gridPaint,
        );
      }
      for (double x = 0; x < size.width + size.height * 2; x += spacing) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x - size.height, size.height),
          gridPaint,
        );
      }
    }

    // 3. Draw Floating Aurora Orbs with radial gradients & translateY oscillation
    final parallaxShift = scrollOffset * 0.3;
    final t = animationValue * 2 * math.pi;

    final orbs = [
      // Top-Left Orb
      _Orb(
        center: Offset(
          size.width * 0.15 + math.sin(t) * 20,
          size.height * 0.18 + math.cos(t) * 30 - parallaxShift,
        ),
        radius: 170,
        colors: [
          const Color(0xFF4F46E5).withValues(alpha: 0.25),
          const Color(0xFF7C3AED).withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ),
      // Top-Right Orb
      _Orb(
        center: Offset(
          size.width * 0.85 + math.cos(t) * 25,
          size.height * 0.25 + math.sin(t) * 28 - parallaxShift,
        ),
        radius: 200,
        colors: [
          const Color(0xFF7C3AED).withValues(alpha: 0.22),
          const Color(0xFFA855F7).withValues(alpha: 0.10),
          Colors.transparent,
        ],
      ),
      // Center Glow
      _Orb(
        center: Offset(
          size.width * 0.5 + math.sin(t + 1.5) * 30,
          size.height * 0.55 + math.cos(t + 1.5) * 32 - parallaxShift,
        ),
        radius: 180,
        colors: [
          const Color(0xFF818CF8).withValues(alpha: 0.18),
          const Color(0xFF4F46E5).withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ),
      // Bottom-Left Orb
      _Orb(
        center: Offset(
          size.width * 0.2 + math.cos(t + 2.0) * 22,
          size.height * 0.82 + math.sin(t + 2.0) * 30 - parallaxShift,
        ),
        radius: 210,
        colors: [
          const Color(0xFF7C3AED).withValues(alpha: 0.20),
          const Color(0xFF312E81).withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ),
      // Bottom-Right Highlight Orb
      _Orb(
        center: Offset(
          size.width * 0.8 + math.sin(t + 3.0) * 20,
          size.height * 0.90 + math.cos(t + 3.0) * 26 - parallaxShift,
        ),
        radius: 160,
        colors: [
          const Color(0xFFF472B6).withValues(alpha: 0.12),
          const Color(0xFF4F46E5).withValues(alpha: 0.06),
          Colors.transparent,
        ],
      ),
    ];

    for (final orb in orbs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: orb.colors,
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: orb.center, radius: orb.radius));
      canvas.drawCircle(orb.center, orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(AuroraPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.showGrid != showGrid;
  }
}

class _Orb {
  final Offset center;
  final double radius;
  final List<Color> colors;

  _Orb({
    required this.center,
    required this.radius,
    required this.colors,
  });
}

class AuroraBackground extends StatefulWidget {
  final Widget? child;
  final ScrollController? scrollController;
  final bool showGrid;

  const AuroraBackground({
    super.key,
    this.child,
    this.scrollController,
    this.showGrid = true,
  });

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(AuroraBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (widget.scrollController != null && mounted) {
      setState(() {
        _scrollOffset = widget.scrollController!.offset;
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: AuroraPainter(
                animationValue: _controller.value,
                scrollOffset: _scrollOffset,
                showGrid: widget.showGrid,
              ),
              size: Size.infinite,
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}
