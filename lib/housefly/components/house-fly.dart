import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_demo/housefly/components/fly.dart';
import 'package:flutter_demo/housefly/langaw-game.dart';

/// 家蝇
class HouseFly extends Fly {
  HouseFly(LangawGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);

    flyingSprite = List();
    flyingSprite.add(Sprite('flies/house-fly-1.png'));
    flyingSprite.add(Sprite('flies/house-fly-2.png'));
    deadSprite = Sprite('flies/house-fly-dead.png');
  }
}
