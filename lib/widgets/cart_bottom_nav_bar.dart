import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import 'checkout_modal.dart';

class CartBottomNavBar extends StatefulWidget {
  const CartBottomNavBar({super.key});

  @override
  State<CartBottomNavBar> createState() => _CartBottomNavBarState();
}

class _CartBottomNavBarState extends State<CartBottomNavBar> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.cart;
    final totalAmount = cart.grandTotal;

    return BottomAppBar(
      height: 130,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    color: Color(0xFF4C53A5),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color(0xFF4C53A5),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: () {
                if (cart.items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Keranjang Anda masih kosong!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                CheckoutModal.show(context);
              },
              child: AnimatedScale(
                scale: _isPressed ? 0.96 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  alignment: Alignment.center,
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C53A5),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4C53A5).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Check Out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
