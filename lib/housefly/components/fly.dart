import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_demo/housefly/components/callout.dart';
import 'package:flutter_demo/housefly/entity/view.dart';
import 'package:flutter_demo/housefly/langaw-game.dart';

class Fly {
  final LangawGame game;

  Rect flyRect;

  bool isDead = false;
  bool isOffScreen = false; // 清理超出屏幕的小飞鹰

  List flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;

  double get speed => game.tileSize * 3; // 小飞蝇可以在2秒内横跨屏幕.

  Offset targetLocation; // Offset 提供了好用的功能, 比如计算方向, 距离, 缩放等

  Callout callout;

  Fly(this.game) {
    setTargetLocation();
    callout = Callout(this);
  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, flyRect.inflate(flyRect.width / 2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()]
          .renderRect(c, flyRect.inflate(flyRect.width / 2));
      if (game.activeView == View.playing) {
        callout.render(c);
      }
    }
  }

  /// 假设由于某种原因, 游戏正在以每秒1帧的恒定完美速度运行, 因此时间增量的值恰好为1.
  /// 如果你打算以每秒10个区块的速度移动对象, 你可以将10倍(乘以区块大小的值)乘以1(时间增量的值)乘以(或减去)要移动对象的尺寸.
  /// 这将使你1秒移动10个区块.
  /// 12是作者随机得出的，可以改动这个数字使下降速度变快/慢. 6变慢
  void update(double t) {
    if (isDead) {
      flyRect = flyRect.translate(0, game.tileSize * 12 * t);
    } else {
      /// 我们尝试实现每秒拍动15次(15个动画周期). 由于每个周期有2帧动画, 所以每秒会显示30帧.
      /// 假设游戏以每秒60帧的速度运行. update()约每16.6毫秒(时间增量t的值)运行一次. flyingSpriteIndex的初始值为0.
      /// 对于第一帧, 30 * 0.0166将被添加到flyingSpriteIndex中. flyingSpriteIndex的值现在为0.498. 若对其运行.toInt(), 会被取整为0, 显示第一张图像.
      //
      //在第二帧上, flyingSpriteIndex又添加了30 * 0.0166, 使其值为0.996. 如果对此值进行.toInt(), 仍然会得到0, 将显示第一张图像.
      //
      //在第三帧上再加30 * 0.0166, 该值将变为1.494. 在此值上运行.toInt()将返回1, 显示第二个图像.
      //
      //当达到第四帧时, 再次加上30 * 0.0166, 该值将变为1.992. 进行.toInt()返回1, 因此仍显示第二张图像.
      //
      //到第五帧时, 再加上30 * 0.0166, 得到2.49.
      //
      //我们有一个if块, 当其值大于或等于2时, 重置flyingSpriteIndex值, 因为我们没有第三张图片(下标为2).
      //
      //我们现在的值为2.49.
      //
      //我们从中减2, 使其变为0.49, 该值.toInt()为0, 再次显示第一张图像.
      //
      //这种情况在两个帧之间重复循环, 速度为15次/秒.
      //
      // 此变量在渲染过程中被转换为int，见 render 函数
      flyingSpriteIndex += 30 * t;
      while (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }

      // 小飞蝇移动到目标点，然后重新生成随机目标点
      double stepDistance = speed * t; // 应该移动的距离
      Offset toTarget = targetLocation -
          Offset(flyRect.left,
              flyRect.top); // 计算从小飞蝇当前位置到目标位置的偏移量(120,70) - (50,50)

      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }

      callout.update(t);
    }

    // 判断是否飞出屏幕
    if (flyRect.top > game.screenSize.height) {
      isOffScreen = true;
    }
  }

  void onTapDown() {
    if (!isDead) {
      // 如果还没被打死
      isDead = true;

      if (game.activeView == View.playing) {
        game.score += 1; // 得分加1

        if (game.score > (game.storage.getInt("highscore") ?? 0)) {
          // 判断是否需要更新最高分
          game.storage.setInt("highscore", game.score);
          game.highscoreDisplay.updateHighscore();
        }
      }

      if (game.storage.getBool("soundenabled") ?? true) {
        // 判断是否关闭了音效
        Flame.audio
            .play('sfx/ouch' + (game.rnd.nextInt(11) + 1).toString() + '.ogg');
      }
    }
  }

  void setTargetLocation() {
    double x = game.rnd.nextDouble() *
        (game.screenSize.width - (game.tileSize * 1.35));
    double y = game.rnd.nextDouble() *
            (game.screenSize.height - (game.tileSize * 2.85)) +
        game.tileSize * 1.5;
    targetLocation = Offset(x, y);
  }

//  void setTargetLocation() {
//    double x = game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize * 2.025));
//    double y = game.rnd.nextDouble() * (game.screenSize.height - (game.tileSize * 2.025));
//    targetLocation = Offset(x, y);
//  }
}
