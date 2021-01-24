import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:collection';
import 'stage.dart';

// typedef Coroutine = Pair<Function(num delta, Object o), dynamic>;
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

  Stage _stage;

  Game() {
    print(canvas.width);
    print(canvas.height);
    // canvas.width;
    // canvas.height;
    init();
  }

  void init() {
    Cell.ctx = ctx;
    canvas.onClick.listen(onMouseClick);
    _stage = Stage(Point(canvas.width / 2, canvas.height / 2), 100);
  }

  Future run() async {
    while (true)
      update(await window.animationFrame);
  }



  onMouseClick(MouseEvent me)
  {

    print("click me!");
  }

  // List<Function(Game g, num delta)> coroutines = [];

  void update(num delta) {
    final num diff = delta - _lastTimeStamp;

    if (diff > GAME_SPEED) {
      _lastTimeStamp = delta;

      // coroutines?.forEach((function) => function(this, _lastTimeStamp));


      clear();
      _stage.rotate(0.01);
      _stage.draw();
    }


  }

  void clear() {
    ctx..fillStyle = "rgb(220,220,220)"
      ..fillRect(0, 0, canvas.width, canvas.height);
  }
}
