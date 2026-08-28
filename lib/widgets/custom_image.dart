import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_theme.dart';

class ShimmerBox extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);
    return Shimmer.fromColors(
      baseColor: AppTheme.surface2,
      highlightColor: const Color(0xFF3B3663),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: radius,
        ),
      ),
    );
  }
}

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
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  bool get _isNetwork =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(12);

    Widget fallbackErrorWidget = Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: effectiveRadius,
      ),
      child: Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 32,
          color: AppTheme.textMuted,
        ),
      ),
    );

    if (_isNetwork) {
      return ClipRRect(
        borderRadius: effectiveRadius,
        child: CachedNetworkImage(
          imageUrl: imagePath,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => ShimmerBox(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            borderRadius: effectiveRadius,
          ),
          errorWidget: (context, url, error) => fallbackErrorWidget,
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
        errorBuilder: (context, error, stackTrace) => fallbackErrorWidget,
      ),
    );
  }
}
