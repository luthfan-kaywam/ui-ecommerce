import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../widgets/cart_app_bar.dart';
import '../widgets/cart_bottom_nav_bar.dart';
import '../widgets/cart_tile.dart';
import '../widgets/empty_state_widget.dart';

class CartPage extends StatefulWidget {
  final VoidCallback? onStartShopping;

  const CartPage({super.key, this.onStartShopping});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _showCouponField = false;
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final cart = context.cart;
    String code = _couponController.text.trim();
    if (code.isNotEmpty) {
      final success = cart.applyCoupon(code);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kupon "$code" berhasil diterapkan! Diskon 10%'),
            backgroundColor: const Color(0xFF4C53A5),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.cart;
    final cartItems = cart.items;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CartAppBar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 15),
                decoration: const BoxDecoration(
                  color: Color(0xFFEDECF2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: cartItems.isEmpty
                    ? Center(
                        child: EmptyStateWidget(
                          icon: Icons.shopping_cart_outlined,
                          title: 'Keranjang Belanja Kosong',
                          message:
                              'Belum ada produk di keranjang Anda. Jelajahi katalog dan temukan produk impian Anda!',
                          actionLabel: 'Mulai Belanja',
                          onAction: () {
                            if (widget.onStartShopping != null) {
                              widget.onStartShopping!();
                            } else {
                              Navigator.pushNamed(context, "/dashboard");
                            }
                          },
                        ),
                      )
                    : ListView(
                        children: [
                          // Cart Items List
                          ...cartItems.map((item) => CartTile(item: item)),

                          // Coupon Section
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.12),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _showCouponField = !_showCouponField;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4C53A5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          _showCouponField
                                              ? Icons.remove
                                              : Icons.add,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(
                                          "Add Coupon Code",
                                          style: TextStyle(
                                            color: Color(0xFF4C53A5),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (cart.discountPercent > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${cart.couponCode} (10% OFF)',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (_showCouponField)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _couponController,
                                            decoration: InputDecoration(
                                              hintText: "Masukkan kode kupon",
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 10,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF4C53A5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: _applyCoupon,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF4C53A5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 12),
                                          ),
                                          child: const Text(
                                            "Apply",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CartBottomNavBar(),
    );
  }
}
