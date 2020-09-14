import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_demo/config.dart';

enum DinoStatus {
  waiting,
  running,
  jumping,
  downing,
  die,
}
class Dino extends Component{

  double gravity = DinoConfig.gravity;
  ui.Size size;
  DinoStatus status = DinoStatus.waiting;
  List<PositionComponent> actualDinoList = List(5);
  double maxY;
  double x,y;
  double startPos;
  bool isJump = false;
  bool isDown = false;
  double jumpVelocity = 0.0;
  double speed;

  Dino(ui.Image spriteImage, this.size) {
    final double height = DinoConfig.h;
    final double yPos = DinoConfig.y;
    startPos = size.width/8;

    maxY = size.height - (HorizonConfig.h + height - 22);
    x = 0;
    y = maxY;

    //waiting
    actualDinoList[0] = SpriteComponent.fromSprite(
        DinoWaitConfig.w,
        height,
        Sprite.fromImage(spriteImage,
            x: DinoWaitConfig.x,
            y: yPos,
            width: DinoWaitConfig.w,
            height: height))
      ..x=x..y=y;

    //running
    List<Sprite> runSpriteList = [];
    DinoRunConfig.list.forEach((DinoRunConfig config){
      runSpriteList.add(Sprite.fromImage(spriteImage,
          x: config.x,
          y: yPos,
          width: DinoRunConfig.w,
          height: height),
      );
    });
    actualDinoList[1] = AnimationComponent(
        DinoRunConfig.w,
        height,
        Animation.spriteList(runSpriteList, stepTime: 0.1, loop: true))
      ..x=x..y=y;


    //jumping
    actualDinoList[2] = SpriteComponent.fromSprite(
        DinoJumpConfig.w,
        height,
        Sprite.fromImage(spriteImage,
            x: DinoJumpConfig.x,
            y: yPos,
            width: DinoJumpConfig.w,
            height: height))
      ..x=x..y=y;

    //downing
    List<Sprite> downSpriteList = [];
    DinoDownConfig.list.forEach((DinoDownConfig config){
      downSpriteList.add(Sprite.fromImage(spriteImage,
          x: config.x,
          y: yPos,
          width: DinoDownConfig.w,
          height: height),
      );
    });
    actualDinoList[3] = AnimationComponent(
        DinoDownConfig.w,
        height,
        Animation.spriteList(downSpriteList, stepTime: 0.1, loop: true))
      ..x=x..y=y;

    //die
    actualDinoList[4] = SpriteComponent.fromSprite(
        DinoDieConfig.w,
        height,
        Sprite.fromImage(spriteImage,
            x: DinoDieConfig.x,
            y: yPos,
            width: DinoDieConfig.w,
            height: height))
      ..x=x..y=y;
  }

  PositionComponent get actualDino => actualDinoList[status.index];

  void startPlay() {
    status = DinoStatus.running;
    x = 0;
    y = maxY;
    gravity = 0.76;
  }

  void jump(bool isOn) {
    if(status == DinoStatus.running && isOn){
      status = DinoStatus.jumping;
      jumpVelocity = DinoConfig.jumpPos - (speed / 10);
      gravity = DinoConfig.gravity * (speed / GameConfig.minSpeed);
      isJump = true;
      return;
    }
    isJump = false;
  }

  void down(bool isOn){
    isDown = isOn;
    if(status == DinoStatus.running && isOn){
      status = DinoStatus.downing;
      return;
    }
    if(status == DinoStatus.downing && !isOn){
      status = DinoStatus.running;
      return;
    }
  }

  void die(){
    //蹲着die了, 处理下die状态的位置
    if(status == DinoStatus.downing){
      x = x + (DinoDownConfig.w - DinoDieConfig.w);
      status = DinoStatus.die;
      return;
    }
    status = DinoStatus.die;
  }

  @override
  void update(double t) {}

  void updateWithSpeed(double t, double speed){
    this.speed = speed;
    if (status == DinoStatus.running && x < startPos) {
      x += t*50*speed;
    }
    if (status == DinoStatus.jumping) {
      y += jumpVelocity;
      jumpVelocity += gravity;
      if(y > maxY){
        status = DinoStatus.running;
        y = maxY;
        //一直按住,不断跳
        jump(isJump);
        //跳的过程中按了蹲，角色落地时蹲下
        down(isDown);
      }
    }
    actualDino.update(t);
  }

  @override
  void render(ui.Canvas c) {
    actualDino..x=x..y=y;
    actualDino.render(c);
  }

}
