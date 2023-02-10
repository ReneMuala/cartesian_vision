import 'dart:math';

import 'package:image/image.dart';
import 'package:cartesian_vision/color_operations/color_operations.dart';

class BasicPixel {
  int color;
  Point point;
  @override
  String toString() => "color: $color point: $point";
  BasicPixel({required this.color, required this.point});
}

class Fragment {
  int baseColor;
  late List<BasicPixel> pixels;
  late Point min, max;

  int get width => max.xi - min.xi;
  int get height => max.yi - min.yi;

  Fragment({required this.baseColor}) {
    pixels = List.empty(growable: true);
    min = max = Point(0, 0);
  }

  bool contains(num x, num y) {
    bool found = false;
    pixels.forEach((pixel) {
      if (!found && pixel.point.x == y && pixel.point.y == y) found = true;
    });
    return found;
  }

  void _expand(BasicPixel entryPixel, double tolerance, Image source) {
    List<Point> fragmentExpansionPoints = List.empty(growable: true);
    fragmentExpansionPoints.add(entryPixel.point);
    Point currentPoint;
    int currentColor, x, y;
    // track fragments min and max points
    min = Point.from(entryPixel.point);
    max = Point.from(entryPixel.point);
    while (!fragmentExpansionPoints.isEmpty) {
      currentPoint = fragmentExpansionPoints.removeLast();
      if (currentPoint.x > -1 &&
          currentPoint.y > -1 &&
          currentPoint.x < source.width &&
          currentPoint.y < source.height) {
        x = currentPoint.xi;
        y = currentPoint.yi;
        currentColor = source.getPixel(x, y);
        if (getAlpha(currentColor) > 0 &&
            colorOperations.compareRGB(entryPixel.color, currentColor) <=
                tolerance) {
          pixels.add(BasicPixel(color: currentColor, point: currentPoint));
          source.setPixel(x, y, 0);
          fragmentExpansionPoints.add(Point(x, y - 1));
          fragmentExpansionPoints.add(Point(x, y + 1));
          fragmentExpansionPoints.add(Point(x - 1, y));
          fragmentExpansionPoints.add(Point(x + 1, y));

          // fragments min and max points
          if (x < min.x) min.x = x;
          if (y < min.y) min.y = y;
          if (x > max.x) max.x = x;
          if (y > max.y) max.y = y;
        }
      }
    }
  }

  static BasicPixel? getNextOpaquePoint({required Image source}) {
    for (var y = 0; y < source.height; y++) {
      for (var x = 0; x < source.width; x++) {
        var color = source.getPixel(x, y);
        if (getAlpha(color) > 0) {
          return BasicPixel(color: color, point: Point(x, y));
        }
      }
    }
    return null;
  }

  static List<Fragment> generateFragments(
      {required Image polarizedSource, double tolerance = 0.2}) {
    List<Fragment> Fragments = List.empty(growable: true);
    BasicPixel? nextPixel;
    while ((nextPixel = getNextOpaquePoint(source: polarizedSource)) != null) {
      Fragment fragment = Fragment(baseColor: nextPixel!.color);
      fragment._expand(nextPixel, tolerance, polarizedSource);
      Fragments.add(fragment);
    }

    return Fragments;
  }
}
