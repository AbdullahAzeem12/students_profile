import 'package:flutter/material.dart';

class RainbowBorderContainer extends StatefulWidget {
  final Widget child;

  const RainbowBorderContainer({super.key, required this.child});

  @override
  State<RainbowBorderContainer> createState() => _RainbowBorderContainerState();
}

class _RainbowBorderContainerState extends State<RainbowBorderContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: SweepGradient(
              colors: const [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple,
                Colors.red,
              ],
              stops: const [0.0, 0.14, 0.28, 0.42, 0.57, 0.71, 0.85, 1.0],
              transform: GradientRotation(_controller.value * 2 * 3.1415927),
            ),
          ),
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Theme.of(context).cardColor,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
