import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'coroutine.dart';
import 'stage.dart';
import 'game_timer.dart';

CanvasElement canvas;
CanvasRenderingContext2D ctx;

void main() {
  canvas = querySelector('#canvas')..focus();
  ctx = canvas.getContext('2d');
  new Game().run();
}
enum GameState {
  IDLE,
  ROTATING_HALF,
  ROTATING_FULL,
}

class Game {
  GameState state = GameState.IDLE;
  GameTimer timer;
  Stage stage;

  Game() {
    // print(canvas.width);
    // print(canvas.height);
    init();
  }

  void init() {
    Cell.ctx = ctx;
    timer = GameTimer(0);
    Coroutine.gameTimer = timer;
    canvas.onMouseDown.listen(onMouseDown);
    canvas.onMouseUp.listen(onMouseUp);
    stage = Stage(Point(canvas.width / 2, canvas.height / 2), 100);
  }

  Future run() async {
    while (true)
      update(await window.animationFrame);
  }

  bool isMouseDown = false;

  onMouseUp(MouseEvent me){isMouseDown = false;}

  //TODO implement State Machine
  onMouseDown(MouseEvent me)
  {
    isMouseDown = true;

    if (me.button != 0 || state != GameState.IDLE)
      return ;

    var rect = canvas.getBoundingClientRect();
    var x = me.client.x - rect.left;

    state = GameState.ROTATING_HALF;
    addPlannedRotate45() {

    }
    coroutines.add(
      ValueCoroutine(
        action: stage.rotate,
        target: (pi / 4),
        speed: 0.002,
        isPositive: (x >= canvas.width / 2),
        onComplete: () {
          state = GameState.ROTATING_FULL;
          planned.add(
              Coroutine(
                  task: (){return !isMouseDown;},
                  onComplete: () {
                    planned.add(
                        ValueCoroutine(
                          action: stage.rotate,
                          target: (pi / 4),
                          speed: 0.002,
                          isPositive: (x >= canvas.width / 2),
                          onComplete: () { state = GameState.IDLE; },
                    )
                );
              })
          );
        },
      )
    );
  }

  List<Coroutine> coroutines = [];
  List<Coroutine> planned = [];

  // dart's animationFrame automatically lock 60 fps
  void update(num time) {
    timer.currentTime = time;

    // invoke coroutines
    // remove completed
    coroutines..removeWhere((coroutine) => coroutine.execute())..addAll(planned);
    planned.clear();

    // main draw section
    clear();
    // stage.rotate(0.01);
    stage.draw();
  }

  void clear() {
    ctx..fillStyle = "rgb(220,220,220)"
      ..fillRect(0, 0, canvas.width, canvas.height);
  }
}
