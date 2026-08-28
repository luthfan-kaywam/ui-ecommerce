import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/aurora_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_text.dart';
import '../../models/cart_item_model.dart';
import '../../providers/app_state_provider.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onStartShopping;

  const CartScreen({super.key, this.onStartShopping});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  bool _isCouponExpanded = false;
  final TextEditingController _couponController = TextEditingController();
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _couponController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    HapticFeedback.lightImpact();
    final code = _couponController.text.trim();
    if (code.isNotEmpty) {
      final success = context.cart.applyCoupon(code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Kupon "$code" berhasil diterapkan! Diskon 10%'
                : 'Kode kupon tidak valid.',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _handleCheckout() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pesanan berhasil diproses! Terima kasih.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.cart;
    final items = cart.items;
    final totalCount = cart.totalItemCount;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Aurora
          const Positioned.fill(
            child: AuroraBackground(),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── CUSTOM APPBAR ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            widget.onStartShopping?.call();
                          }
                        },
                        child: GlassCard(
                          width: 40,
                          height: 40,
                          borderRadius: 20,
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: AppColors.textPrimaryOf(context),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      GradientText(
                        'My Cart',
                        style: AppTextStyles.display(22, w: FontWeight.w800),
                        gradient: AppColors.gradientPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$totalCount items',
                        style: AppTextStyles.body(13).copyWith(
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── CART ITEMS LIST ────────────────────────────────────────
                Expanded(
                  child: items.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          itemCount: items.length + 1, // items + coupon row
                          itemBuilder: (context, index) {
                            if (index == items.length) {
                              return _buildCouponSection();
                            }
                            final cartItem = items[index];
                            return CartItemTile(
                              key: ValueKey(cartItem.product.id),
                              item: cartItem,
                              index: index,
                            );
                          },
                        ),
                ),

                // ── CHECKOUT FOOTER ────────────────────────────────────────
                if (items.isNotEmpty) _buildCheckoutFooter(cart),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface2Of(context),
              border: Border.all(
                color: AppColors.accentOf(context).withValues(alpha: 0.2),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Keranjang Belanja Kosong',
            style: AppTextStyles.display(18, w: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Temukan produk terbaik dan tambahkan ke sini!',
            style: AppTextStyles.body(13).copyWith(
              color: AppColors.textSecondaryOf(context),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onStartShopping?.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.gradientPrimary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Text(
                'Mulai Belanja',
                style: AppTextStyles.display(14, w: FontWeight.w700).copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Coupon Row (Expandable) ───────────────────────────────────────────────
  Widget _buildCouponSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context).withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.accentOf(context).withValues(alpha: 0.16),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _isCouponExpanded = !_isCouponExpanded;
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.gradientPrimary,
                    ),
                    child: const Icon(
                      Icons.local_offer_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '+ Add Coupon Code',
                    style: AppTextStyles.body(14, w: FontWeight.w600).copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isCouponExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.accent,
                  ),
                ],
              ),
            ),
            if (_isCouponExpanded) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surface2Of(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.accentOf(context).withValues(alpha: 0.2),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _couponController,
                        style: AppTextStyles.body(13),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukkan kode kupon...',
                          hintStyle: AppTextStyles.body(13).copyWith(
                            color: AppColors.textSecondaryOf(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _applyCoupon,
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Apply',
                          style: AppTextStyles.display(13, w: FontWeight.w700).copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Checkout Footer ───────────────────────────────────────────────────────
  Widget _buildCheckoutFooter(dynamic cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context).withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: AppColors.accentOf(context).withValues(alpha: 0.14),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: AppTextStyles.display(16, w: FontWeight.w600).copyWith(
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
              GradientText(
                '\$${cart.grandTotal.toStringAsFixed(2)}',
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
          const SizedBox(height: 14),
          Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: AppColors.gradientPrimary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.48),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _handleCheckout,
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

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Check Out',
                            style: AppTextStyles.display(16, w: FontWeight.w700).copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
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

// ── Staggered Animated Cart Item Tile ───────────────────────────────────────
class CartItemTile extends StatefulWidget {
  final CartItemModel item;
  final int index;

  const CartItemTile({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.cart;
    final product = widget.item.product;
    final qty = widget.item.quantity;
    final isSelected = widget.item.isSelected;

    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Dismissible(
          key: ValueKey(product.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            HapticFeedback.mediumImpact();
            cart.removeFromCart(product.id);
          },
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: AppColors.gradientPink,
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.surfaceOf(context).withValues(alpha: 0.88),
              border: Border.all(
                color: AppColors.accentOf(context).withValues(alpha: 0.12),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Custom Checkbox
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          cart.toggleItemSelection(product.id);
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: isSelected ? AppColors.gradientPrimary : null,
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: AppColors.accentOf(context).withValues(alpha: 0.35),
                                    width: 1.5,
                                  ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: CachedNetworkImage(
                            imageUrl: product.imagePath,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: AppColors.surface2,
                              highlightColor: AppColors.surfaceOf(context),
                              child: Container(color: AppColors.surface2),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.surface2,
                              child: Icon(
                                Icons.image_not_supported_rounded,
                                color: AppColors.textSecondaryOf(context),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Product Info & Stepper
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product.title,
                                    style: AppTextStyles.display(14, w: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    cart.removeFromCart(product.id);
                                  },
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.error.withValues(alpha: 0.1),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppColors.error,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            GradientText(
                              '\$${product.discountedPrice.toStringAsFixed(0)}',
                              style: AppTextStyles.display(14, w: FontWeight.w700),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.accent,
                                  AppColors.primaryLight,
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Quantity Stepper
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    cart.updateQuantity(product.id, qty - 1);
                                  },
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.surface2Of(context),
                                      border: Border.all(
                                        color: AppColors.accentOf(context).withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      size: 14,
                                      color: AppColors.textPrimaryOf(context),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 28,
                                  child: Center(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      transitionBuilder: (child, anim) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 0.5),
                                            end: Offset.zero,
                                          ).animate(anim),
                                          child: FadeTransition(
                                            opacity: anim,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        qty < 10 ? '0$qty' : '$qty',
                                        key: ValueKey(qty),
                                        style: AppTextStyles.display(14, w: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    cart.updateQuantity(product.id, qty + 1);
                                  },
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.gradientPrimary,
                                    ),
                                    child: const Icon(
                                      Icons.add_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
