import 'package:flutter/material.dart';

/// Reusable Shimmer loading placeholder widget.
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Color(0xFFEBEBF4),
                Color(0xFFF5F5FA),
                Color(0xFFEBEBF4),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Smart Image Widget supporting network & asset images with Shimmer loading
/// and clean fallback error card.
class CustomImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CustomImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
  });

  bool get _isNetwork =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(12);

    Widget fallbackErrorWidget = Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F8),
        borderRadius: effectiveRadius,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: (height != null && height! < 70) ? 24 : 36,
              color: const Color(0xFF4C53A5).withValues(alpha: 0.7),
            ),
            if (height == null || height! >= 90) ...[
              const SizedBox(height: 4),
              Text(
                'No Image',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (_isNetwork) {
      return ClipRRect(
        borderRadius: effectiveRadius,
        child: Image.network(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return ShimmerBox(
              width: width ?? double.infinity,
              height: height ?? double.infinity,
              borderRadius: effectiveRadius,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return fallbackErrorWidget;
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return fallbackErrorWidget;
        },
      ),
    );
  }
}
