// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorage storage = LocalStorage('theme');
  bool _isDark = false;
  ThemeProvider() {
    _isDark = storage.getItem('isDark');
  }

  bool get isDark => storage.getItem('isDark') ?? false;
  ThemeData get getThemeData => _isDark
      ? ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(241, 91, 91, 1),
            brightness: Brightness.dark,
            primary: const Color.fromRGBO(241, 91, 91, 1),
          ),
          fontFamily: GoogleFonts.nunito().fontFamily,
          textTheme: GoogleFonts.nunitoTextTheme())
      : ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(241, 91, 91, 1),
            brightness: Brightness.light,
            primary: const Color.fromRGBO(241, 91, 91, 1),
          ),
          fontFamily: GoogleFonts.nunito().fontFamily,
          textTheme: GoogleFonts.nunitoTextTheme());
  void toggleTheme() {
    storage.setItem('isDark', !_isDark);
    _isDark = storage.getItem('isDark');
    notifyListeners();
  }
}
