import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/app_state_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/gradient_text.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({super.key});

  Widget _buildFrostedCircleButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.0,
              ),
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.background.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF818CF8).withValues(alpha: 0.15),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          _buildFrostedCircleButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppTheme.textPrimary,
            ),
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
            },
          ),

          const SizedBox(width: 14),

          // "Cart" in Gradient Text
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              GradientText(
                'Keranjang',
                style: AppTheme.displayBold(
                  fontSize: 22,
                  letterSpacing: -0.3,
                ),
                gradient: AppTheme.primaryGradient,
              ),
            ],
          ),

          const Spacer(),

          // 3-dot Menu as Frosted Glass Circle
          PopupMenuButton<String>(
            color: AppTheme.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: const Color(0xFF818CF8).withValues(alpha: 0.2),
              ),
            ),
            icon: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1.0,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            onSelected: (value) {
              if (value == 'Clear Cart') {
                context.cart.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Keranjang telah dikosongkan'),
                    backgroundColor: AppTheme.surface2,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Menu "$value" dipilih'),
                    backgroundColor: AppTheme.surface2,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Clear Cart',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, color: AppTheme.error),
                    SizedBox(width: 10),
                    Text('Kosongkan Keranjang',
                        style: TextStyle(color: AppTheme.error)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Share',
                child: Row(
                  children: [
                    Icon(Icons.share_rounded, color: AppTheme.accentGlow),
                    SizedBox(width: 10),
                    Text('Bagikan Keranjang',
                        style: TextStyle(color: AppTheme.textPrimary)),
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
