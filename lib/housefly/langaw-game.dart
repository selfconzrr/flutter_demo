import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_demo/housefly/components/agile-fly.dart';
import 'package:flutter_demo/housefly/components/backyard.dart';
import 'package:flutter_demo/housefly/components/credits-button.dart';
import 'package:flutter_demo/housefly/components/drooler-fly.dart';
import 'package:flutter_demo/housefly/components/fly.dart';
import 'package:flutter_demo/housefly/components/help-button.dart';
import 'package:flutter_demo/housefly/components/highscore-display.dart';
import 'package:flutter_demo/housefly/components/house-fly.dart';
import 'package:flutter_demo/housefly/components/hungry-fly.dart';
import 'package:flutter_demo/housefly/components/macho-fly.dart';
import 'package:flutter_demo/housefly/components/score-display.dart';
import 'package:flutter_demo/housefly/components/sound-button.dart';
import 'package:flutter_demo/housefly/components/start-button.dart';
import 'package:flutter_demo/housefly/controllers/spawner.dart';
import 'package:flutter_demo/housefly/entity/view.dart';
import 'package:flutter_demo/housefly/views/credits-view.dart';
import 'package:flutter_demo/housefly/views/help-view.dart';
import 'package:flutter_demo/housefly/views/home-view.dart';
import 'package:flutter_demo/housefly/views/lost-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangawGame extends Game {
  final SharedPreferences storage;

  View activeView = View.home;

  HomeView homeView;
  LostView lostView;
  HelpView helpView;
  CreditsView creditsView;

  StartButton startButton;
  HelpButton helpButton;
  CreditsButton creditsButton;

  ScoreDisplay scoreDisplay;

  HighscoreDisplay highscoreDisplay;

  SoundButton soundButton;

  AudioPlayer homeBGM = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  AudioPlayer playingBGM = new AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  Backyard backyard;

  FlySpawner spawner;

  Size screenSize;
  double tileSize; // 区块宽度，等于屏幕宽度除以9
  List<Fly> flies;
  Random rnd;

  int score;

  // 标记为 final 的任何实例变量必须在声明时具有初始值, 否则必须通过构造函数将其传递给它.
  LangawGame(this.storage) {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    resize(await Flame.util.initialDimensions());
    rnd = new Random();
    homeView = HomeView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);
    startButton = StartButton(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    backyard = Backyard(this);
    spawner = FlySpawner(this);
    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);
    soundButton = SoundButton(this);

    score = 0;

//    homeBGM = await Flame.audio.loop('bgm/home.mp3', volume: .25); // 避免盖住其他声音
//    homeBGM.pause();
//    playingBGM = await Flame.audio.loop('bgm/playing.mp3', volume: .25);
//    playingBGM.pause();

    playHomeBGM();
  }

  void playHomeBGM() {
//    playingBGM.pause();
//    playingBGM.seek(Duration.zero);
//    homeBGM.resume();
  }

  void playPlayingBGM() {
//    homeBGM.pause();
//    homeBGM.seek(Duration.zero);
//    playingBGM.resume();
  }

  void render(Canvas canvas) {
    backyard.render(canvas);

    highscoreDisplay.render(canvas);

    if (activeView == View.playing) {
      scoreDisplay.render(canvas);
    }

    flies.forEach((Fly fly) => fly.render(canvas));

    if (activeView == View.home) {
      homeView.render(canvas);
    }

    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }

    if (activeView == View.lost) {
      lostView.render(canvas);
    }

    soundButton.render(canvas);

    if (activeView == View.help) {
      helpView.render(canvas);
    }

    if (activeView == View.credits) {
//      creditsView.render(canvas);
    }
  }

  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));

    flies.removeWhere((Fly fly) => fly.isOffScreen);

    spawner.update(t);

    if (activeView == View.playing) {
      scoreDisplay.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;

    // 弹窗
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }

    // 音乐按钮
//    if (!isHandled && musicButton.rect.contains(d.globalPosition)) {
//      musicButton.onTapDown();
//      isHandled = true;
//    }

    // 音效按钮
    if (!isHandled && soundButton.rect.contains(d.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
    }

    // 开始按钮
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    // 教程按钮
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

    // 感谢按钮
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }

    if (!isHandled) {
      bool didHitAFly = false;

      flies.forEach((Fly fly) {
        if (fly.flyRect.contains(d.globalPosition) &&
            activeView == View.playing) {
          fly.onTapDown();
          isHandled = true;
          didHitAFly = true;
        }
      });

      if (activeView == View.playing && !didHitAFly) {
        if (storage.getBool("soundenabled") ?? true) {
          Flame.audio
              .play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
        }
        playHomeBGM();
        activeView = View.lost;
      }
    }
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize * 2.025);
    double y = rnd.nextDouble() * (screenSize.height - tileSize * 2.025);

    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(UglyFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }
}
