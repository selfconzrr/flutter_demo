import 'dart:ui' as ui;

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/config.dart';
import 'package:flutter_demo/sprite/cloud.dart';
import 'package:flutter_demo/sprite/dino.dart';
import 'package:flutter_demo/sprite/horizon.dart';
import 'package:flutter_demo/sprite/obstacle.dart';
import 'package:flutter_demo/sprite/score.dart';

class MyGame extends BaseGame with TapDetector, HasWidgetsOverlay {
  double currentSpeed;

  GameBg gameBg;
  Horizon horizon;
  Cloud cloud;
  Obstacle obstacle;
  Dino dino;
  Score scoreCom;
  ui.Image spriteImage;
  bool isPlay = false;
  int score = 0;

  MyGame(this.spriteImage) {
    currentSpeed = GameConfig.minSpeed;
  }

  Widget createButton(
      {@required IconData icon,
      double right = 0,
      double bottom = 0,
      ValueChanged<bool> onHighlightChanged}) {
    return Positioned(
      right: right,
      bottom: bottom,
      child: MaterialButton(
        onHighlightChanged: onHighlightChanged,
        onPressed: () {},
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          width: 50,
          height: 50,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(50)),
            //设置四周边框
            border: new Border.all(width: 2, color: Colors.black),
          ),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void debugHit(ui.Image img1, ui.Image img2) {
    addWidgetOverlay(
        'a1',
        Positioned(
          right: 100,
          top: 0,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blueGrey,
            child: RawImage(image: img1, fit: BoxFit.fill),
          ),
        ));

    addWidgetOverlay(
        'a2',
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.brown,
            child: RawImage(image: img2, fit: BoxFit.fill),
          ),
        ));
  }

  void onTap() {
    if (size == null) return;
    if (components.isEmpty) {
      gameBg = GameBg();
      horizon = Horizon(spriteImage, size);
      cloud = Cloud(spriteImage, size);
      obstacle = Obstacle(spriteImage, size);
      dino = Dino(spriteImage, size);
      scoreCom = Score(spriteImage, size);
      this
        ..add(gameBg)
        ..add(horizon)
        ..add(cloud)
        ..add(dino)
        ..add(obstacle)
        ..add(scoreCom)
        ..addWidgetOverlay(
            'upButton',
            createButton(
              icon: Icons.arrow_drop_up,
              right: 50,
              bottom: 120,
              onHighlightChanged: (isOn) => dino?.jump(isOn),
            ))
        ..addWidgetOverlay(
            'downButton',
            createButton(
              icon: Icons.arrow_drop_down,
              right: 50,
              bottom: 50,
              onHighlightChanged: (isOn) => dino?.down(isOn),
            ));
    }
    if (!isPlay) {
      isPlay = true;
      currentSpeed = GameConfig.minSpeed;
      score = 0;
      obstacle.clear();
      dino.startPlay();
    }
  }

  @override
  void update(double t) async {
    if (size == null) return;
    if (isPlay) {
      horizon.updateWithSpeed(t, currentSpeed);
      obstacle.updateWithSpeed(t, currentSpeed);
      cloud.updateWithSpeed(t, currentSpeed);
      dino.updateWithSpeed(t, currentSpeed);
      score++;
      scoreCom.updateWithScore(score);
      if (currentSpeed <= GameConfig.maxSpeed) {
        currentSpeed += GameConfig.acceleration;
      }
      if (await obstacle.hitTest(dino.actualDino, this.debugHit)) {
        dino.die();
        isPlay = false;
      }
    }
  }
}

class GameBg extends Component with Resizable {
  Color bgColor;

  GameBg([this.bgColor = Colors.white]);

  @override
  void render(Canvas canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint bgPaint = Paint();
    bgPaint.color = bgColor;
    canvas.drawRect(bgRect, bgPaint);
  }

  @override
  void update(double t) {}
}
