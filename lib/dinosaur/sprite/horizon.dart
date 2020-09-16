import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_demo/dinosaur/utils/config.dart';

class Horizon extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  final ui.Image spriteImage;
  SpriteComponent lastComponent;
  ui.Size size;

  Horizon(this.spriteImage, this.size) {
    init();
  }

  void init() {
    double x = 0;
    int count = (size.width / HorizonConfig.w).ceil() + 1;
    for (int i = 0; i < count; i++) {
      lastComponent = createComposer(x);
      x += HorizonConfig.w;
      add(lastComponent);
    }
  }

  SpriteComponent createComposer(double x) {
    final Sprite sprite = Sprite.fromImage(spriteImage,
        width: HorizonConfig.w,
        height: HorizonConfig.h,
        y: HorizonConfig.y,
        x: HorizonConfig.w * (Random().nextInt(3)) + HorizonConfig.x);
    SpriteComponent horizon =
        SpriteComponent.fromSprite(HorizonConfig.w, HorizonConfig.h, sprite);
    horizon.y = size.height - HorizonConfig.h;
    horizon.x = x;
    return horizon;
  }

  @override
  void update(double t) {}

  void updateWithSpeed(double t, double speed) {
    double x = t * 50 * speed;
    for (final c in components) {
      final component = c as SpriteComponent;
      // 释放前面超出屏幕的地图, 再重新添加一个在后面
      if (component.x + HorizonConfig.w < 0) {
        components.remove(component);
        SpriteComponent horizon =
            createComposer(lastComponent.x + HorizonConfig.w);
        add(horizon);
        lastComponent = horizon;
        continue;
      }
      component.x -= x;
    }
  }
}
