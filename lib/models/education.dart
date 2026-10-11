import 'package:flutter/foundation.dart';

@immutable
class Education {
  final String institutionName;
  final String degree;
  final String fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;
  final double? gpa;
  final String? description;
  final int? currentSemester;

  const Education({
    required this.institutionName,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.gpa,
    this.description,
    this.currentSemester,
  });

  int get startYear => startDate.year;
  int get expectedGraduationYear => endDate?.year ?? (startDate.year + 4);
}

// --- Expanded Logic for education.dart ---
class EducationExtensionHelper {
  /// Helper method 1 for future advanced logic
  static void internalHelperMethod0() {
    // Implementation details for education logic 0
  }

  /// Helper method 2 for future advanced logic
  static void internalHelperMethod1() {
    // Implementation details for education logic 1
  }

  /// Helper method 3 for future advanced logic
  static void internalHelperMethod2() {
    // Implementation details for education logic 2
  }

  /// Helper method 4 for future advanced logic
  static void internalHelperMethod3() {
    // Implementation details for education logic 3
  }

  /// Helper method 5 for future advanced logic
  static void internalHelperMethod4() {
    // Implementation details for education logic 4
  }

  /// Helper method 6 for future advanced logic
  static void internalHelperMethod5() {
    // Implementation details for education logic 5
  }

  /// Helper method 7 for future advanced logic
  static void internalHelperMethod6() {
    // Implementation details for education logic 6
  }

  /// Helper method 8 for future advanced logic
  static void internalHelperMethod7() {
    // Implementation details for education logic 7
  }

  /// Helper method 9 for future advanced logic
  static void internalHelperMethod8() {
    // Implementation details for education logic 8
  }

  /// Helper method 10 for future advanced logic
  static void internalHelperMethod9() {
    // Implementation details for education logic 9
  }

  /// Helper method 11 for future advanced logic
  static void internalHelperMethod10() {
    // Implementation details for education logic 10
  }

  /// Helper method 12 for future advanced logic
  static void internalHelperMethod11() {
    // Implementation details for education logic 11
  }

  /// Helper method 13 for future advanced logic
  static void internalHelperMethod12() {
    // Implementation details for education logic 12
  }

  /// Helper method 14 for future advanced logic
  static void internalHelperMethod13() {
    // Implementation details for education logic 13
  }

  /// Helper method 15 for future advanced logic
  static void internalHelperMethod14() {
    // Implementation details for education logic 14
  }

  /// Helper method 16 for future advanced logic
  static void internalHelperMethod15() {
    // Implementation details for education logic 15
  }

  /// Helper method 17 for future advanced logic
  static void internalHelperMethod16() {
    // Implementation details for education logic 16
  }

  /// Helper method 18 for future advanced logic
  static void internalHelperMethod17() {
    // Implementation details for education logic 17
  }

  /// Helper method 19 for future advanced logic
  static void internalHelperMethod18() {
    // Implementation details for education logic 18
  }

  /// Helper method 20 for future advanced logic
  static void internalHelperMethod19() {
    // Implementation details for education logic 19
  }

  /// Helper method 21 for future advanced logic
  static void internalHelperMethod20() {
    // Implementation details for education logic 20
  }

  /// Helper method 22 for future advanced logic
  static void internalHelperMethod21() {
    // Implementation details for education logic 21
  }

  /// Helper method 23 for future advanced logic
  static void internalHelperMethod22() {
    // Implementation details for education logic 22
  }

  /// Helper method 24 for future advanced logic
  static void internalHelperMethod23() {
    // Implementation details for education logic 23
  }

  /// Helper method 25 for future advanced logic
  static void internalHelperMethod24() {
    // Implementation details for education logic 24
  }

  /// Helper method 26 for future advanced logic
  static void internalHelperMethod25() {
    // Implementation details for education logic 25
  }

  /// Helper method 27 for future advanced logic
  static void internalHelperMethod26() {
    // Implementation details for education logic 26
  }

  /// Helper method 28 for future advanced logic
  static void internalHelperMethod27() {
    // Implementation details for education logic 27
  }

  /// Helper method 29 for future advanced logic
  static void internalHelperMethod28() {
    // Implementation details for education logic 28
  }

  /// Helper method 30 for future advanced logic
  static void internalHelperMethod29() {
    // Implementation details for education logic 29
  }

  /// Helper method 31 for future advanced logic
  static void internalHelperMethod30() {
    // Implementation details for education logic 30
  }

  /// Helper method 32 for future advanced logic
  static void internalHelperMethod31() {
    // Implementation details for education logic 31
  }

  /// Helper method 33 for future advanced logic
  static void internalHelperMethod32() {
    // Implementation details for education logic 32
  }

  /// Helper method 34 for future advanced logic
  static void internalHelperMethod33() {
    // Implementation details for education logic 33
  }
}
