import 'dart:html';
import 'dart:math';

class Cell {
  static const int topLeft = 0;
  static const int topRight = 1;
  static const int bottomRight = 2;
  static const int bottomLeft = 3;

  static CanvasRenderingContext2D ctx;

  Point center, origin;
  List<Point> points = List.filled(4, Point(0, 0));
  String color;
  num rotationAngle = 0, size;

  set rotation(num angle) => this..init()..rotate(angle);

  Cell(this.center, this.size, {this.origin, rotation = 0, this.color = "red"}) {
    origin ??= center;
    this.rotation = rotation;
  }

  init() {
    rotationAngle = 0;
    var halfsize = size / 2;
    points[topLeft] = Point(center.x - halfsize, center.y - halfsize);
    points[topRight] = Point(center.x + halfsize, center.y - halfsize);
    points[bottomRight] = Point(center.x + halfsize, center.y + halfsize);
    points[bottomLeft] = Point(center.x - halfsize, center.y + halfsize);
  }

  draw() {
    ctx..fillStyle = color
      ..strokeStyle = color;
    ctx.beginPath();
    ctx.moveTo(points[topLeft].x, points[topLeft].y);
    ctx.lineTo(points[topRight].x, points[topRight].y);
    ctx.lineTo(points[bottomRight].x, points[bottomRight].y);
    ctx.lineTo(points[bottomLeft].x, points[bottomLeft].y);
    ctx.fill();
  }

  rotate(num angle) {
    rotationAngle += angle;
    var s = sin(angle);
    var c = cos(angle);
    points = points.map((Point point) {
      point -= origin;
      point = Point(point.x * c - point.y * s, point.x * s + point.y * c);
      return point + origin;
    }).toList();
  }
}
