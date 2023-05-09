import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home.dart';
import 'button.dart';
import 'dart:async';
import 'scroll.dart';
import 'utils.dart';

import 'route.dart';
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

  static const MethodChannel _channel = const MethodChannel('gamepad');

  static String skyAsset() => "assets/background/sky.png";
  static var multiplier = 1.0;
  static var damageDefault = 980.0;
  static var damageBar = damageDefault;

  static var damageUser = 30.0;
  static var addedDuration = 1000 * 10;

  var coins = 0;

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

  Color clockColor = Color(0xFF67AC5B);

  var _gamepadConnected = false;

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );

    // initClock(add: 0);
    onEarnTime = () {
      initClock(add: addedDuration);
    };
    damageBar = bosses[bossIndex].life.toDouble() * multiplier;

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

  void damage(TapDownDetails? details) {
    setState(() {
      if (details != null) {
        xAxis = details.globalPosition.dx - 40.0;
        yAxis = details.globalPosition.dy - 80.0;
      }

      tap = true;

      if (damageBar - damageUser <= 0) {
        damageBar = damageBar - damageUser;
        coins = coins + 20;
        multiplier =
            (bossIndex + 1 >= bosses.length) ? multiplier * 1.25 : multiplier;
        level = (bossIndex + 1 >= bosses.length) ? ++level : level;
        addedDuration =
            (bossIndex + 1 >= bosses.length) ? 1000 * 20 : 1000 * 10;
        bossIndex = (bossIndex + 1 >= bosses.length) ? 0 : ++bossIndex;
        damageBar = bosses[bossIndex].life.toDouble() * multiplier;

        onEarnTime.call();
        print("Next Boss");
        // if (!Utils.isDesktop()) {
        //   coinCache.play(AssetSource('audio/coin.mp3'));
        // }
      } else {
        damageBar = damageBar - damageUser * 100;
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

  Widget coinVisibility(bool bought) {
    if (bought) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Image.asset(
          "assets/elements/coin.png",
          width: 13,
          height: 13,
        ),
      );
    }
  }

  Widget hitBox() {
    if (tap) {
      return Positioned(
        top: yAxis,
        left: xAxis,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Material(
                color: Colors.transparent,
                child: StrokeText(
                  "-${damageUser.toInt().toString()}",
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
                padding: const EdgeInsets.only(bottom: 80.0),
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
                padding: EdgeInsets.only(bottom: 50.0),
                child: Image.asset(
                  hero(),
                  height: width(context) / 6 < 160 ? width(context) / 6 : 160,
                  fit: BoxFit.fill,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 20, right: 15),
                          child: Stack(children: <Widget>[
                            FancyButton(
                              size: 20,
                              color: Color(0xFFEFF3ED),
                              child: Text(
                                "      $timerString",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontFamily: "Gameplay",
                                ),
                              ),
                            ),
                            FancyButton(
                              size: 20,
                              color: clockColor,
                              child: const Icon(
                                Icons.watch_later,
                                color: Colors.black54,
                                size: 20,
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "${bosses[bossIndex].name}  LV$level",
                          style: Utils.textStyle(15.0),
                        ),
                      ),
                      FancyButton(
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                        child: Text(
                          "HP :  ${damageBar.toInt().toString()}",
                          style: Utils.textStyle(18.0),
                        ),
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
          clockColor = Color(0xFF67AC5B);
        }

        if (duration.inSeconds == 0 && (duration.inSeconds % 60) < 20) {
          clockColor = Color(0xFFED6337);
        }

        if (duration.inSeconds == 0 && (duration.inSeconds % 60) < 10) {
          clockColor = Color(0xFFCA3034);
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
    // if (!Utils.isDesktop()) {
    //   if (musicPlaying && instance != null) {
    //     instance.stop();
    //     musicPlaying = false;
    //   }
    // }
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
