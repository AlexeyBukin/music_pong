import 'dart:html';
import 'dart:math';
import 'stage.dart';

class Emitter extends Cell {
  static const int rayTip = 4;
  Point rayTipOffset;
  String rayColor;

  @override
  List<Point> points = List.filled(5, Point(0, 0));

  Emitter(Point eCenter, num eSize, this.rayTipOffset, {this.rayColor})
      : super(eCenter, eSize) {
    rayColor ??= 'black';
  }

  @override
  init() {
    super.init();
    points[rayTip] = rayTipOffset;
  }

  @override
  draw() {
    Cell.ctx
      ..fillStyle = rayColor
      ..strokeStyle = rayColor
      ..lineWidth = 10;
    Cell.ctx.beginPath();
    Cell.ctx.moveTo(center.x, center.y);
    Cell.ctx.lineTo(points[rayTip].x, points[rayTip].y);
    Cell.ctx.stroke();
    super.draw();
  }
}

// class Disc {
//
//   Point position = Point(0, 0);
//   Point direction = Point(1, 1);
//   num radius = 5;
//
//   Disc(this.position, this.direction, this.radius);
//
//   draw() {
//     Cell.ctx.beginPath();
//     Cell.ctx.arc(position.x, position.y, radius, 0, pi);
//     Cell.ctx.fill();
//   }
// }
