import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_demo/housefly/components/fly.dart';
import 'package:flutter_demo/housefly/langaw-game.dart';

/// 饥饿蝇
class HungryFly extends Fly {
  double get speed => game.tileSize * 1; // 小飞蝇可以在9秒内横跨屏幕.

  HungryFly(LangawGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1.1, game.tileSize * 1.1);

    flyingSprite = List();
    flyingSprite.add(Sprite('flies/hungry-fly-1.png'));
    flyingSprite.add(Sprite('flies/hungry-fly-2.png'));
    deadSprite = Sprite('flies/hungry-fly-dead.png');
  }
}
