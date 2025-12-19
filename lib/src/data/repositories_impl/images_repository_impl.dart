import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:puzzle_hack/src/domain/models/puzzle_image.dart';
import 'package:puzzle_hack/src/domain/repositories/images_repository.dart';

const puzzleOptions = <PuzzleImage>[
PuzzleImage(
    name: 'Budgie',
    assetPath: 'assets/animals/budgie.png',
    soundPath: 'assets/sounds/budgie.mp3',
  ),
  PuzzleImage(
    name: 'Cockatiel',
    assetPath: 'assets/animals/cockatiel.png',
    soundPath: 'assets/sounds/cockatiel.mp3',
  ),
  PuzzleImage(
    name: 'Lovebird',
    assetPath: 'assets/animals/lovebird.png',
    soundPath: 'assets/sounds/lovebird.mp3',
  ),
  PuzzleImage(
    name: 'Canary',
    assetPath: 'assets/animals/canary.png',
    soundPath: 'assets/sounds/canary.mp3',
  ),
  PuzzleImage(
    name: 'Finch',
    assetPath: 'assets/animals/finch.png',
    soundPath: 'assets/sounds/finch.mp3',
  ),
  PuzzleImage(
    name: 'African Grey',
    assetPath: 'assets/animals/africangrey.png',
    soundPath: 'assets/sounds/africangrey.mp3',
  ),
  PuzzleImage(
    name: 'Macaw',
    assetPath: 'assets/animals/macaw.png',
    soundPath: 'assets/sounds/macaw.mp3',
  ),
  PuzzleImage(
    name: 'Cockatoo',
    assetPath: 'assets/animals/cockatoo.png',
    soundPath: 'assets/sounds/cockatoo.mp3',
  ),
  PuzzleImage(
    name: 'Conure',
    assetPath: 'assets/animals/conure.png',
    soundPath: 'assets/sounds/conure.mp3',
  ),
  PuzzleImage(
    name: 'Parakeet',
    assetPath: 'assets/animals/parakeet.png',
    soundPath: 'assets/sounds/parakeet.mp3',
  ),
];

Future<Image> decodeAsset(ByteData bytes) async {
  return decodeImage(
    bytes.buffer.asUint8List(),
  )!;
}

class SPlitData {
  final Image image;
  final int crossAxisCount;

  SPlitData(this.image, this.crossAxisCount);
}

Future<List<Uint8List>> splitImage(SPlitData data) {
  final image = data.image;
  final crossAxisCount = data.crossAxisCount;
  final int length = (image.width / crossAxisCount).round();
  List<Uint8List> pieceList = [];

  for (int y = 0; y < crossAxisCount; y++) {
    for (int x = 0; x < crossAxisCount; x++) {
      pieceList.add(
        Uint8List.fromList(
          encodePng(
            copyCrop(
              image,
              x: x * length,
              y: y * length,
              width: length,
              height: length,
            ),
          ),
        ),
      );
    }
  }
  return Future.value(pieceList);
}

class ImagesRepositoryImpl implements ImagesRepository {
  Map<String, Image> cache = {};

  @override
  Future<List<Uint8List>> split(String asset, int crossAxisCount) async {
    late Image image;
    if (cache.containsKey(asset)) {
      image = cache[asset]!;
    } else {
      final bytes = await rootBundle.load(asset);

      /// use compute because theimage package is a pure dart package
      /// so to avoid bad ui performance we do this task in a different
      /// isolate
      image = await compute(decodeAsset, bytes);

      final width = math.min(image.width, image.height);

      /// convert to square
      image = copyResizeCropSquare(image, size: width);
      cache[asset] = image;
    }

    final pieces = await compute(
      splitImage,
      SPlitData(image, crossAxisCount),
    );

    return pieces;
  }
}
