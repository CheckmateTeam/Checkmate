import 'package:checkmate/pages/authentication/signin.dart';
import 'package:checkmate/pages/home.dart';
import 'package:checkmate/Services/noti_service.dart';
import 'package:checkmate/provider/db.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'provider/theme_provider.dart';


  FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

void main() async {
  
  NotificationService.initNotification();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => Database()),
      ChangeNotifierProvider(create: (_) => CalendarModel())
    ], child: const MainApp()),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    

    // Provider.of<Database>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<Database>().init();
    return MaterialApp(
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('th', 'TH'),
      ],
      title: 'Checkmate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(241, 91, 91, 1),
            brightness: Brightness.light,
            primary: const Color.fromRGBO(241, 91, 91, 1),
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
    );
  }
}
