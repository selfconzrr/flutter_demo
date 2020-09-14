import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_demo/langaw-game.dart';

class Backyard {
  final LangawGame game;
  Sprite bgSprite;
  Rect bgRect;

  Backyard(this.game) {
    bgSprite = Sprite('bg/backyard.png');

    // 图片宽度，1080
    bgRect = Rect.fromLTWH(
      0,
      game.screenSize.height - (game.tileSize * 23),
      game.tileSize * 9, // 9个区块
      game.tileSize * 23, // 1080/9 = 120, 2760/120 = 23
    );
  }

  void render(Canvas c) {
    bgSprite.renderRect(c, bgRect);
  }

  void update(double t) {}
}
