import 'package:checkmate/pages/main/video_items.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BanPage extends StatefulWidget {
  const BanPage({Key? key}) : super(key: key);

  @override
  State<BanPage> createState() => BanPageState();
}

class BanPageState extends State<BanPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    const videoPath = 'assets/audio/banvideoflutter.mp4';
    _videoPlayerController = VideoPlayerController.asset(videoPath);
    await _videoPlayerController.initialize();
    setState(() {}); // Update the state after video initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ListView(
            children: <Widget>[
              VideoItems(
                videoPlayerController: VideoPlayerController.asset(
                  'assets/audio/banvideoflutter.mp4',
                ),
                looping: true,
                autoplay: true,
              ),
            ],
          ),
          const Positioned(
            top: 20.0,
            child: Text(
              'Are you kidding me?',
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Positioned(
            top: 55.0,
            child: Text(
              'It just planner app, why you have to be mad',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Positioned(
            top: 80.0,
            child: Text(
              'on GameChallenge?',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
