import 'package:flutter/material.dart';
import 'package:puzzle_hack/generated/l10n.dart';
import 'package:puzzle_hack/src/ui/global/widgets/max_text_scale_factor.dart';
import 'package:puzzle_hack/src/ui/icons/puzzle_icons.dart';
import 'package:puzzle_hack/src/ui/pages/game/controller/game_controller.dart';
import 'package:puzzle_hack/src/ui/utils/time_parser.dart';
import 'package:provider/provider.dart';

/// widget to show the time and the moves counter
class TimeAndMoves extends StatelessWidget {
  const TimeAndMoves({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const textStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
    );

    final time = Provider.of<GameController>(context, listen: false).time;
    return MaxTextScaleFactor(
      max: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 550,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      const Color(0xff003d5c).withOpacity(0.6),
                      const Color(0xff002942).withOpacity(0.4),
                    ]
                  : [
                      Colors.white.withOpacity(0.9),
                      const Color(0xfff5f5f5).withOpacity(0.8),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: ValueListenableBuilder<int>(
                  valueListenable: time,
                  builder: (_, time, icon) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xff42a5f5).withOpacity(0.15),
                            const Color(0xff2196f3).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xff2196f3).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: icon!,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              parseTime(time),
                              style: textStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(
                    PuzzleIcons.watch,
                    size: 20,
                    color: Color(0xff2196f3),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Selector<GameController, int>(
                  builder: (_, moves, icon) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xffFF6B6B).withOpacity(0.15),
                            const Color(0xffEE5A6F).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xffFF6B6B).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: icon!,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              "$moves ${S.current.movements}",
                              style: textStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  selector: (_, controller) => controller.state.moves,
                  child: const Icon(
                    Icons.multiple_stop_rounded,
                    size: 20,
                    color: Color(0xffFF6B6B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
