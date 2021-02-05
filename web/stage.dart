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

  set rotation(num angle) => this
    ..init()
    ..rotate(angle);

  Cell(this.center, this.size,
      {this.origin, rotation = 0, this.color = "red"}) {
    origin ??= center;
    this.rotation = rotation;
  }

  init() {
    rotationAngle = 0;
    var halfSize = size / 2;
    points[topLeft] = Point(center.x - halfSize, center.y - halfSize);
    points[topRight] = Point(center.x + halfSize, center.y - halfSize);
    points[bottomRight] = Point(center.x + halfSize, center.y + halfSize);
    points[bottomLeft] = Point(center.x - halfSize, center.y + halfSize);
  }

  draw() {
    ctx
      ..fillStyle = color
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

/// Cells in Stage Cell list:
/// [1] [2] [3]
/// [4] [5] [6]
/// [7] [8] [9]

class Stage {
  static int offset = 5;
  static CanvasRenderingContext2D ctx;

  List<Cell> cells = List.filled(9, Cell(Point(0, 0), 100));
  Point center;
  num cellSize;

  Stage(this.center, this.cellSize) {
    var index = 0;
    for (var y = -1; y <= 1; y++) {
      for (var x = -1; x <= 1; x++) {
        cells[index++] = Cell(
            center +
                Point(x * cellSize + (x * offset), y * cellSize + (y * offset)),
            cellSize,
            origin: center);
      }
    }
  }

  draw() => cells.forEach((Cell cell) => cell.draw());

  rotate(num angle) => cells.forEach((Cell cell) => cell.rotate(angle));

  set rotation(num angle) =>
      cells.forEach((Cell cell) => cell.rotation = angle);
}
