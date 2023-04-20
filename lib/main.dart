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
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const MainApp(),
  );
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
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
        ),
      ),
      home: Center(
        child: FutureBuilder(
          future: initialization(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => ThemeProvider()),
                  ChangeNotifierProvider(create: (_) => Database()),
                ],
                child: StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final User? user = snapshot.data;
                      if (user == null) {
                        return const Scaffold(
                          body: SignIn(),
                        );
                      } else {
                        return const Scaffold(
                          body: Home(),
                        );
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
