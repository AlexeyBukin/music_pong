import 'dart:html';
import 'dart:math';

class Cell {
  static CanvasRenderingContext2D ctx;

  Point topLeft, topRight, bottomRight, bottomLeft, center, origin;
  num rotation;

  Cell(this.center, num size, {this.origin, this.rotation = 0}) {
    origin ??= center;
    var halfsize = size / 2;
    topLeft = Point(center.x - halfsize, center.y - halfsize);
    topRight = Point(center.x + halfsize, center.y - halfsize);
    bottomRight = Point(center.x + halfsize, center.y + halfsize);
    bottomLeft = Point(center.x - halfsize, center.y + halfsize);
  }

  draw(String color) {

    ctx..fillStyle = color
      ..strokeStyle = "red";

    ctx.beginPath();
    ctx.moveTo(topLeft.x, topLeft.y);
    ctx.lineTo(topRight.x, topRight.y);
    ctx.lineTo(bottomRight.x, bottomRight.y);
    ctx.lineTo(bottomLeft.x, bottomLeft.y);
    ctx.fill();

    // var tx = x - size / 2;
    // var ty = y - size / 2;
    // ctx.translate(x, y);
    // ctx.rotate(rotation);
    //
    // ctx.fillRect(tx, ty, size, size);
    // ctx.rotate(-rotation);
    // ctx.translate(-x, -y);
  }
}
