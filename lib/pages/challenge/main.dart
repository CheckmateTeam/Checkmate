import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'welcome.dart';

void main() {
  runApp(TapHero());
}

class TapHero extends StatefulWidget {
  @override
  _TapHeroState createState() => _TapHeroState();
}

class _TapHeroState extends State<TapHero> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Welcome(),
    );
  }
}
