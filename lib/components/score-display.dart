import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter_demo/langaw-game.dart';

class ScoreDisplay {
  final LangawGame game;

  TextPainter painter; // 渲染分数值
  TextStyle textStyle;
  Offset position;

  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 90,
      shadows: [
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position); // position告诉painter在哪里绘制分数
  }

  // update函数实际上发生在渲染之前
  void update(double t) {
    if ((painter.text?.text ?? '') != game.score.toString()) { // 运算符是??.. 若左侧不为null, 返回左侧表达式; 若为null, 返回右侧表达式.
      painter.text = TextSpan(
        text: game.score.toString(),
        style: textStyle,
      );

      // layout函数, 以便TextPainter可以计算刚刚分配的新文本的尺寸
      painter.layout();

      position = Offset(
        (game.screenSize.width / 2) - (painter.width / 2),
        (game.screenSize.height * .25) - (painter.height / 2),
      );
    }
  }
}
