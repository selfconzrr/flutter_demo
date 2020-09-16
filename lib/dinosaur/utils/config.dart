class GameConfig {
  static double minSpeed = 6.5;
  static double maxSpeed = 13.0;
  static double acceleration = 0.001;
}

class HorizonConfig {
  static double w = 2400 / 3;
  static double h = 38.0;
  static double y = 104.0;
  static double x = 2.0;
}

class CloudConfig {
  static double w = 92.0;
  static double h = 28.0;
  static double y = 2.0;
  static double x = 166.0;
}

class DinoConfig {
  static double jumpPos = -17;
  static double gravity = 0.7;
  static double h = 94.0;
  static double y = 2.0;
}

class DinoJumpConfig {
  static double w = 88.0;
  static double x = 1336.5;
}

class DinoWaitConfig {
  static double w = 88.0;
  static double x = 1336.5 + 88;
}

class DinoRunConfig {
  static double w = 87;
  final double x;

  const DinoRunConfig._internal({this.x});

  static List<DinoRunConfig> list = [
    DinoRunConfig._internal(x: 1338.5 + (88 * 2)),
    DinoRunConfig._internal(x: 1338.5 + (88 * 3)),
  ];
}

class DinoDieConfig {
  static double w = 88;
  static double x = 1338.5 + (88 * 4);
}

class DinoDownConfig {
  static double w = 118;
  final double x;

  const DinoDownConfig._internal({this.x});

  static List<DinoDownConfig> list = [
    DinoDownConfig._internal(x: 1866.0),
    DinoDownConfig._internal(x: 1866.0 + 118),
  ];
}

class ObstacleConfig {
  static double minDistance = 281;

  final double w;
  final double h;
  final double y;
  final double x;

  const ObstacleConfig._internal({
    this.w,
    this.h,
    this.y,
    this.x,
  });

  static List<ObstacleConfig> list = [
    ObstacleConfig._internal(w: 68, h: 70, y: 2, x: 446),
    ObstacleConfig._internal(w: 136, h: 70, y: 2, x: 514),
    ObstacleConfig._internal(w: 98, h: 100, y: 2, x: 752),
    ObstacleConfig._internal(w: 200, h: 100, y: 2, x: 752),
  ];
}

class ScoreConfig {
  static double w = 242 / 12;
  static double h = 21;
  static double y = 2.0;
  static double x = 952;
}
