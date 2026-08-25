import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/app_state_provider.dart';

class HomeAppBar extends StatefulWidget {
  final VoidCallback? onCartTap;

  const HomeAppBar({super.key, this.onCartTap});

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
      duration: const Duration(milliseconds: 400),
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

  @override
  Widget build(BuildContext context) {
    final cartCount = context.cart.totalItemCount;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          const Icon(
            Icons.sort,
            size: 30,
            color: Color(0xFF4C53A5),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "EcoGlobal",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
          ),
          const Spacer(),

          // Cart Icon with Dynamic Bounce Badge
          InkWell(
            onTap: widget.onCartTap ?? () => Navigator.pushNamed(context, "/cart"),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: badges.Badge(
                showBadge: cartCount > 0,
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(6),
                ),
                badgeAnimation: const badges.BadgeAnimation.scale(
                  animationDuration: Duration(milliseconds: 300),
                ),
                badgeContent: Text(
                  '$cartCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 28,
                  color: Color(0xFF4C53A5),
                ),
              ),
            ),
          ),

          const SizedBox(width: 18),

          // Message/Chat Icon
          badges.Badge(
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.all(5),
            ),
            badgeContent: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/list_chat");
              },
              child: const Icon(
                Icons.message_sharp,
                size: 28,
                color: Color(0xFF4C53A5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
