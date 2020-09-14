import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_demo/components/fly.dart';
import 'package:flutter_demo/langaw-game.dart';

/// 丑蝇
class UglyFly extends Fly {
  double get speed => game.tileSize * 5; // 小飞蝇可以在9/5秒内横跨屏幕.

  UglyFly(LangawGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);

    flyingSprite = List();
    flyingSprite.add(Sprite('flies/ugly-fly-1.png'));
    flyingSprite.add(Sprite('flies/ugly-fly-2.png'));
    deadSprite = Sprite('flies/ugly-fly-dead.png');
  }
}
