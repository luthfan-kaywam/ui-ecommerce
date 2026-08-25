import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
            },
            child: const Icon(
              Icons.arrow_back,
              size: 28,
              color: Color(0xFF4C53A5),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFF4C53A5),
                  size: 26,
                ),
                SizedBox(width: 8),
                Text(
                  'Cart',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C53A5),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              size: 28,
              color: Color(0xFF4C53A5),
            ),
            onSelected: (value) {
              if (value == 'Clear Cart') {
                context.cart.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Keranjang telah dikosongkan'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Menu "$value" dipilih'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Clear Cart',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Clear Cart'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Color(0xFF4C53A5)),
                    SizedBox(width: 10),
                    Text('Share Cart'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
