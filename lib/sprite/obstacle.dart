import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/config.dart';
import 'package:flutter_demo/game.dart';
import 'package:flutter_demo/sprite/dino.dart';
import 'package:flutter_demo/util.dart';

class Obstacle extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  final ui.Image spriteImage;
  SpriteComponent lastComponent;
  ui.Size size;

  Obstacle(this.spriteImage, this.size);

  @override
  void update(double t) {}

  void clear() {
    components.clear();
    lastComponent = null;
  }

  void updateWithSpeed(double t, double speed) {
    double x = t * 50 * speed;
    //释放超出屏幕的
    for (final c in components) {
      final component = c as SpriteComponent;
      if (component.x + component.width < 0) {
        components.remove(component);
        continue;
      }
      component.x -= x;
    }
    //添加障碍
    if (lastComponent == null ||
        (lastComponent.x - lastComponent.width) < size.width) {
      //把游戏分成3个难度
      final double difficulty = (GameConfig.maxSpeed - GameConfig.minSpeed) / 3;
      speed = speed - GameConfig.minSpeed;
      double distance;

      int obstacleIndex; //随机创建障碍物

      if (speed <= difficulty) {
        //最小难度

        if (Random().nextInt(2) == 0) return; // 1/2几率不创建
        obstacleIndex = 2; //2种类型障碍物随机创建
        //障碍物距离在最小障碍物距离到3个屏幕宽度之间随机
        distance = getRandomNum(ObstacleConfig.minDistance, size.width * 3);
      } else if (speed <= difficulty * 2) {
        //普通难度

        if (Random().nextInt(20) == 0) return; // 1/20几率不创建
        obstacleIndex = 3;
        //障碍物距离在最小障碍物的距离到2个屏幕宽度之间随机
        distance = getRandomNum(ObstacleConfig.minDistance, size.width * 2);
      } else {
        // 最难

        if (Random().nextInt(60) == 0) return; // 1/60几率不创建
        obstacleIndex = 4;
        //障碍物距离在最小障碍物的距离到1个屏幕宽度之间随机
        distance = getRandomNum(ObstacleConfig.minDistance, size.width * 1);
      }

      double x = (lastComponent != null
              ? (lastComponent.x + lastComponent.width)
              : size.width) +
          distance;

      lastComponent = createComponent(x, obstacleIndex);
      add(lastComponent);
    }
  }

  SpriteComponent createComponent(double x, int obstacleIndex) {
    //随机创建障碍物
    final int index = Random().nextInt(obstacleIndex);
    final Sprite sprite = Sprite.fromImage(spriteImage,
        width: ObstacleConfig.list[index].w,
        height: ObstacleConfig.list[index].h,
        y: ObstacleConfig.list[index].y,
        x: ObstacleConfig.list[index].x);
    SpriteComponent component = SpriteComponent.fromSprite(
        ObstacleConfig.list[index].w, ObstacleConfig.list[index].h, sprite);
    component.x = x + ObstacleConfig.list[index].w;
    component.y =
        size.height - (HorizonConfig.h + ObstacleConfig.list[index].h - 22);
    return component;
  }

  Future<bool> hitTest(PositionComponent com1, DebugCallBack debugHit) async {
    int i = 0;
    for (final SpriteComponent com2 in components) {
      if (await HitHelp.checkHit(com1, com2, debugHit)) {
        return true;
      }
      //只检查最前面的两个
      i++;
      if (i >= 2) break;
    }
    return false;
  }
}

typedef DebugCallBack = void Function(ui.Image img1, ui.Image img2);

class HitHelp {
  static checkHit(PositionComponent com1, PositionComponent com2,
      [DebugCallBack debugCallBack]) async {
    final Rect rect1 = com1.toRect();
    final Rect rect2 = com2.toRect();

    //边碰到了, 判断像素是否碰到
    if (rect2.overlaps(rect1)) {
      //相交的矩形
      final Rect dst = Rect.fromLTRB(
          max(rect1.left, rect2.left),
          max(rect1.top, rect2.top),
          min(rect1.right, rect2.right),
          min(rect1.bottom, rect2.bottom));

      final ui.Image img1 = await getImg(com1, dst, rect1);
      final ui.Image img2 = await getImg(com2, dst, rect2);

      if (debugCallBack != null) {
        debugCallBack(img1, img2);
      }

      List<int> list1 = await imageToByteList(img1);
      List<int> list2 = await imageToByteList(img2);
      for (int i = 0; i < list1.length; i++) {
        //不透明的像素点是0
        if (list1[i] > 0 && list2[i] > 0) {
          return true;
        }
      }
    }
    return false;
  }

  static Future<ui.Image> getImg(
    PositionComponent component, Rect dst, Rect comDst) async {
    Sprite sprite;
    if (component is SpriteComponent) {
      sprite = component.sprite;
    } else if (component is AnimationComponent) {
      sprite = component.animation.getSprite();
    } else {
      return null;
    }
    //打开画布记录仪
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    //根据组件的相交位置绘制图片
    canvas.drawImageRect(
      sprite.image,
      Rect.fromLTWH(
        sprite.src.right - (comDst.right - dst.left),
        sprite.src.bottom - (comDst.bottom - dst.top),
        dst.width,
        dst.height),
      Rect.fromLTWH(
        0,
        0,
        dst.width,
        dst.height,
      ),
      Paint());
    //关闭记录
    final ui.Picture picture = recorder.endRecording();
    return picture.toImage(dst.width.ceil(), dst.height.ceil());
  }

  static Future<Uint8List> imageToByteList(ui.Image img) async {
    ByteData byteData = await img.toByteData();
    return byteData.buffer.asUint8List();
  }
}
