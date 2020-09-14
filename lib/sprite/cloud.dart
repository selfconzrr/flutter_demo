import 'dart:ui' as ui;

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_demo/config.dart';
import 'package:flutter_demo/util.dart';

class Cloud extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  final ui.Image spriteImage;
  SpriteComponent lastComponent;
  double maxY = 0;
  double minY = 5;
  ui.Size size;

  Cloud(this.spriteImage, this.size) {
    maxY = size.height - CloudConfig.h - HorizonConfig.h;
    init();
  }

  void init() {
    int count = 6;
    for (int i = 0; i < count; i++) {
      double x, y;
      y = getRandomNum(minY, maxY);
      x = (lastComponent != null ? lastComponent.x + CloudConfig.w : 0) +
          getRandomNum(1, size.width / 2);
      lastComponent = createComposer(x, y);
      add(lastComponent);
    }
  }

  SpriteComponent createComposer(double x, double y) {
    final Sprite sprite = Sprite.fromImage(spriteImage,
        width: CloudConfig.w,
        height: CloudConfig.h,
        y: CloudConfig.y,
        x: CloudConfig.x);
    SpriteComponent component =
        SpriteComponent.fromSprite(CloudConfig.w, CloudConfig.h, sprite);
    component.x = x;
    component.y = y;
    return component;
  }

  @override
  void update(double t) {}

  void updateWithSpeed(double t, double speed) {
    double x = t * 8 * speed;
    for (final c in components) {
      final component = c as SpriteComponent;
      if (component.x + CloudConfig.w < 0) {
        double lastX = lastComponent.x + CloudConfig.w;
        if (size.width > lastX) lastX = size.width;
        component.x = lastX + getRandomNum(1, size.width / 2);
        component.y = getRandomNum(minY, maxY);
        lastComponent = component;
        continue;
      }
      component.x -= x;
    }
  }
}
