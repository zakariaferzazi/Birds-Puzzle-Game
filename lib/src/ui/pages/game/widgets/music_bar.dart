import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:puzzle_hack/src/ui/pages/game/controller/game_controller.dart';
import 'package:puzzle_hack/src/ui/utils/colors.dart';
import 'package:puzzle_hack/src/ui/utils/dark_mode_extension.dart';
import 'package:provider/provider.dart';

class MusicBar extends StatefulWidget {
  const MusicBar({Key? key}) : super(key: key);

  @override
  State<MusicBar> createState() => _MusicBarState();
}

class _MusicBarState extends State<MusicBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isPlaying = false;
  String? _currentBirdName;
  StreamSubscription? _audioSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _setupAudioListener();
  }

  void _setupAudioListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<GameController>();
      final audioRepo = controller.audioRepository as dynamic;

      _audioSubscription = audioRepo.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _animationController.stop();
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _audioSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _checkBirdChange(GameController controller) async {
    final currentImage = controller.puzzle.image;
    final birdName = currentImage?.name;

    // If bird changed, stop playing
    if (_currentBirdName != birdName && _isPlaying) {
      final audioRepo = controller.audioRepository as dynamic;
      setState(() {
        _isPlaying = false;
        _animationController.stop();
      });
      if (audioRepo.stop != null) {
        await audioRepo.stop();
      }
    }
    _currentBirdName = birdName;
  }

  void _togglePlayPause(GameController controller) async {
    final currentImage = controller.puzzle.image;
    final audioRepo = controller.audioRepository as dynamic;

    if (_isPlaying) {
      // Stop the sound
      setState(() {
        _isPlaying = false;
        _animationController.stop();
      });
      if (audioRepo.stop != null) {
        await audioRepo.stop();
      }
    } else {
      // Play the bird sound if available
      if (currentImage != null && currentImage.name != 'Numeric') {
        setState(() {
          _isPlaying = true;
          _animationController.repeat();
        });
        await controller.audioRepository.play(currentImage.soundPath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    final controller = context.watch<GameController>();
    final currentImage = controller.puzzle.image;
    final birdName = currentImage?.name ?? 'No Bird Selected';

    // Check if bird changed and stop playing if needed
    _checkBirdChange(controller);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xff2e7d32).withOpacity(0.6),
                  const Color(0xff1b5e20).withOpacity(0.4),
                ]
              : [
                  Colors.white.withOpacity(0.9),
                  const Color(0xffe8f5e9).withOpacity(0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(isDarkMode ? 0.1 : 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bird Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: accentGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: acentColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: currentImage != null
                ? ClipOval(
                    child: Image.asset(
                      currentImage.assetPath,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.flutter_dash,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          const SizedBox(width: 16),
          // Bird Name and Sound Wave
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  birdName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : darkColor,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Bird Sound',
                      style: TextStyle(
                        fontSize: 13,
                        color: (isDarkMode ? Colors.white : darkColor)
                            .withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_isPlaying)
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                15,
                                (index) {
                                  final height = 3.0 +
                                      (12.0 *
                                          (0.5 +
                                              0.5 *
                                                  (((_animationController.value *
                                                                          15 +
                                                                      index) %
                                                                  15) /
                                                              7.5 -
                                                          1)
                                                      .abs()));
                                  return Container(
                                    width: 3,
                                    height: height,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          acentColor.withOpacity(0.8),
                                          acentColor,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Play/Stop Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _togglePlayPause(controller),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: accentGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: acentColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
