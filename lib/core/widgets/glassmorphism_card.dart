import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class GlassmorphismCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final Color? backgroundColor;
  final Gradient? borderGradient;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enablePressScale;

  const GlassmorphismCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 20.0,
    this.backgroundColor,
    this.borderGradient,
    this.borderWidth = 1.2,
    this.shadows,
    this.onTap,
    this.onLongPress,
    this.enablePressScale = true,
  });

  @override
  State<GlassmorphismCard> createState() => _GlassmorphismCardState();
}

class _GlassmorphismCardState extends State<GlassmorphismCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap != null && widget.enablePressScale) {
      _scaleController.forward();
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onTap != null && widget.enablePressScale) {
      _scaleController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null && widget.enablePressScale) {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppTheme.cardRadius;
    final bg = widget.backgroundColor ??
        AppTheme.surface.withValues(alpha: 0.65);
    final borderGrad = widget.borderGradient ??
        LinearGradient(
          colors: [
            const Color(0xFF818CF8).withValues(alpha: 0.35),
            const Color(0xFFC084FC).withValues(alpha: 0.15),
            const Color(0xFF4F46E5).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    Widget content = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: widget.shadows ?? AppTheme.level1Shadow,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blur,
            sigmaY: widget.blur,
          ),
          child: CustomPaint(
            painter: _GradientBorderPainter(
              borderRadius: radius,
              borderWidth: widget.borderWidth,
              gradient: borderGrad,
            ),
            child: Container(
              padding: widget.padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: radius,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (widget.onTap != null || widget.onLongPress != null) {
      content = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap?.call();
        },
        onLongPress: widget.onLongPress,
        behavior: HitTestBehavior.opaque,
        child: widget.enablePressScale
            ? ScaleTransition(
                scale: _scaleAnimation,
                child: content,
              )
            : content,
      );
    }

    return content;
  }
}

class _GradientBorderPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final double borderWidth;
  final Gradient gradient;

  _GradientBorderPainter({
    required this.borderRadius,
    required this.borderWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderWidth <= 0) return;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius.toRRect(rect);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.gradient != gradient;
  }
}
