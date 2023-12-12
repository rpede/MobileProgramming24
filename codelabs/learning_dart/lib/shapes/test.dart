import "./solution.dart";
import "../mock_result.dart";

const _result = result;

void main() {
  final circle0 = Circle(center: Point(0, 0), radius: 5);
  _result((circle0.area - 78.54).abs() < 0.01, ["Area of $circle0 is ~78.54"]);

  final circle1 = Circle(center: Point(1, 1), radius: 6);
  final point1 = Point(4, 5);
  _result(circle1.includes(point1), ["$point1 is inside $circle1"]);

  final circle2 = Circle(center: Point(1, 1), radius: 6);
  final point2 = Point(5, 6);
  _result(!circle2.includes(point2), ["$point2 is outside $circle2"]);
}
