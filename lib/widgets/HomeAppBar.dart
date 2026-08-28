import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/app_state_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/gradient_text.dart';

class HomeAppBar extends StatefulWidget {
  final VoidCallback? onCartTap;
  final double scrollOffset;

  const HomeAppBar({
    super.key,
    this.onCartTap,
    this.scrollOffset = 0.0,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  int _previousCartCount = -1;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.35, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_bounceController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentCount = context.cart.totalItemCount;
    if (_previousCartCount != -1 && currentCount != _previousCartCount) {
      _bounceController.forward(from: 0.0);
    }
    _previousCartCount = currentCount;
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

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
    final cartCount = context.cart.totalItemCount;
    final blurOpacity = (widget.scrollOffset / 100).clamp(0.0, 0.85);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurOpacity > 0 ? 20 : 0,
          sigmaY: blurOpacity > 0 ? 20 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.background.withValues(alpha: blurOpacity),
            border: Border(
              bottom: BorderSide(
                color: blurOpacity > 0.3
                    ? const Color(0xFF818CF8).withValues(alpha: 0.15)
                    : Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              // Hamburger Frosted 40x40 Circle
              _buildFrostedCircleButton(
                icon: const Icon(
                  Icons.sort_rounded,
                  size: 22,
                  color: AppTheme.textPrimary,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Menu navigasi dibuka'),
                      backgroundColor: AppTheme.surface2,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),

              const SizedBox(width: 12),

              // QiluthMart in Plus Jakarta Sans ExtraBold with Gradient ShaderMask
              GradientText(
                "QiluthMart",
                style: AppTheme.displayBold(
                  fontSize: 22,
                  letterSpacing: 0.2,
                ),
                gradient: AppTheme.primaryGradient,
              ),

              const Spacer(),

              // Cart Icon with Dynamic Bounce & Gradient Badge
              ScaleTransition(
                scale: _scaleAnimation,
                child: badges.Badge(
                  showBadge: cartCount > 0,
                  position: badges.BadgePosition.topEnd(top: -4, end: -4),
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: const Color(0xFFF472B6),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  badgeAnimation: const badges.BadgeAnimation.scale(
                    animationDuration: Duration(milliseconds: 300),
                  ),
                  badgeContent: Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: _buildFrostedCircleButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 20,
                      color: AppTheme.textPrimary,
                    ),
                    onTap: widget.onCartTap ??
                        () => Navigator.pushNamed(context, "/cart"),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Notification / Chat Icon with Badge
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: -4, end: -4),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: const Color(0xFF7C3AED),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                badgeContent: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _buildFrostedCircleButton(
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 19,
                    color: AppTheme.textPrimary,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/list_chat");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
