import 'package:checkmate/pages/authentication/signin.dart';
import 'package:checkmate/pages/authentication/signup.dart';
import 'package:checkmate/pages/home.dart';
import 'package:checkmate/provider/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.removeAfter(initialization);

  runApp(
    MultiProvider(providers: [
      Provider<ChangeNotifier>(create: (_) => ThemeProvider()),
      Provider<ChangeNotifier>(create: (_) => Database()),
    ], child: const MainApp()),
  );
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 3));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkmate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(127, 17, 224, 1),
          brightness: Brightness.light,
          // primary:
          // secondary:
        ),
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) => const SignIn(),
        '/sign-up': (context) => const SignUp(),
        '/home': (context) => const Home(),
      },
    );
  }
}
