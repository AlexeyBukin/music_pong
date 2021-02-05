import 'dart:math';

import 'stage.dart';

class Disk {
  Point center;
  num radius;

  Disk(this.center, this.radius);

  bool isIntersectingCell(Cell c) {
    if (this.isIntersectingLine(
        c.points[Cell.topLeft], c.points[Cell.topRight])) return true;
    if (this.isIntersectingLine(
        c.points[Cell.topLeft], c.points[Cell.topRight])) return true;
    if (this.isIntersectingLine(
        c.points[Cell.topLeft], c.points[Cell.topRight])) return true;
    if (this.isIntersectingLine(
        c.points[Cell.topLeft], c.points[Cell.topRight])) return true;
    if (this.isInsideCell(c)) return true;
    return false;
  }

  num _pointToLineDistance(Point p, Point a, Point b) {
    double l = (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
    double pr = (p.x - a.x) * (b.x - a.x) + (p.y - a.y) * (b.y - a.y);
    double cf = pr / l;
    cf = cf < 0 ? 0 : cf;
    cf = cf > 1 ? 1 : cf;
    double resX = a.x + cf * (b.x - a.x);
    double resY = a.y + cf * (b.y - a.y);
    return sqrt(resX * resX + resY * resY);
  }

  bool isIntersectingLine(Point a, Point b) {
    return (_pointToLineDistance(this.center, a, b) < this.radius);
  }

  num _sideSign(Point p1, Point p2, Point p3) {
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
  }

  bool _isPointInTriangle(Point pt, Point v1, Point v2, Point v3) {
    num d1, d2, d3;
    bool has_neg, has_pos;

    d1 = _sideSign(pt, v1, v2);
    d2 = _sideSign(pt, v2, v3);
    d3 = _sideSign(pt, v3, v1);

    has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    return !(has_neg && has_pos);
  }

  bool isInsideCell(Cell c) {
    if (_isPointInTriangle(this.center, c.points[0], c.points[1], c.points[2]))
      return true;
    if (_isPointInTriangle(this.center, c.points[0], c.points[2], c.points[3]))
      return true;
    return false;
  }
}
