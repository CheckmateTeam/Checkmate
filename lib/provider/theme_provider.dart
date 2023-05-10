// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorage storage = LocalStorage('theme');
  bool _isDark = false;
  String _themeColor = 'Default';
  ThemeProvider() {
    _isDark = storage.getItem('isDark') ?? false;
    _themeColor = storage.getItem('themeColor') ?? 'Default';
  }

  bool get isDark => storage.getItem('isDark') ?? false;
  String get themeColor => storage.getItem('themeColor') ?? 'Default';
  void setIsDark(bool value) {
    if (value == false) {
      storage.setItem('themeColor', 'Default');
      _themeColor = 'Default';
    }
    storage.setItem('isDark', value);
    _isDark = value;
    notifyListeners();
  }

  void setColor(String value) {
    storage.setItem('themeColor', value);
    _themeColor = value;
    notifyListeners();
  }

  ThemeData get getThemeData => _isDark
      ? ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(241, 91, 91, 1),
            brightness: Brightness.dark,
            primary: const Color.fromRGBO(241, 91, 91, 1),
            secondary: const Color.fromARGB(255, 247, 201, 0),
          ),
          fontFamily: GoogleFonts.nunito().fontFamily,
          textTheme: Typography.whiteCupertino,
          primaryColor: const Color.fromRGBO(241, 91, 91, 1), //adding by boom
          secondaryHeaderColor: Colors.white //adding by boom
          )
      : _themeColor == 'Default'
          ? ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(241, 91, 91, 1),
                brightness: Brightness.light,
                primary: const Color.fromRGBO(241, 91, 91, 1),
                secondary: const Color.fromARGB(255, 252, 154, 27),
              ),
              fontFamily: GoogleFonts.nunito().fontFamily,
              textTheme: GoogleFonts.nunitoTextTheme(),
              secondaryHeaderColor: Colors.black) //adding by boom
          : _themeColor == 'Blue'
              ? ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color.fromRGBO(0, 122, 255, 1),
                    brightness: Brightness.light,
                    primary: const Color.fromRGBO(0, 122, 255, 1),
                    secondary: const Color.fromARGB(255, 174, 228, 252),
                  ),
                  fontFamily: GoogleFonts.nunito().fontFamily,
                  secondaryHeaderColor: Colors.black, //adding by boom
                  textTheme: GoogleFonts.nunitoTextTheme())
              : _themeColor == 'Green'
                  ? ThemeData(
                      useMaterial3: true,
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: const Color.fromRGBO(52, 199, 89, 1),
                          brightness: Brightness.light,
                          primary: const Color.fromRGBO(52, 199, 89, 1),
                          secondary: Colors.yellow),
                      fontFamily: GoogleFonts.nunito().fontFamily,
                      secondaryHeaderColor: Colors.black, //adding by boom
                      textTheme: GoogleFonts.nunitoTextTheme())
                  : _themeColor == 'Yellow'
                      ? ThemeData(
                          useMaterial3: true,
                          colorScheme: ColorScheme.fromSeed(
                            seedColor: const Color.fromARGB(255, 221, 162, 0),
                            brightness: Brightness.light,
                            primary: Color.fromARGB(255, 221, 162, 0),
                            secondary: Colors.red,
                          ),
                          fontFamily: GoogleFonts.nunito().fontFamily,
                          secondaryHeaderColor: Colors.black, //adding by boom
                          textTheme: GoogleFonts.nunitoTextTheme())
                      : _themeColor == 'Purple'
                          ? ThemeData(
                              useMaterial3: true,
                              colorScheme: ColorScheme.fromSeed(
                                  seedColor: Color.fromARGB(255, 175, 47, 207),
                                  brightness: Brightness.light,
                                  primary: Color.fromARGB(255, 175, 47, 207),
                                  secondary:
                                      const Color.fromARGB(255, 255, 0, 132)),
                              fontFamily: GoogleFonts.nunito().fontFamily,
                              secondaryHeaderColor:
                                  Colors.black, //adding by boom
                              textTheme: GoogleFonts.nunitoTextTheme())
                          : ThemeData(
                              useMaterial3: true,
                              colorScheme: ColorScheme.fromSeed(
                                seedColor: const Color.fromRGBO(241, 91, 91, 1),
                                brightness: Brightness.light,
                                primary: const Color.fromRGBO(241, 91, 91, 1),
                                secondary:
                                    const Color.fromARGB(255, 252, 154, 27),
                              ),
                              fontFamily: GoogleFonts.nunito().fontFamily,
                              secondaryHeaderColor:
                                  Colors.black, //adding by boom
                              textTheme: GoogleFonts.nunitoTextTheme());
  void toggleTheme() {
    storage.setItem('isDark', !_isDark);
    _isDark = storage.getItem('isDark');
    notifyListeners();
  }
}
