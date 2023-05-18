import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:checkmate/pages/authentication/signin.dart';
import 'package:checkmate/pages/main/Banpage.dart';
import 'package:checkmate/pages/main/task_page.dart';
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
  static const MethodChannel _channel = MethodChannel('gamepad');

  static String skyAsset() => "assets/background/sky.png";
  static var addedDuration = 1000 * 10;
  bool showText = true;
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

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showText = false;
        onEarnTime.call();
      });
    });
// Delayed update to hide the text

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

  int totalDamage = 0;
  void damage(TapDownDetails? details) async {
    setState(() {
      if (details != null) {
        xAxis = details.globalPosition.dx - 40.0;
        yAxis = details.globalPosition.dy - 80.0;
      }
      tap = true;
    });

    final userCollection = FirebaseFirestore.instance.collection('user_info');
    final querySnapshot = await userCollection
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    // Variable to store the total damage

    querySnapshot.docs.forEach((doc) async {
      final userDamage = database.userDamage;
      final damageUser = userDamage;
      final rewardpoints = doc.data()['points'] + 1000;
      final HackDamage = doc.data()['UserDamage'];
      if (doc.data()['BossHp'] - damageUser <= 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Congratulation!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              content: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style:
                      TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
                  children: <TextSpan>[
                    TextSpan(text: "You Defeated The Boss\n"),
                    TextSpan(
                      text: "You Earned 1000 Points\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(241, 91, 91, 1)),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Home(
                                sindex: 0,
                              )),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        await doc.reference.update({'points': rewardpoints});
        await doc.reference.update({'BossHp': 0});
      } else {
        print(HackDamage);
        if (HackDamage >= 5000) {
          print("Hack Detected");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BanPage()),
          );
          await doc.reference.update({'BanStatus': 1});
        }
        totalDamage += damageUser;
        await doc.reference
            .update({'BossHp': doc.data()['BossHp'] - damageUser});
      }
    });
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
              padding: EdgeInsets.only(bottom: 10.0),
              child: Material(
                color: Colors.transparent,
                child: StrokeText(
                  "Hit!",
                  fontSize: 10.0,
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
                                final bossHp = snapshot.data!.docs.first
                                        .data()['BossHp'] as int? ??
                                    0;

                                return LinearProgressIndicator(
                                  value: bossHp.toInt() / 150000,
                                  backgroundColor: const Color(0xFFEFF3ED),
                                  valueColor: bossHp >= 75000 &&
                                          bossHp <= 150000
                                      ? const AlwaysStoppedAnimation<Color>(
                                          Colors.green)
                                      : bossHp >= 35000 && bossHp < 75000
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
                                final bossHp = snapshot.data!.docs.first
                                        .data()['BossHp'] as int? ??
                                    0;

                                return Text(
                                  "$bossHp / 150000",
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
              onTap: () {
                setState(() {
                  tap = true;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    tap = false;
                  });
                });
              },
              child: Align(
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
                    color: tap ? const Color(0x80FFFFFF) : null,
                  ),
                ),
              ),
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

  void updateTotalDamageToFirebase() async {
    int currentPoints = 0;
    final userCollection = FirebaseFirestore.instance.collection('user_info');
    final querySnapshot = await userCollection
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    querySnapshot.docs.forEach((doc) async {
      currentPoints = doc.data()['points'] ?? 0;
      int pointsToAdd =
          (totalDamage / 100).round(); // Calculate the points to add
      int newPoints = currentPoints + pointsToAdd;
      await doc.reference.update({'points': newPoints});
      showGameOver(pointsToAdd);
    });
  }

  Widget showGameOver(int pointsToAdd) {
    if (gameOver) {
      return Positioned.fill(
        child: Container(
          color: const Color.fromARGB(0, 224, 224, 221),
          child: AlertDialog(
            title: const Text("Congratulation!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            content: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                    color: Colors.black, fontSize: 16, height: 1.5),
                children: <TextSpan>[
                  TextSpan(text: "Damage to boss: $totalDamage\n"),
                  TextSpan(
                    text: "+ $pointsToAdd Points",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(241, 91, 91, 1)),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  updateTotalDamageToFirebase();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Home(
                              sindex: 0,
                            )),
                  );
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        child: Container(
          color: const Color.fromARGB(
              255, 44, 41, 41), // Set your desired background color here
          child: Material(
            child: Stack(
              children: <Widget>[
                gameEngine(context),
                if (gameOver) showGameOver((totalDamage / 100).round()),

                // Show text if `showText` is true
                if (showText)
                  Overlay(
                    initialEntries: [
                      OverlayEntry(
                        builder: (context) {
                          return Container(
                            color: Colors.black.withOpacity(
                                0.5), // Set your desired background color here
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Tap the boss to deal damage!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white, // Set your desired text color here
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          10), // Add some spacing between texts
                                  Text(
                                    'Game will start in 5 seconds',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors
                                          .white, // Set your desired text color here
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
