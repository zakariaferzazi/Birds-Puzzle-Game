import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_hack/src/ui/pages/game/game_view.dart';
import 'package:puzzle_hack/src/ui/utils/ad_manager.dart';
import 'package:video_player/video_player.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _setDeviceOrientation();
  }

  void _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/video/video.mp4');

    try {
      await _controller.initialize();
      setState(() {
        _isVideoInitialized = true;
      });
      _controller.setVolume(1.0);
      _controller.play();

      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          _goToGame();
        }
      });
    } catch (e) {
      debugPrint('Error loading video: $e');
      // If video fails to load, navigate after a delay
      Timer(const Duration(seconds: 2), _goToGame);
    }
  }

  void _goToGame() {
    if (!mounted) return;
    AdManager().showAppOpenAd();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GameView()),
    );
  }

  void _setDeviceOrientation() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        var shortestSide = MediaQuery.of(context).size.shortestSide;
        final bool useMobileLayout = shortestSide < 600;
        if (useMobileLayout) {
          SystemChrome.setPreferredOrientations(
            [
              DeviceOrientation.portraitDown,
              DeviceOrientation.portraitUp,
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isVideoInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}
