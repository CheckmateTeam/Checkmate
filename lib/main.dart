import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'provider/ThemeProvider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.removeAfter(initialization);

  runApp(const MainApp());
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 3));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<ChangeNotifier>(create: (_) => ThemeProvider()),
        ],
        child: MaterialApp(
          title: 'Checkmate',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromRGBO(127, 17, 224, 1),
              brightness: Brightness.light,
              // primary:
              // secondary:
            ),
          ),
          home: MainPage(),
        ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Scaffold(
          body: TabBarView(
            children: [
              Center(
                child: Text('List'),
              ),
              Center(
                child: Text('Archive'),
              ),
              Center(
                child: Text('Notifications'),
              ),
              Center(
                child: Text('Settings'),
              ),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.list_alt_outlined),
              ),
              Tab(
                icon: Icon(Icons.archive_outlined),
              ),
              Tab(
                icon: Icon(Icons.notifications_active_outlined),
              ),
              Tab(
                icon: Icon(Icons.settings_outlined),
              ),
            ],
          )),
    );
  }
}
