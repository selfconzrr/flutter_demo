import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_demo/housefly/components/fly.dart';
import 'package:flutter_demo/housefly/langaw-game.dart';

/// 口水蝇
class DroolerFly extends Fly {
  DroolerFly(LangawGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);

    flyingSprite = List();
    flyingSprite.add(Sprite('flies/drooler-fly-1.png'));
    flyingSprite.add(Sprite('flies/drooler-fly-2.png'));
    deadSprite = Sprite('flies/drooler-fly-dead.png');
  }
}
