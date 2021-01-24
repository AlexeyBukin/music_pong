import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:collection';
import 'stage.dart';

const int CELL_SIZE = 10;

CanvasElement canvas;
CanvasRenderingContext2D ctx;
Keyboard keyboard = new Keyboard();

void main() {
  canvas = querySelector('#canvas')..focus();
  ctx = canvas.getContext('2d');

  new Game()..run();
}

void drawCell(Point coords, String color) {
  ctx..fillStyle = color
    ..strokeStyle = "white";

  final int x = coords.x * CELL_SIZE;
  final int y = coords.y * CELL_SIZE;

  ctx..fillRect(x, y, CELL_SIZE, CELL_SIZE)
    ..strokeRect(x, y, CELL_SIZE, CELL_SIZE);
}

void clear() {
  ctx..fillStyle = "white"
    ..fillRect(0, 0, canvas.width, canvas.height);
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
      _cell.draw("red");
    }
  }
}
