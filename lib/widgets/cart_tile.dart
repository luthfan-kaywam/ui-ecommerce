import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cart_item_model.dart';
import '../providers/app_state_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/gradient_text.dart';
import 'custom_image.dart';

class CartTile extends StatefulWidget {
  final CartItemModel item;
  final int index;

  const CartTile({
    super.key,
    required this.item,
    this.index = 0,
  });

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.25, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeIn,
      ),
    );

    final delay = (widget.index * 60).clamp(0, 360);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.cart;
    final product = widget.item.product;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dismissible(
          key: ValueKey('cart_item_${product.id}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            cartProvider.removeFromCart(product.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product.title} dihapus dari keranjang'),
                duration: const Duration(seconds: 2),
                backgroundColor: AppTheme.surface2,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          background: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.only(right: 24),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
                SizedBox(width: 8),
                Text(
                  'Hapus',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.surface2.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              border: Border.all(
                color: const Color(0xFF818CF8).withValues(alpha: 0.15),
                width: 1.0,
              ),
              boxShadow: AppTheme.level1Shadow,
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Custom Rounded Checkbox
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    cartProvider.toggleItemSelection(product.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: widget.item.isSelected
                          ? AppTheme.primaryGradient
                          : null,
                      color: widget.item.isSelected
                          ? null
                          : Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.item.isSelected
                            ? Colors.transparent
                            : const Color(0xFF818CF8).withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: widget.item.isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF4F46E5)
                                    .withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ]
                          : null,
                    ),
                    child: widget.item.isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 12),

                // Product Image 70x70
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CustomImage(
                    imagePath: product.imagePath,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                // Info (Title + Price)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.title,
                        style: AppTheme.headingSemiBold(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      GradientText(
                        "\$${product.discountedPrice.toStringAsFixed(2)}",
                        style: AppTheme.priceBold(fontSize: 15),
                        gradient: AppTheme.priceGradient,
                      ),
                    ],
                  ),
                ),

                // Delete & Quantity Stepper
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Delete Frosted Circle (28x28)
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        cartProvider.removeFromCart(product.id);
                      },
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  AppTheme.error.withValues(alpha: 0.15),
                              border: Border.all(
                                color: AppTheme.error
                                    .withValues(alpha: 0.3),
                                width: 1.0,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: AppTheme.error,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Pill-Shaped Qty Stepper (-) [01] (+)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              const Color(0xFF818CF8).withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStepperBtn(
                            icon: Icons.remove_rounded,
                            onTap: () {
                              cartProvider.updateQuantity(
                                  product.id, widget.item.quantity - 1);
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.5),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: FadeTransition(
                                      opacity: animation, child: child),
                                );
                              },
                              child: Text(
                                widget.item.quantity
                                    .toString()
                                    .padLeft(2, '0'),
                                key: ValueKey<int>(widget.item.quantity),
                                style: AppTheme.priceBold(
                                  fontSize: 13,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          _buildStepperBtn(
                            icon: Icons.add_rounded,
                            onTap: () {
                              cartProvider.updateQuantity(
                                  product.id, widget.item.quantity + 1);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 14,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}
