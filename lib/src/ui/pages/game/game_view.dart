import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzle_hack/src/domain/models/move_to.dart';
import 'package:puzzle_hack/src/ui/pages/game/controller/game_controller.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/background.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/game_app_bar.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/game_buttons.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/puzzle_interactor.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/puzzle_options.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/music_bar.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/time_and_moves.dart';
import 'package:puzzle_hack/src/ui/pages/game/widgets/winner_dialog.dart';
import 'package:puzzle_hack/src/ui/utils/ad_manager.dart';
import 'package:puzzle_hack/src/ui/utils/responsive.dart';
import 'package:provider/provider.dart';

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  Timer? _adTimer;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _startInterstitialTimer();
  }

  void _startInterstitialTimer() {
    _adTimer = Timer.periodic(const Duration(seconds: 90), (timer) {
      AdManager().showInterstitialAd();
    });
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _adTimer?.cancel();
    super.dispose();
  }

  void _onKeyBoardEvent(BuildContext context, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final moveTo = event.logicalKey.keyLabel.moveTo;
      if (moveTo != null) {
        context.read<GameController>().onMoveByKeyboard(moveTo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final width = responsive.width;
    return ChangeNotifierProvider(
      create: (_) {
        final controller = GameController();
        controller.onFinish.listen(
          (_) {
            Timer(
              const Duration(
                milliseconds: 200,
              ),
              () {
                AdManager().showInterstitialAd();
                showWinnerDialog(
                  context,
                  moves: controller.state.moves,
                  time: controller.time.value,
                );
              },
            );
          },
        );
        return controller;
      },
      builder: (context, child) => RawKeyboardListener(
        autofocus: true,
        includeSemantics: false,
        focusNode: FocusNode(),
        onKey: (event) => _onKeyBoardEvent(context, event),
        child: child!,
      ),
      child: GameBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: OrientationBuilder(
              builder: (_, orientation) {
                final isPortrait = orientation == Orientation.portrait;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const GameAppBar(),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          final height = constraints.maxHeight;
                          final puzzleHeight =
                              (isPortrait ? height * 0.45 : height * 0.5)
                                  .clamp(250, 700)
                                  .toDouble();
                          final optionsHeight =
                              (isPortrait ? height * 0.25 : height * 0.2)
                                  .clamp(120, 200)
                                  .toDouble();

                          return SizedBox(
                            height: height,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: optionsHeight,
                                    child: RepaintBoundary(
                                      child: PuzzleOptions(
                                        width: width,
                                      ),
                                    ),
                                  ),
                                  const MusicBar(),
                                  const SizedBox(height: 8),
                                  if (_isBannerAdReady)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      width: _bannerAd!.size.width.toDouble(),
                                      height: _bannerAd!.size.height.toDouble(),
                                      child: AdWidget(ad: _bannerAd!),
                                    ),
                                  const SizedBox(height: 8),
                                  const TimeAndMoves(),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Hero(
                                      tag: 'puzzle',
                                      transitionOnUserGestures: true,
                                      child: SizedBox(
                                        height: puzzleHeight,
                                        child: const AspectRatio(
                                          aspectRatio: 1,
                                          child: RepaintBoundary(
                                            child: PuzzleInteractor(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const GameButtons(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
