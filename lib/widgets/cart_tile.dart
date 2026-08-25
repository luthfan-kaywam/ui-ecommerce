import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../providers/app_state_provider.dart';
import 'custom_image.dart';

class CartTile extends StatelessWidget {
  final CartItemModel item;

  const CartTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.cart;
    final product = item.product;

    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.12),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Radio / Checkbox Selection
          Checkbox(
            value: item.isSelected,
            activeColor: const Color(0xFF4C53A5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (_) {
              cartProvider.toggleItemSelection(product.id);
            },
          ),

          // Product Thumbnail with CustomImage
          Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDECF2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomImage(
              imagePath: product.imagePath,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C53A5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${product.discountedPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C53A5),
                  ),
                ),
              ],
            ),
          ),

          // Quantity controls & Remove button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  cartProvider.removeFromCart(product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} dihapus dari keranjang'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
              ),
              Row(
                children: [
                  // Tactile Animated Minus Button
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: () {
                      cartProvider.updateQuantity(product.id, item.quantity - 1);
                    },
                  ),

                  // Animated Quantity Counter Number
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        item.quantity.toString().padLeft(2, '0'),
                        key: ValueKey<int>(item.quantity),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                    ),
                  ),

                  // Tactile Animated Plus Button
                  _QtyButton(
                    icon: Icons.add,
                    onTap: () {
                      cartProvider.updateQuantity(product.id, item.quantity + 1);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_QtyButton> createState() => _QtyButtonState();
}

class _QtyButtonState extends State<_QtyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.25),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: 16,
            color: const Color(0xFF4C53A5),
          ),
        ),
      ),
    );
  }
}
