import 'package:flutter/material.dart';
import 'package:puzzle_hack/generated/l10n.dart';
import 'package:puzzle_hack/src/ui/global/widgets/my_text_icon_button.dart';
import 'package:puzzle_hack/src/ui/pages/game/controller/game_controller.dart';
import 'package:puzzle_hack/src/ui/pages/game/controller/game_state.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/confirm_dialog.dart';
import 'package:puzzle_hack/src/ui/utils/responsive.dart';
import 'package:provider/provider.dart';

class GameButtons extends StatelessWidget {
  const GameButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final state = controller.state;
    final responsive = Responsive.of(context);
    final buttonHeight =
        responsive.dp(3).clamp(kMinInteractiveDimension, 100).toDouble();

    return Padding(
      padding: const EdgeInsets.all(10).copyWith(
        bottom: 20,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: MyTextIconButton(
            height: buttonHeight + 10,
            onPressed: () => _reset(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.replay_rounded,
                size: 24,
              ),
            ),
            label: state.status == GameStatus.created
                ? S.current.start
                : S.current.restart,
          ),
        ),
      ),
    );
  }

  Future<void> _reset(BuildContext context) async {
    final controller = context.read<GameController>();
    final state = controller.state;
    if (state.moves == 0 || state.status == GameStatus.solved) {
      controller.shuffle();
    } else {
      final isOk = await showConfirmDialog(context);
      if (isOk) {
        controller.shuffle();
      }
    }
  }
}
