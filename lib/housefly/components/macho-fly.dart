import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_demo/housefly/components/fly.dart';
import 'package:flutter_demo/housefly/langaw-game.dart';

/// 肌肉蝇
class MachoFly extends Fly {
  double get speed => game.tileSize * 2; // 小飞蝇可以在4.5秒内横跨屏幕.

  MachoFly(LangawGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1.35, game.tileSize * 1.35);
    flyingSprite = List();
    flyingSprite.add(Sprite('flies/macho-fly-1.png'));
    flyingSprite.add(Sprite('flies/macho-fly-2.png'));
    deadSprite = Sprite('flies/macho-fly-dead.png');
  }
}
