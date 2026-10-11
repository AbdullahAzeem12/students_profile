import 'package:flutter/material.dart';
import '../models/student_profile.dart';
import '../services/auth_service.dart';
import '../services/pdf_generator_service.dart';

class PdfCustomizationModal extends StatefulWidget {
  final StudentProfile profile;
  
  const PdfCustomizationModal({super.key, required this.profile});

  @override
  State<PdfCustomizationModal> createState() => _PdfCustomizationModalState();
}

class _PdfCustomizationModalState extends State<PdfCustomizationModal> {
  bool isDarkTheme = false;
  bool includeSkills = true;
  bool includeProjects = true;
  bool isGenerating = false;

  void _generatePdf() async {
    setState(() => isGenerating = true);
    
    final auth = AuthService();
    final user = auth.currentUser;
    
    final path = await PdfGeneratorService.generateCustomResume(
      profile: widget.profile,
      isDarkTheme: isDarkTheme,
      includeSkills: includeSkills,
      includeProjects: includeProjects,
      userName: user?.name,
      userEmail: user?.email,
      userUniversity: user?.university,
      userDegree: user?.degree,
    );
    
    if (!mounted) return;
    setState(() => isGenerating = false);
    Navigator.of(context).pop();
    
    if (path != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resume saved to $path'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to generate PDF'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customize Resume PDF',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Dark Mode Theme'),
            subtitle: const Text('Export the PDF with a dark background'),
            value: isDarkTheme,
            onChanged: (val) => setState(() => isDarkTheme = val),
            activeThumbColor: Theme.of(context).primaryColor,
          ),
          SwitchListTile(
            title: const Text('Include Skills Section'),
            value: includeSkills,
            onChanged: (val) => setState(() => includeSkills = val),
            activeThumbColor: Theme.of(context).primaryColor,
          ),
          SwitchListTile(
            title: const Text('Include Projects Section'),
            value: includeProjects,
            onChanged: (val) => setState(() => includeProjects = val),
            activeThumbColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: isGenerating ? null : _generatePdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: isGenerating 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.picture_as_pdf),
              label: Text(isGenerating ? 'Generating...' : 'Generate & Download PDF', style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
