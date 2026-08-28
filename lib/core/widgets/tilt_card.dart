import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TiltCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double maxTiltAngleDegrees;
  final double perspective;

  const TiltCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.maxTiltAngleDegrees = 8.0,
    this.perspective = 0.001,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _springController;
  late Animation<double> _rotXAnimation;
  late Animation<double> _rotYAnimation;

  double _rotX = 0.0;
  double _rotY = 0.0;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..addListener(() {
        setState(() {
          _rotX = _rotXAnimation.value;
          _rotY = _rotYAnimation.value;
        });
      });

    _rotXAnimation = const AlwaysStoppedAnimation(0.0);
    _rotYAnimation = const AlwaysStoppedAnimation(0.0);
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (size.width == 0 || size.height == 0) return;

    final localPos = details.localPosition;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final dx = (localPos.dx - centerX) / centerX;
    final dy = (localPos.dy - centerY) / centerY;

    final maxRad = widget.maxTiltAngleDegrees * math.pi / 180;

    setState(() {
      _rotY = (dx * maxRad).clamp(-maxRad, maxRad);
      _rotX = (-dy * maxRad).clamp(-maxRad, maxRad);
      _scale = 0.98;
    });
  }

  void _onPanEnd() {
    _rotXAnimation = Tween<double>(begin: _rotX, end: 0.0).animate(
      CurvedAnimation(
        parent: _springController,
        curve: Curves.elasticOut,
      ),
    );
    _rotYAnimation = Tween<double>(begin: _rotY, end: 0.0).animate(
      CurvedAnimation(
        parent: _springController,
        curve: Curves.elasticOut,
      ),
    );

    setState(() {
      _scale = 1.0;
    });

    _springController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardSize = Size(constraints.maxWidth, constraints.maxHeight);

        final transform = Matrix4.identity()
          ..setEntry(3, 2, widget.perspective)
          ..rotateX(_rotX)
          ..rotateY(_rotY)
          ..scale(_scale);

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap?.call();
          },
          onLongPress: widget.onLongPress,
          onPanUpdate: (d) => _onPanUpdate(d, cardSize),
          onPanEnd: (_) => _onPanEnd(),
          onPanCancel: _onPanEnd,
          behavior: HitTestBehavior.opaque,
          child: Transform(
            alignment: Alignment.center,
            transform: transform,
            child: widget.child,
          ),
        );
      },
    );
  }
}
