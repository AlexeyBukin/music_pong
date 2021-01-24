import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:collection';
import 'stage.dart';

const int CELL_SIZE = 10;

CanvasElement canvas;
CanvasRenderingContext2D ctx;

void main() {
  canvas = querySelector('#canvas')..focus();
  ctx = canvas.getContext('2d');
  new Game().run();
}

class Game {
  // smaller numbers make the game run faster
  static const num GAME_SPEED = 50;

  num _lastTimeStamp = 0;

  Cell _cell;

  Game() {
    // canvas.width;
    // canvas.height;
    init();
  }

  void init() {
    Cell.ctx = ctx;
    _cell = new Cell(Point(100, 100), 100, rotation : (pi / 180 * 45));
  }

  Future run() async {
    while (true)
      update(await window.animationFrame);
  }

  void update(num delta) {
    final num diff = delta - _lastTimeStamp;

    if (diff > GAME_SPEED) {
      _lastTimeStamp = delta;
      clear();
      _cell.rotate(0.01);
      _cell.draw();
    }
  }

  void clear() {
    ctx..fillStyle = "white"
      ..fillRect(0, 0, canvas.width, canvas.height);
  }
}
