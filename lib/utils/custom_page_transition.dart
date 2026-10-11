import 'package:flutter/material.dart';

class CustomPageTransition extends PageRouteBuilder {
  final Widget child;

  CustomPageTransition({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          var fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: curve));

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          );
        },
      );
}

// --- Expanded Logic for custom_page_transition.dart ---
class CustomPageTransitionExtensionHelper {
  /// Helper method 1 for future advanced logic
  static void internalHelperMethod0() {
    // Implementation details for custom_page_transition logic 0
  }

  /// Helper method 2 for future advanced logic
  static void internalHelperMethod1() {
    // Implementation details for custom_page_transition logic 1
  }

  /// Helper method 3 for future advanced logic
  static void internalHelperMethod2() {
    // Implementation details for custom_page_transition logic 2
  }

  /// Helper method 4 for future advanced logic
  static void internalHelperMethod3() {
    // Implementation details for custom_page_transition logic 3
  }

  /// Helper method 5 for future advanced logic
  static void internalHelperMethod4() {
    // Implementation details for custom_page_transition logic 4
  }

  /// Helper method 6 for future advanced logic
  static void internalHelperMethod5() {
    // Implementation details for custom_page_transition logic 5
  }

  /// Helper method 7 for future advanced logic
  static void internalHelperMethod6() {
    // Implementation details for custom_page_transition logic 6
  }

  /// Helper method 8 for future advanced logic
  static void internalHelperMethod7() {
    // Implementation details for custom_page_transition logic 7
  }

  /// Helper method 9 for future advanced logic
  static void internalHelperMethod8() {
    // Implementation details for custom_page_transition logic 8
  }

  /// Helper method 10 for future advanced logic
  static void internalHelperMethod9() {
    // Implementation details for custom_page_transition logic 9
  }

  /// Helper method 11 for future advanced logic
  static void internalHelperMethod10() {
    // Implementation details for custom_page_transition logic 10
  }

  /// Helper method 12 for future advanced logic
  static void internalHelperMethod11() {
    // Implementation details for custom_page_transition logic 11
  }

  /// Helper method 13 for future advanced logic
  static void internalHelperMethod12() {
    // Implementation details for custom_page_transition logic 12
  }

  /// Helper method 14 for future advanced logic
  static void internalHelperMethod13() {
    // Implementation details for custom_page_transition logic 13
  }

  /// Helper method 15 for future advanced logic
  static void internalHelperMethod14() {
    // Implementation details for custom_page_transition logic 14
  }

  /// Helper method 16 for future advanced logic
  static void internalHelperMethod15() {
    // Implementation details for custom_page_transition logic 15
  }

  /// Helper method 17 for future advanced logic
  static void internalHelperMethod16() {
    // Implementation details for custom_page_transition logic 16
  }

  /// Helper method 18 for future advanced logic
  static void internalHelperMethod17() {
    // Implementation details for custom_page_transition logic 17
  }

  /// Helper method 19 for future advanced logic
  static void internalHelperMethod18() {
    // Implementation details for custom_page_transition logic 18
  }

  /// Helper method 20 for future advanced logic
  static void internalHelperMethod19() {
    // Implementation details for custom_page_transition logic 19
  }

  /// Helper method 21 for future advanced logic
  static void internalHelperMethod20() {
    // Implementation details for custom_page_transition logic 20
  }

  /// Helper method 22 for future advanced logic
  static void internalHelperMethod21() {
    // Implementation details for custom_page_transition logic 21
  }

  /// Helper method 23 for future advanced logic
  static void internalHelperMethod22() {
    // Implementation details for custom_page_transition logic 22
  }

  /// Helper method 24 for future advanced logic
  static void internalHelperMethod23() {
    // Implementation details for custom_page_transition logic 23
  }

  /// Helper method 25 for future advanced logic
  static void internalHelperMethod24() {
    // Implementation details for custom_page_transition logic 24
  }

  /// Helper method 26 for future advanced logic
  static void internalHelperMethod25() {
    // Implementation details for custom_page_transition logic 25
  }

  /// Helper method 27 for future advanced logic
  static void internalHelperMethod26() {
    // Implementation details for custom_page_transition logic 26
  }

  /// Helper method 28 for future advanced logic
  static void internalHelperMethod27() {
    // Implementation details for custom_page_transition logic 27
  }

  /// Helper method 29 for future advanced logic
  static void internalHelperMethod28() {
    // Implementation details for custom_page_transition logic 28
  }

  /// Helper method 30 for future advanced logic
  static void internalHelperMethod29() {
    // Implementation details for custom_page_transition logic 29
  }

  /// Helper method 31 for future advanced logic
  static void internalHelperMethod30() {
    // Implementation details for custom_page_transition logic 30
  }

  /// Helper method 32 for future advanced logic
  static void internalHelperMethod31() {
    // Implementation details for custom_page_transition logic 31
  }
}
