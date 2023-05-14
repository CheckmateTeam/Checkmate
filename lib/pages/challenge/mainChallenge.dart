import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../provider/db.dart';
import '../home.dart';

import 'button.dart';
import 'dart:async';

import 'utils.dart';

import 'gamepad.dart';

class MainChallenge extends StatefulWidget {
  const MainChallenge({super.key});

  @override
  State<MainChallenge> createState() => _MainChallengeState();
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _MainChallengeState extends State<MainChallenge> {
  @override
  Widget build(BuildContext context) {
    return Game();
  }
}

class _GameState extends State<Game>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController controller;
  int duration = 1000 * 30;
  int? durationBackup;
  final Database database = Database();
  static const MethodChannel _channel = const MethodChannel('gamepad');

  static String skyAsset() => "assets/background/sky.png";
  // static var damageDefault = 500000.0;
  // static var BossHp = damageDefault;
  static var addedDuration = 1000 * 50;

  var coins = 0;
  var positionX = 0.0;
  var positionY = 0.0;
  var wayY = 0;

  var bosses = Utils.getBosses();
  var bossIndex = 0;

  var level = 1;

  var tap = false;

  var xAxis = 0.0;
  var yAxis = 0.0;

  late AudioPlayer hitPlayer;
  late AudioCache hitCache;

  late AudioPlayer coinPlayer;
  late AudioCache coinCache;

  var musicPlaying = false;

  late VoidCallback onEarnTime;

  var gameOver = false;

  Color clockColor = const Color(0xFF67AC5B);

  var _gamepadConnected = false;

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    Provider.of<Database>(context, listen: false).init();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );
    // onEarnTime.call(); // add time when game start
    // initClock(add: 10);
    onEarnTime = () {
      initClock(add: addedDuration);
    };
    onEarnTime.call();

    GamePad.isGamePadConnected.then((connected) {
      setState(() {
        _gamepadConnected = connected;
      });
    });

    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "keyCode":
          var pair = Utils.mapToPair(Map<int, bool>.from(call.arguments));
          setState(() {
            if (!gameOver) {
              if (pair.value) {
                switch (GamePad.switchMap[pair.key]) {
                  case "A":
                    damage(null);
                    break;
                }
              } else {
                hide(null);
              }
            }
          });
          break;
      }
    });
  }

  void damage(TapDownDetails? details) async {
    setState(() {
      if (details != null) {
        xAxis = details.globalPosition.dx - 40.0;
        yAxis = details.globalPosition.dy - 80.0;
      }
      tap = true;
    });

    final userDamage = database.userDamage;
    final damageUser = userDamage ?? 0;
    if (database.bossHp - damageUser <= 0) {
      // database.bossHp = 0;
      database.bossHp = database.bossHp - damageUser;
    } else {
      database.bossHp = database.bossHp - damageUser;
      print(database.bossHp);
    }
  }

  void hide(TapUpDetails? details) {
    setState(() {
      tap = false;
    });
  }

  double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  Widget hitBox() {
    if (tap) {
      wayY = Random().nextInt(100);
      positionX = Random().nextDouble() * 450;
      positionY = (Random().nextDouble() * 150) + 110;
      return Positioned(
        top: yAxis,
        left: xAxis,
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Material(
                color: Colors.transparent,
                child: StrokeText(
                  "Hit!",
                  fontSize: 14.0,
                  fontFamily: "Gameplay",
                  color: Colors.red,
                  strokeColor: Colors.white,
                  strokeWidth: 0,
                ),
              ),
            ),
            Image.asset(
              "assets/elements/hit.png",
              fit: BoxFit.fill,
              height: 80.0,
              width: 80.0,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  String hero() {
    return tap ? "assets/character/attack.png" : "assets/character/idle.png";
  }

  void share() {
    Share.share(
        "Tap Hero: I survive until ${bosses[bossIndex].name} LV$level! Now is your turn!");
  }

  Widget gameEngine(BuildContext context) {
    return width(context) >= 700
        ? Row(
            children: <Widget>[
              gamePanel(),
            ],
          )
        : Column(
            children: <Widget>[
              gamePanel(),
            ],
          );
  }

  Widget gamePanel() {
    return Align(
      // Stage panel
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.transparent,
        height: width(context) >= 700 ? height(context) : height(context),
        width: width(context) >= 700
            ? width(context) >= 700 && width(context) <= 900
                ? 400
                : width(context) - 400
            : width(context),
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              // Background
              child: Image.asset(
                skyAsset(),
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: tap
                    ? EdgeInsets.only(
                        bottom: positionX,
                        right: wayY % 2 == 1 ? positionY : 0,
                        left: wayY % 2 == 1 ? 0 : positionY)
                    : EdgeInsets.only(
                        bottom: positionX,
                        right: wayY % 2 == 1 ? positionY : 0,
                        left: wayY % 2 == 1 ? 0 : positionY),
                child: Image.asset(
                  bosses[bossIndex].asset,
                  height:
                      width(context) / 2.5 < 380 ? width(context) / 2.5 : 380,
                  fit: BoxFit.fill,
                  color: tap ? Color(0x80FFFFFF) : null,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Image.asset(
                  hero(),
                  height: width(context) / 6 < 160 ? width(context) / 6 : 160,
                  fit: BoxFit.fill,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 20, right: 160),
                          child: Stack(children: <Widget>[
                            FancyButton(
                              size: 20,
                              color: const Color(0xFFEFF3ED),
                              child: Text(
                                timerString,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontFamily: "Gameplay",
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            bosses[bossIndex].name,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xFFEFF3ED),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 100,
                            height: 10,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('user_info')
                                  .where('uid',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser?.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const LinearProgressIndicator(
                                    backgroundColor: Color(0xFFEFF3ED),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey),
                                  );
                                }
                                final database = context.watch<Database>();
                                final bossHp = database.bossHp;

                                return LinearProgressIndicator(
                                  value: bossHp.toInt() / 500000,
                                  backgroundColor: Color(0xFFEFF3ED),
                                  valueColor: bossHp >= 250000 &&
                                          bossHp <= 500000
                                      ? const AlwaysStoppedAnimation<Color>(
                                          Colors.green)
                                      : bossHp >= 100000 && bossHp < 250000
                                          ? const AlwaysStoppedAnimation<Color>(
                                              Color.fromARGB(255, 221, 181, 36))
                                          : const AlwaysStoppedAnimation<Color>(
                                              Colors.red),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('user_info')
                                  .where('uid',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser?.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Text(
                                    "Loading...",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFEFF3ED),
                                    ),
                                  );
                                }
                                final database = context.watch<Database>();
                                final bossHp = database.bossHp;

                                return Text(
                                  "${bossHp.toInt().toString()} / 500000",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFEFF3ED),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) => damage(details),
              onTapUp: (TapUpDetails details) => hide(null),
              onTapCancel: () => hide(null),
            ),
            _gamepadConnected ? Container() : hitBox(),
          ],
        ),
      ),
    );
  }

  void initClock({int? add}) {
    if (controller == null) {
      durationBackup = duration;
    } else {
      Duration currentDuration = controller.duration! * controller.value;
      durationBackup = currentDuration.inMilliseconds;
      controller.stop();
    }

    // controller = null;
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: durationBackup! + add!));
    controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
    controller.addListener(() {
      setState(() {
        timerString;

        Duration duration = controller.duration! * controller.value;

        if (duration.inSeconds >= 0 && (duration.inSeconds % 60) > 20) {
          clockColor = const Color(0xFF67AC5B);
        }

        if (duration.inSeconds == 0 && (duration.inSeconds % 60) < 20) {
          clockColor = const Color(0xFFED6337);
        }

        if (duration.inSeconds == 0 && (duration.inSeconds % 60) < 10) {
          clockColor = const Color(0xFFCA3034);
        }
      });
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          gameOver = true;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget showGameOver() {
    if (gameOver) {
      return Stack(
        children: <Widget>[
          Container(
            color: Color(0xEE000000),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FancyButton(
                    size: width(context) / 10,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                      // Navigator.of(context).pushReplacement(Home());
                    },
                    child: Text(
                      "บอสยังชนะไม่ได้จะไปชนะใจเธอได้ยังไง",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width(context) / 12,
                        fontFamily: 'Gameplay',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: FancyButton(
                      size: width(context) / 20,
                      color: Color(0xFF67AC5B),
                      onPressed: share,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Text(
                          "SHARE TO HER",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width(context) / 25,
                            fontFamily: 'Gameplay',
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        child: Stack(
          children: <Widget>[
            gameEngine(context),
            showGameOver(),
          ],
        ),
      );
    });
  }
}
