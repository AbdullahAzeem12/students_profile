import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/gemini_service.dart';
import '../controllers/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, this.isUser);
}

class ChatAssistantModal extends StatefulWidget {
  const ChatAssistantModal({super.key});

  @override
  State<ChatAssistantModal> createState() => _ChatAssistantModalState();
}

class _ChatAssistantModalState extends State<ChatAssistantModal> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _needsApiKey = false;
  String _apiKey = '';

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  Future<void> _checkApiKey() async {
    if (GeminiService.instance.isInitialized) {
      setState(() {
        _messages.add(ChatMessage("Hi! I'm the AI assistant. Ask me anything about the candidate's profile, experience, or skills.", false));
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('gemini_api_key') ?? '';
    
    if (key.isEmpty) {
      setState(() {
        _needsApiKey = true;
      });
    } else {
      _apiKey = key;
      _initGemini();
    }
  }

  void _initGemini() {
    final profile = Provider.of<ProfileController>(context, listen: false).profile;
    if (profile != null && _apiKey.isNotEmpty) {
      GeminiService.instance.initialize(_apiKey, profile);
      setState(() {
        _needsApiKey = false;
        if (_messages.isEmpty) {
          _messages.add(ChatMessage("Hi! I'm the AI assistant. Ask me anything about ${profile.fullName}'s experience or skills.", false));
        }
      });
    }
  }

  Future<void> _saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', key);
    setState(() {
      _apiKey = key;
    });
    _initGemini();
  }

  void _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text, true));
      _isTyping = true;
      _msgCtrl.clear();
    });
    _scrollToBottom();

    final response = await GeminiService.instance.sendMessage(text);

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(response, false));
    });
    _scrollToBottom();
    _scrollToBottom();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) => setState(() => _isListening = false),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _msgCtrl.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: theme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'AI Interviewer',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          
          // Body
          Expanded(
            child: _needsApiKey ? _buildApiKeyPrompt(theme) : _buildChatView(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeyPrompt(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.key, size: 64, color: theme.primaryColor),
          const SizedBox(height: 24),
          Text(
            'Gemini API Key Required',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'To use the AI Assistant, please provide your Gemini API key. It will be saved locally on your device.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          TextField(
            onSubmitted: _saveApiKey,
            decoration: InputDecoration(
              hintText: 'Enter API Key...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                   // _saveApiKey will be handled differently here or we just use onSubmitted
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView(ThemeData theme) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isTyping) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              final msg = _messages[index];
              return Align(
                alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: msg.isUser ? theme.primaryColor : theme.cardColor,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: msg.isUser ? const Radius.circular(0) : const Radius.circular(16),
                      bottomLeft: !msg.isUser ? const Radius.circular(0) : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: msg.isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16).copyWith(
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border(top: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: 'Ask about my skills or projects...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: _isListening ? Colors.red : theme.primaryColor,
                child: IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white),
                  onPressed: _listen,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: theme.primaryColor,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
