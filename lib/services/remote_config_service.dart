import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteConfigService extends ChangeNotifier {
  // Simulated configuration flags
  bool _showEducationTab = true;
  bool _showAnalytics = true;
  bool _enable3DEffects = true;
  
  bool get showEducationTab => _showEducationTab;
  bool get showAnalytics => _showAnalytics;
  bool get enable3DEffects => _enable3DEffects;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Simulate network delay for fetching remote config
    await Future.delayed(const Duration(milliseconds: 800));
    
    _showEducationTab = prefs.getBool('rc_showEducationTab') ?? true;
    _showAnalytics = prefs.getBool('rc_showAnalytics') ?? true;
    _enable3DEffects = prefs.getBool('rc_enable3DEffects') ?? true;
    
    _isInitialized = true;
    notifyListeners();
  }

  // Developer tool to toggle features at runtime
  Future<void> toggleFeature(String featureName, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (featureName) {
      case 'showEducationTab':
        _showEducationTab = value;
        await prefs.setBool('rc_showEducationTab', value);
        break;
      case 'showAnalytics':
        _showAnalytics = value;
        await prefs.setBool('rc_showAnalytics', value);
        break;
      case 'enable3DEffects':
        _enable3DEffects = value;
        await prefs.setBool('rc_enable3DEffects', value);
        break;
    }
    notifyListeners();
  }
}
