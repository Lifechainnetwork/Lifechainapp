import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'English';
  final String _languageKey = 'selectedLanguage';
  
  // Available languages
  final List<String> availableLanguages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
  ];

  String get currentLanguage => _currentLanguage;
  
  // Locale mapping
  Locale get currentLocale {
    switch (_currentLanguage) {
      case 'Hindi':
        return const Locale('hi', 'IN');
      case 'Spanish':
        return const Locale('es', 'ES');
      case 'French':
        return const Locale('fr', 'FR');
      case 'German':
        return const Locale('de', 'DE');
      case 'Chinese':
        return const Locale('zh', 'CN');
      case 'Japanese':
        return const Locale('ja', 'JP');
      default:
        return const Locale('en', 'US');
    }
  }

  LanguageProvider() {
    _loadLanguageFromPrefs();
  }

  Future<void> _loadLanguageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? 'English';
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (availableLanguages.contains(language)) {
      _currentLanguage = language;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language);
      notifyListeners();
    }
  }
}
