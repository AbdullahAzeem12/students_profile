// Student Profile Model
//
// This class represents the complete student identity. It includes personal details,
// academic information, and social connections.
// This model forms the core of the portfolio application.
import 'package:flutter/foundation.dart';

@immutable
class StudentProfile {
  /// The full name of the student.
  final String fullName;

  /// A professional or academic title, e.g., 'Computer Science Student'.
  final String title;

  /// A short introduction displayed on the home screen.
  final String introduction;

  /// The name of the university or institute the student is attending.
  final String university;

  /// The specific degree program, e.g., 'B.Sc. in Software Engineering'.
  final String degreeProgram;

  /// The current semester of study.
  final int semester;

  /// A detailed biographical text for the profile screen.
  final String shortBio;

  /// The student's current location, e.g., 'New York, USA'.
  final String location;

  /// An asset path or URL for the student's profile image.
  final String profileImage;

  /// The student's primary email address for contact.
  final String email;

  /// The student's phone number.
  final String phone;

  /// A link to the student's GitHub profile.
  final String github;

  /// A link to the student's LinkedIn profile.
  final String linkedin;

  /// A link to the student's personal portfolio website.
  final String portfolio;

  /// A status message for the profile.
  final String profileStatus;

  /// Primary constructor for [StudentProfile].
  /// Requires all properties to be explicitly defined.
  const StudentProfile({
    required this.fullName,
    required this.title,
    required this.introduction,
    required this.university,
    required this.degreeProgram,
    required this.semester,
    required this.shortBio,
    required this.location,
    required this.profileImage,
    required this.email,
    required this.phone,
    required this.github,
    required this.linkedin,
    required this.portfolio,
    required this.profileStatus,
  });

  /// Creates a copy of this [StudentProfile] but with the given fields replaced with the new values.
  StudentProfile copyWith({
    String? fullName,
    String? title,
    String? introduction,
    String? university,
    String? degreeProgram,
    int? semester,
    String? shortBio,
    String? location,
    String? profileImage,
    String? email,
    String? phone,
    String? github,
    String? linkedin,
    String? portfolio,
    String? profileStatus,
  }) {
    return StudentProfile(
      fullName: fullName ?? this.fullName,
      title: title ?? this.title,
      introduction: introduction ?? this.introduction,
      university: university ?? this.university,
      degreeProgram: degreeProgram ?? this.degreeProgram,
      semester: semester ?? this.semester,
      shortBio: shortBio ?? this.shortBio,
      location: location ?? this.location,
      profileImage: profileImage ?? this.profileImage,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
      portfolio: portfolio ?? this.portfolio,
      profileStatus: profileStatus ?? this.profileStatus,
    );
  }

  /// Converts the [StudentProfile] instance into a `Map<String, dynamic>`.
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'title': title,
      'introduction': introduction,
      'university': university,
      'degreeProgram': degreeProgram,
      'semester': semester,
      'shortBio': shortBio,
      'location': location,
      'profileImage': profileImage,
      'email': email,
      'phone': phone,
      'github': github,
      'linkedin': linkedin,
      'portfolio': portfolio,
      'profileStatus': profileStatus,
    };
  }

  /// Creates a [StudentProfile] instance from a `Map<String, dynamic>`.
  factory StudentProfile.fromMap(Map<String, dynamic> map) {
    return StudentProfile(
      fullName: map['fullName'] ?? '',
      title: map['title'] ?? '',
      introduction: map['introduction'] ?? '',
      university: map['university'] ?? '',
      degreeProgram: map['degreeProgram'] ?? '',
      semester: map['semester']?.toInt() ?? 1,
      shortBio: map['shortBio'] ?? '',
      location: map['location'] ?? '',
      profileImage: map['profileImage'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      github: map['github'] ?? '',
      linkedin: map['linkedin'] ?? '',
      portfolio: map['portfolio'] ?? '',
      profileStatus: map['profileStatus'] ?? '',
    );
  }

  /// Validates the profile data.
  /// Returns a list of error messages if any validation fails.
  /// Returns an empty list if validation is successful.
  List<String> validate() {
    final errors = <String>[];
    if (fullName.isEmpty) errors.add('Full name cannot be empty.');
    if (email.isEmpty || !email.contains('@')) {
      errors.add('Invalid email address.');
    }
    if (semester < 1 || semester > 12) errors.add('Invalid semester value.');
    return errors;
  }

  /// Checks if the academic information is complete.
  bool hasCompleteAcademicInfo() {
    return university.isNotEmpty && degreeProgram.isNotEmpty && semester > 0;
  }

  /// Checks if the basic contact information is valid and present.
  bool hasValidContactInfo() {
    return email.isNotEmpty && email.contains('@') && phone.isNotEmpty;
  }

  @override
  String toString() {
    return 'StudentProfile(fullName: $fullName, title: $title, university: $university, semester: $semester)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StudentProfile &&
        other.fullName == fullName &&
        other.email == email &&
        other.university == university &&
        other.semester == semester;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        email.hashCode ^
        university.hashCode ^
        semester.hashCode;
  }
}
