import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import '../providers/app_state_provider.dart';
import '../core/theme/app_theme.dart';

class AnimatedAddToCartButton extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onCartTap;

  const AnimatedAddToCartButton({
    super.key,
    required this.product,
    this.onCartTap,
  });

  @override
  State<AnimatedAddToCartButton> createState() =>
      _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isSuccessState = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAddToCart() {
    HapticFeedback.mediumImpact();
    _controller.forward().then((_) {
      _controller.reverse();
    });

    setState(() {
      _isSuccessState = true;
    });

    // Add product to CartProvider
    context.cart.addToCart(widget.product);

    // Show dark floating SnackBar with View Cart action
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF34D399),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${widget.product.title} masuk ke Keranjang!',
                style: AppTheme.bodyMedium(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Lihat',
          textColor: const Color(0xFF818CF8),
          onPressed: () {
            if (widget.onCartTap != null) {
              widget.onCartTap!();
            } else {
              Navigator.pushNamed(context, "/cart");
            }
          },
        ),
        backgroundColor: AppTheme.surface2,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFF818CF8).withValues(alpha: 0.3),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSuccessState = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _onAddToCart();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _isSuccessState
                ? const LinearGradient(
                    colors: [Color(0xFF059669), Color(0xFF34D399)],
                  )
                : AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: (_isSuccessState
                        ? const Color(0xFF34D399)
                        : const Color(0xFF818CF8))
                    .withValues(alpha: _isPressed ? 0.3 : 0.6),
                blurRadius: _isPressed ? 6 : 14,
                spreadRadius: _isPressed ? 0 : 1,
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: _isSuccessState
                  ? const Icon(
                      Icons.check_rounded,
                      key: ValueKey('check'),
                      size: 18,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.add_shopping_cart_rounded,
                      key: ValueKey('cart'),
                      size: 18,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
