import 'dart:ui' as ui;

import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/game.dart';
import 'package:flutter_demo/langaw-game.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter 小游戏合集"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          children: <Widget>[
            // 恐龙按钮
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      child: Text("恐龙"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        run222(context);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 打苍蝇按钮
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      child: Text("打苍蝇"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        run111(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void run222(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    Flame.util
      ..fullScreen()
      ..setLandscape();
    ui.Image image = await Flame.images.load("sprite.png");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyGame(image).widget;
    }));
//    runApp(MyGame(image).widget);
  }

  void run111(BuildContext context) async {
    Util flameUtil = Util();
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.portraitUp);

    // 在游戏开始前加载所有的资源文件就可以了.
    // 这些资源文件将缓存在Flame的静态变量中, 便于我们后续重复使用
    Flame.images.loadAll(<String>[
      'bg/lose-splash.png',
      'branding/title.png',
      'flies/ugly-fly-1.png',
      'flies/ugly-fly-2.png',
      'flies/ugly-fly-dead.png',
      'flies/drooler-fly-1.png',
      'flies/drooler-fly-2.png',
      'flies/drooler-fly-dead.png',
      'flies/house-fly-1.png',
      'flies/house-fly-2.png',
      'flies/house-fly-dead.png',
      'flies/hungry-fly-1.png',
      'flies/hungry-fly-2.png',
      'flies/hungry-fly-dead.png',
      'flies/macho-fly-1.png',
      'flies/macho-fly-2.png',
      'flies/macho-fly-dead.png',
      'ui/dialog-credits.png',
      'ui/dialog-help.png',
      'ui/icon-credits.png',
      'ui/icon-help.png',
      'ui/start-button.png',
      'ui/callout.png',
      'ui/icon-music-disabled.png',
      'ui/icon-music-enabled.png',
      'ui/icon-sound-disabled.png',
      'ui/icon-sound-enabled.png',
    ]);

    Flame.audio.disableLog(); // 禁用debug日志，以免在控制台刷屏
    Flame.audio.loadAll([
      'bgm/home.mp3',
      'bgm/playing.mp3',
      'sfx/haha1.ogg',
      'sfx/haha2.ogg',
      'sfx/haha3.ogg',
      'sfx/haha4.ogg',
      'sfx/haha5.ogg',
      'sfx/ouch1.ogg',
      'sfx/ouch2.ogg',
      'sfx/ouch3.ogg',
      'sfx/ouch4.ogg',
      'sfx/ouch5.ogg',
      'sfx/ouch6.ogg',
      'sfx/ouch7.ogg',
      'sfx/ouch8.ogg',
      'sfx/ouch9.ogg',
      'sfx/ouch10.ogg',
      'sfx/ouch11.ogg',
    ]);

    SharedPreferences storage = await SharedPreferences.getInstance();

    LangawGame game = LangawGame(storage);
    TapGestureRecognizer tapper = TapGestureRecognizer();
    tapper.onTapDown = game.onTapDown;
    flameUtil.addGestureRecognizer(tapper);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return game.widget;
    }));
//    runApp(game.widget);
  }
}
