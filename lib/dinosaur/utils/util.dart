import 'dart:math';

double getRandomNum(double min, double max) =>
    (Random().nextDouble() * (max - min + 1)).floor() + min;
