import 'package:flutter_demo/housefly/components/fly.dart';
import 'package:flutter_demo/housefly/langaw-game.dart';

class FlySpawner {
  final int maxSpawnInterval = 3000; // 生成小飞蝇的间隔时间上限
  final int minSpawnInterval = 250; // 每次生成一个小飞蝇时, 都会减少currentInterval
  final int intervalChange = 3; // 每次生成小飞蝇时从currentInterval减少的数量
  // 因此, 从第3秒开始, 小飞蝇每次生成的速率就会越来越快, 最低至1/4秒.
  // 就算有总数限制, 当玩家达到了这一步, 屏幕上将会有好多小飞蝇.
  final int maxFliesOnScreen = 7; // 即使小飞蝇生成的速度极快, 但只要有7只小飞蝇还活着, 就不会生成更多.

  final LangawGame game;

  int currentInterval; // 用于保存下一次生成时从当前时间添加的时间的量
  int nextSpawn; // 表示下一次生成的实际时间(时间戳)

  FlySpawner(this.game) {
    start();
    game.spawnFly();
  }

  void start() {
    killAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAll() {
    game.flies.forEach((Fly fly) => fly.isDead = true);
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch; // 当前时间戳

    int livingFlies = 0;
    game.flies.forEach((Fly fly) {
      if (!fly.isDead) {
        livingFlies += 1;
      }
    });

    if (nowTimestamp >= nextSpawn && livingFlies < maxFliesOnScreen) {
      game.spawnFly();
      if (currentInterval > minSpawnInterval) {
        // 生成速度越来越快
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }
}
