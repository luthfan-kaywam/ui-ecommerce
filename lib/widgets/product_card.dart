import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/tilt_card.dart';
import '../core/widgets/gradient_text.dart';
import '../core/widgets/glassmorphism_card.dart';
import 'custom_image.dart';
import 'favorite_button.dart';
import 'animated_add_to_cart_button.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onCartTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onCartTap,
  });

  void _showQuickViewModal(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return GlassmorphismCard(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          blur: 24,
          backgroundColor: AppTheme.surface.withValues(alpha: 0.92),
          borderWidth: 1.5,
          borderGradient: AppTheme.primaryGradient,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomImage(
                      imagePath: product.imagePath,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.title,
                          style: AppTheme.headingBold(
                            fontSize: 18,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        GradientText(
                          "\$${product.discountedPrice.toStringAsFixed(2)}",
                          style: AppTheme.priceBold(fontSize: 20),
                          gradient: AppTheme.priceGradient,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                product.description,
                style: AppTheme.bodyRegular(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    if (onCartTap != null) {
                      onCartTap!();
                    }
                  },
                  icon: const Icon(Icons.add_shopping_cart_rounded),
                  label: const Text('Tambah ke Keranjang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TiltCard(
      onTap: onTap ??
          () {
            Navigator.pushNamed(context, "itemsPage");
          },
      onLongPress: () => _showQuickViewModal(context),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.cardGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          border: Border.all(
            color: const Color(0xFF818CF8).withValues(alpha: 0.12),
            width: 1.0,
          ),
          boxShadow: AppTheme.level1Shadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Image Area with Discount Badge & Heart Overlay ───────
              Expanded(
                child: Stack(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Hero(
                        tag: "product_image_${product.id}",
                        child: CustomImage(
                          imagePath: product.imagePath,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Discount Pill (Top-Left)
                    if (product.discountPercentage > 0)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: AppTheme.discountGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF472B6)
                                    .withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            "-${product.discountPercentage.toInt()}%",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    // Wishlist Heart Button (Top-Right Frosted Glass Circle)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: FavoriteButton(
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── 2. Content Area ─────────────────────────────────────────
              // Product Name (Plus Jakarta Sans SemiBold 13px)
              Text(
                product.title,
                style: AppTheme.headingSemiBold(
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 2),

              // Description (Inter Regular 11px, #64748B)
              Text(
                product.description,
                style: AppTheme.bodyRegular(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Rating Row (Stars + 4.8 + (128))
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                  const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                  const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                  const SizedBox(width: 4),
                  Text(
                    '4.8',
                    style: AppTheme.bodyMedium(
                      fontSize: 11,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '(128)',
                    style: AppTheme.bodyRegular(
                      fontSize: 10,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Price Row + Add to Cart Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.discountPercentage > 0)
                          Text(
                            "\$${product.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.textMuted,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppTheme.textMuted,
                            ),
                          ),
                        GradientText(
                          "\$${product.discountedPrice.toStringAsFixed(2)}",
                          style: AppTheme.priceBold(fontSize: 15),
                          gradient: AppTheme.priceGradient,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Gradient 36x36 Add to Cart Button
                  AnimatedAddToCartButton(
                    product: product,
                    onCartTap: onCartTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
