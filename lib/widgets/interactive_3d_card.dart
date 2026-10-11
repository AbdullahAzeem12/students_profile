import 'package:flutter/material.dart';

class Interactive3DCard extends StatefulWidget {
  final Widget child;
  final double depth;

  const Interactive3DCard({
    super.key,
    required this.child,
    this.depth = 1.0,
  });

  @override
  State<Interactive3DCard> createState() => _Interactive3DCardState();
}

class _Interactive3DCardState extends State<Interactive3DCard> {
  double _targetX = 0;
  double _targetY = 0;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _targetX -= details.delta.dy * 0.005 * widget.depth;
      _targetY += details.delta.dx * 0.005 * widget.depth;
      
      _targetX = _targetX.clamp(-0.2, 0.2);
      _targetY = _targetY.clamp(-0.2, 0.2);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _reset();
  }
  
  void _reset() {
    setState(() {
      _targetX = 0;
      _targetY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onTapUp: (_) => _reset(),
      onTapCancel: _reset,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 150),
        tween: Tween<double>(begin: 0, end: _targetX),
        builder: (context, valX, _) {
          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 150),
            tween: Tween<double>(begin: 0, end: _targetY),
            builder: (context, valY, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(valX)
                  ..rotateY(valY),
                alignment: FractionalOffset.center,
                child: widget.child,
              );
            },
          );
        },
      ),
    );
  }
}
