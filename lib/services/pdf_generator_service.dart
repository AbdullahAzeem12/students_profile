import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/student_profile.dart';

class PdfGeneratorService {
  static Future<String?> generateCustomResume({
    required StudentProfile profile,
    required bool isDarkTheme,
    required bool includeSkills,
    required bool includeProjects,
    String? userName,
    String? userEmail,
    String? userUniversity,
    String? userDegree,
  }) async {
    try {
      final pdf = pw.Document();

      final primaryColor = isDarkTheme ? PdfColors.white : PdfColors.black;
      final bgColor = isDarkTheme ? PdfColor.fromHex('#1A1A1A') : PdfColors.white;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            buildBackground: (pw.Context context) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: bgColor),
            ),
          ),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    userName ?? profile.fullName,
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: primaryColor),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    '${userEmail ?? ''} | ${profile.location}',
                    style: pw.TextStyle(fontSize: 12, color: primaryColor),
                  ),
                ),
                pw.Divider(thickness: 1, color: primaryColor),
                pw.SizedBox(height: 10),
                pw.Text('PROFESSIONAL SUMMARY', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: primaryColor)),
                pw.SizedBox(height: 5),
                pw.Text(profile.shortBio, style: pw.TextStyle(fontSize: 11, color: primaryColor)),
                pw.SizedBox(height: 15),
                
                pw.Text('EDUCATION', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: primaryColor)),
                pw.SizedBox(height: 5),
                pw.Text(userUniversity ?? profile.university, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: primaryColor)),
                pw.Text('${userDegree ?? profile.degreeProgram} - Semester ${profile.semester}', style: pw.TextStyle(fontSize: 11, color: primaryColor)),
                pw.SizedBox(height: 15),

                if (includeSkills) ...[
                  pw.Text('SKILLS & EXPERTISE', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: primaryColor)),
                  pw.SizedBox(height: 5),
                  pw.Text('Flutter, Dart, Firebase, Supabase, UI/UX Design, REST APIs, Git, Agile Methodologies.', style: pw.TextStyle(fontSize: 11, color: primaryColor)),
                  pw.SizedBox(height: 15),
                ],

                if (includeProjects) ...[
                  pw.Text('PROJECTS', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: primaryColor)),
                  pw.SizedBox(height: 5),
                  pw.Text('• E-Commerce App\n• Social Media Dashboard\n• AI Interview Assistant', style: pw.TextStyle(fontSize: 11, color: primaryColor)),
                  pw.SizedBox(height: 15),
                ],
                
                pw.Text('CONTACT & LINKS', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: primaryColor)),
                pw.SizedBox(height: 5),
                pw.Text('GitHub: ${profile.github}\nLinkedIn: ${profile.linkedin}\nPortfolio: ${profile.portfolio}', style: pw.TextStyle(fontSize: 11, color: primaryColor)),
              ],
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final String safeName = (userName ?? profile.fullName).replaceAll(' ', '_');
      final file = File('${directory.path}/${safeName}_ATS_Resume.pdf');
      await file.writeAsBytes(await pdf.save());
      return file.path;
    } catch (e) {
      debugPrint("PDF Generation Error: $e");
      return null;
    }
  }
}
