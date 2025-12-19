import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:puzzle_hack/src/ui/global/controllers/theme_controller.dart';
import 'package:puzzle_hack/src/ui/global/widgets/my_icon_button.dart';
import 'package:puzzle_hack/src/ui/icons/puzzle_icons.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/winner_dialog.dart';
import 'package:puzzle_hack/src/ui/utils/colors.dart';
import 'package:puzzle_hack/src/ui/utils/dark_mode_extension.dart';
import 'package:provider/provider.dart';

const whiteFlutterLogoColorFilter = ColorFilter.matrix(
  [1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0],
);

class GameAppBar extends StatelessWidget {
  const GameAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - App title
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                gradient: isDarkMode ? darkGradient : lightGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: accentGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FlutterIcons.owl_mco,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Bird Puzzl',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: isDarkMode ? Colors.white : darkColor,
                    ),
                  ),
                ],
              ),
            ),
            // Right side - Theme toggle and test button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyIconButton(
                  onPressed: () {
                    showWinnerDialog(
                      context,
                      moves: 42,
                      time: 125,
                    );
                  },
                  iconData: Icons.emoji_events_rounded,
                ),
                const SizedBox(width: 8),
                Consumer<ThemeController>(
                  builder: (_, controller, __) => MyIconButton(
                    onPressed: controller.toggle,
                    iconData: controller.isDarkMode
                        ? PuzzleIcons.dark_mode
                        : PuzzleIcons.brightness,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
