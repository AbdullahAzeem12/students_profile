import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/student_profile.dart';

class GeminiService {
  static final GeminiService instance = GeminiService._init();
  GenerativeModel? _model;
  ChatSession? _chat;

  GeminiService._init();

  void initialize(String apiKey, StudentProfile profile) {
    if (apiKey.isEmpty) return;
    
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system('''
You are an AI assistant representing ${profile.fullName}, a ${profile.title}.
You have knowledge of their profile:
- Bio: ${profile.shortBio}
- University: ${profile.university}
- Degree: ${profile.degreeProgram}
- Location: ${profile.location}

Your goal is to answer questions from recruiters or visitors about ${profile.fullName}'s experience, skills, and background. 
Be professional, concise, and highly positive about their capabilities.
'''),
    );
    
    _chat = _model!.startChat();
  }

  bool get isInitialized => _model != null && _chat != null;

  Future<String> sendMessage(String message) async {
    if (!isInitialized) {
      return "AI Assistant is not initialized. Please provide a valid Gemini API key in the settings.";
    }

    try {
      final response = await _chat!.sendMessage(Content.text(message));
      return response.text ?? "I'm sorry, I couldn't process that request.";
    } catch (e) {
      debugPrint("Gemini API Error: $e");
      return "I'm currently offline or experiencing issues connecting to my brain. Please try again later.";
    }
  }
}
