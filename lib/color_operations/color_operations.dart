import "package:image/image.dart";
import 'dart:math';

num abs(num number){
  return number > 0 ? number : - number;
}

class colorOperations extends Color {
  static final RGB_SUM = 765;
  static double compareRGB(int c1, int c2){
    return (abs(getRed(c1)-getRed(c2))+
            abs(getGreen(c1)-getGreen(c2))+
            abs(getGreen(c1) - getGreen(c2)))/RGB_SUM;
  }
  static int avgRGB(int c1, int c2){
    return Color.fromRgb(
      (getRed(c1)-getRed(c2))~/2,
      (getGreen(c1)-getGreen(c2))~/2,
      (getBlue(c1)-getBlue(c2))~/2);
  }
}