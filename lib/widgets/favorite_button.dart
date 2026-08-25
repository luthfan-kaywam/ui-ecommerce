import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final bool initialIsFavorite;
  final ValueChanged<bool>? onChanged;
  final double size;

  const FavoriteButton({
    super.key,
    this.initialIsFavorite = false,
    this.onChanged,
    this.size = 22.0,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    _controller.forward(from: 0.0);
    if (widget.onChanged != null) {
      widget.onChanged!(_isFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 150),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _isFavorite
                  ? Colors.red.shade50
                  : Colors.grey.shade100.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.redAccent : Colors.grey.shade400,
              size: widget.size,
            ),
          ),
        ),
      ),
    );
  }
}
