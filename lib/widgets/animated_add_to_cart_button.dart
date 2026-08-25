import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../providers/app_state_provider.dart';

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
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
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
    _controller.forward().then((_) {
      _controller.reverse();
    });

    setState(() {
      _isSuccessState = true;
    });

    // Add product to CartProvider state
    context.cart.addToCart(widget.product);

    // Show floating SnackBar with View Cart action
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${widget.product.title} ditambahkan ke Keranjang!',
                style: const TextStyle(
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
          label: 'View Cart',
          textColor: const Color(0xFFFFD700), // Gold yellow for high visibility
          onPressed: () {
            if (widget.onCartTap != null) {
              widget.onCartTap!();
            } else {
              Navigator.pushNamed(context, "/cart");
            }
          },
        ),
        backgroundColor: const Color(0xFF4C53A5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
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
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _isSuccessState ? Colors.green : const Color(0xFF4C53A5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (_isSuccessState ? Colors.green : const Color(0xFF4C53A5))
                    .withValues(alpha: _isPressed ? 0.2 : 0.4),
                blurRadius: _isPressed ? 3 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: _isSuccessState
                ? const Icon(
                    Icons.check,
                    key: ValueKey('check'),
                    size: 18,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.add_shopping_cart,
                    key: ValueKey('cart'),
                    size: 18,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
