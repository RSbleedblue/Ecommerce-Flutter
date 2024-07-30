import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChange with ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (type == Locale('en')) {
      await sp.setString('Language Code', 'en');
    } else { 
      await sp.setString('Language Code', 'es');
    }
    _appLocale = type; // Update the locale
    notifyListeners(); // Notify listeners
  }
}
