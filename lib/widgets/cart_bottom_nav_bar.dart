import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/app_state_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/gradient_text.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF818CF8).withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pembayaran:',
                      style: AppTheme.headingBold(
                        fontSize: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    GradientText(
                      "\$${totalAmount.toStringAsFixed(2)}",
                      style: AppTheme.priceBold(
                        fontSize: 24,
                      ),
                      gradient: AppTheme.priceGradient,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // "Check Out" Button with Shimmer Sweep Overlay
                GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed = true),
                  onTapUp: (_) => setState(() => _isPressed = false),
                  onTapCancel: () => setState(() => _isPressed = false),
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    if (cart.items.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Keranjang Anda masih kosong!'),
                          backgroundColor: AppTheme.surface2,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    CheckoutModal.show(context);
                  },
                  child: AnimatedScale(
                    scale: _isPressed ? 0.97 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient135,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusButton),
                        boxShadow: AppTheme.glowShadow,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Shimmer Highlight Sweep
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusButton),
                              child: Shimmer.fromColors(
                                baseColor: Colors.transparent,
                                highlightColor:
                                    Colors.white.withValues(alpha: 0.25),
                                period: const Duration(seconds: 2),
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          // Text & Icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Check Out',
                                style: AppTheme.headingBold(
                                  fontSize: 17,
                                  color: Colors.white,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
