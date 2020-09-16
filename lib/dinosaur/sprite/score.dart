import 'dart:ui' as ui;

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_demo/dinosaur/utils/config.dart';

class Score extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  final ui.Image spriteImage;
  List<String> scores;
  ui.Size size;
  int _score;

  Score(this.spriteImage, this.size) {
    updateWithScore(0); // 默认分数
  }

  void updateWithScore(int score) {
    if (this._score == score) return;
    components.clear();
    scores = score.toString().split('');
    double x = 2;
    double y = 2;
    add(createComponent(10, x, y));
    x += ScoreConfig.w;
    add(createComponent(11, x, y));
    scores.forEach((String score) {
      x += ScoreConfig.w;
      add(createComponent(int.parse(score), x, y));
    });
  }

  SpriteComponent createComponent(int score, double x, double y) {
    return SpriteComponent.fromSprite(
        ScoreConfig.w,
        ScoreConfig.h,
        Sprite.fromImage(spriteImage,
            width: ScoreConfig.w,
            height: ScoreConfig.h,
            y: ScoreConfig.y,
            x: ScoreConfig.x + (ScoreConfig.w * score)))
      ..x = x
      ..y = y;
  }
}
