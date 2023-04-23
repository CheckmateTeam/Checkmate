import 'package:checkmate/pages/authentication/signin.dart';
import 'package:checkmate/pages/home.dart';
import 'package:checkmate/provider/db.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'provider/theme_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => Database()),
      ],
      child: MaterialApp(
        title: 'Checkmate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(241, 91, 91, 1),
              brightness: Brightness.light,
            ),
            fontFamily: GoogleFonts.nunito().fontFamily,
            textTheme: GoogleFonts.nunitoTextTheme()),
        home: SafeArea(
          child: Center(
            child: FutureBuilder(
              future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        final User? user = snapshot.data;
                        if (user == null) {
                          return const Scaffold(
                            body: SignIn(),
                          );
                        } else {
                          return const Home();
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
