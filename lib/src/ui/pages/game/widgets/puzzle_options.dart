import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle_hack/src/data/repositories_impl/images_repository_impl.dart';
import 'package:puzzle_hack/src/ui/pages/game/controller/game_controller.dart';
import 'package:puzzle_hack/src/ui/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../utils/dark_mode_extension.dart';

/// widget to show a horizontal pageview with the posible
/// images for the puzzle
class PuzzleOptions extends StatefulWidget {
  final double width;
  const PuzzleOptions({Key? key, required this.width}) : super(key: key);

  @override
  State<PuzzleOptions> createState() => _PuzzleOptionsState();
}

class _PuzzleOptionsState extends State<PuzzleOptions>
    with AutomaticKeepAliveClientMixin {
  late PageController _pageController;

  int _page = 0;

  @override
  void initState() {
    super.initState();

    _setViewportFraction();

    // Set Budgie as default on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<GameController>();
      if (controller.state.puzzle.image == null) {
        controller.changeGrid(
          controller.state.crossAxisCount,
          puzzleOptions[0], // Budgie is at index 0
        );
      }
    });
  }

  void _setViewportFraction() {
    double viewportFraction = 0.5;
    if (widget.width >= 400 && widget.width < 600) {
      viewportFraction = 0.4;
    } else if (widget.width >= 600) {
      viewportFraction = 0.2;
    }

    _pageController = PageController(
      viewportFraction: viewportFraction,
    );
  }

  @override
  void didUpdateWidget(covariant PuzzleOptions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.width != widget.width) {
      _setViewportFraction();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final isDarkMode = context.isDarkMode;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: NotificationListener(
            onNotification: (t) {
              if (t is ScrollEndNotification) {
                if (_page != _pageController.page) {
                  _page = _pageController.page!.round();
                  final image = puzzleOptions[_page];
                  final controller = context.read<GameController>();
                  controller.changeGrid(
                    controller.state.crossAxisCount,
                    image.name != 'Numeric' ? image : null,
                  );

                  // Sound removed - now controlled by music bar play button
                }
              }
              return true;
            },
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              itemBuilder: (_, index) {
                final item = puzzleOptions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 15.0),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    scale: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isDarkMode ? darkGradient : lightGradient,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              Colors.white.withOpacity(isDarkMode ? 0.15 : 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(isDarkMode ? 0.4 : 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white
                                    .withOpacity(isDarkMode ? 0.05 : 0.8),
                                Colors.white
                                    .withOpacity(isDarkMode ? 0.02 : 0.6),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              item.assetPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: puzzleOptions.length,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 255, 0, 0).withOpacity(0.30),
            ),
            child: Transform.rotate(
              angle: 90 * pi / 180,
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 36,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
