import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_demo/housefly/langaw-game.dart';

class MusicButton {
  final LangawGame game;
  Rect rect;
  Sprite enabledSprite;
  Sprite disabledSprite;
  bool isEnabled = true;

  MusicButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * .25,
      game.tileSize * .25,
      game.tileSize,
      game.tileSize,
    );
    enabledSprite = Sprite('ui/icon-music-enabled.png');
    disabledSprite = Sprite('ui/icon-music-disabled.png');
  }

  void render(Canvas c) {
    if (isEnabled) {
      enabledSprite.renderRect(c, rect);
    } else {
      disabledSprite.renderRect(c, rect);
    }
  }

  void onTapDown() {
    print(isEnabled);
    if (isEnabled) {
      isEnabled = false;
//      int res = await game.homeBGM.setVolume(0);
//      int res1 = await game.playingBGM.setVolume(0);
    } else {
      isEnabled = true;
//      game.homeBGM.setVolume(.25);
//      game.playingBGM.setVolume(.25);
    }
  }
}
