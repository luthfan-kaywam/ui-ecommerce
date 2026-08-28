import 'package:flutter/material.dart';
import '../features/cart/cart_screen.dart';

export '../features/cart/cart_screen.dart';

class CartPage extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const CartPage({super.key, this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return CartScreen(onStartShopping: onStartShopping);
  }
}
