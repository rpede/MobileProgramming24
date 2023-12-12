import 'dart:math' as math;

class Point {
  final num x;
  final num y;
  const Point(this.x, this.y);

  @override
  String toString() {
    return "$runtimeType($x, $y)";
  }
}

const Point origin = Point(0, 0);

class Line {
  Point a;
  Point b;
  Line({required this.a, required this.b});

  double calculateLength() {
    return math.sqrt(math.pow(b.x - a.x, 2) + math.pow(b.y - a.y, 2));
  }
}

extension PointExtensions on Point {
  Line to(Point other) {
    return Line(a: this, b: other);
  }
}

abstract class Shape {
  Point center;
  Shape({required this.center});
  bool includes(Point point);
}

class Circle extends Shape {
  num radius;
  Circle({required super.center, required this.radius});

  // A = πr2
  get area => math.pow(radius, 2) * math.pi;

  @override
  bool includes(Point point) {
    final distance = center.to(point).calculateLength();
    return distance < radius;
  }

  @override
  String toString() {
    return "$runtimeType(center: $center, radius: $radius)";
  }
}
