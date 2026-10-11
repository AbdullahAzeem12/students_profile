import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class FloatingRiveAnimation extends StatelessWidget {
  final String networkUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const FloatingRiveAnimation({
    super.key,
    required this.networkUrl,
    this.width = 150,
    this.height = 150,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: RiveAnimation.network(
        networkUrl,
        fit: fit,
        placeHolder: const Center(child: CircularProgressIndicator()),
        onInit: (artboard) {
          // You can add controllers here for micro-interactions 
          // like hover states or tap states if the Rive file supports it.
        },
      ),
    );
  }
}
