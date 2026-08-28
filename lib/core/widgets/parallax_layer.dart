import 'package:flutter/material.dart';

class ParallaxLayer extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final double speedFactor;
  final Axis direction;

  const ParallaxLayer({
    super.key,
    required this.child,
    this.scrollController,
    this.speedFactor = 0.5,
    this.direction = Axis.vertical,
  });

  @override
  State<ParallaxLayer> createState() => _ParallaxLayerState();
}

class _ParallaxLayerState extends State<ParallaxLayer> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ParallaxLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (widget.scrollController != null && mounted) {
      setState(() {
        _offset = widget.scrollController!.offset * widget.speedFactor;
      });
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: widget.direction == Axis.vertical
          ? Offset(0, -_offset)
          : Offset(-_offset, 0),
      child: widget.child,
    );
  }
}

class EntranceAnimationWidget extends StatefulWidget {
  final Widget child;
  final int index;
  final bool isLeftColumn;
  final Duration duration;
  final Curve curve;
  final double offsetDistance;

  const EntranceAnimationWidget({
    super.key,
    required this.child,
    this.index = 0,
    this.isLeftColumn = true,
    this.duration = const Duration(milliseconds: 450),
    this.curve = Curves.easeOutCubic,
    this.offsetDistance = 30.0,
  });

  @override
  State<EntranceAnimationWidget> createState() =>
      _EntranceAnimationWidgetState();
}

class _EntranceAnimationWidgetState extends State<EntranceAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    final startX = widget.isLeftColumn
        ? -widget.offsetDistance
        : widget.offsetDistance;

    _slideAnimation = Tween<Offset>(
      begin: Offset(startX / 100, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    final delay = (widget.index * 60).clamp(0, 400);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
