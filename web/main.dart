import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'coroutine.dart';
import 'emitter.dart';
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
  List<Emitter> emitters = [];

  // List<Disc> discs = [];

  Game() {
    // print(canvas.width);
    // print(canvas.height);
    init();
  }

  void init() {
    Cell.ctx = ctx;
    timer = GameTimer(0);
    Coroutine.gameTimer = timer;
    // canvas.onMouseDown.listen(onMouseDown);
    // canvas.onMouseUp.listen(onMouseUp);

    window.onKeyDown.listen(onKeyDown);
    window.onKeyUp.listen(onKeyUp);
    stage = Stage(Point(canvas.width / 2, canvas.height - 200), 100);
    emitters.add(Emitter(Point(canvas.width / 2 - 105, 10), 100,
        Point(canvas.width / 2 - 105, canvas.height)));
    emitters.add(Emitter(Point(canvas.width / 2, 10), 100,
        Point(canvas.width / 2, canvas.height)));
    emitters.add(Emitter(Point(canvas.width / 2 + 105, 10), 100,
        Point(canvas.width / 2 + 105, canvas.height)));
  }

  Future run() async {
    while (true) update(await window.animationFrame);
  }

  bool isActiveArrowDown = false;
  int activeArrow = 0;

  // TODO refactor this shit
  void onKeyDown(KeyboardEvent event) {
    if (isActiveArrowDown || state != GameState.IDLE) return;
    if (event.keyCode == KeyCode.LEFT) {
      activeArrow = KeyCode.LEFT;
    } else if (event.keyCode == KeyCode.RIGHT) {
      activeArrow = KeyCode.RIGHT;
    } else {
      return;
    }
    isActiveArrowDown = true;
    startRotateCoroutine(event.keyCode == KeyCode.RIGHT);
  }

  void onKeyUp(KeyboardEvent event) {
    if (event.keyCode == activeArrow) isActiveArrowDown = false;
  }

  num rotationSpeed = 0.007;

  startRotateCoroutine(bool isRightSideRotation) {
    state = GameState.ROTATING_HALF;
    coroutines.add(
      ValueCoroutine(
        action: stage.rotate,
        target: (pi / 4),
        speed: rotationSpeed,
        isPositive: isRightSideRotation,
        onComplete: () {
          state = GameState.ROTATING_FULL;
          planned.add(
            Coroutine(task: () {
              return !isActiveArrowDown;
            }, onComplete: () {
              planned.add(
                ValueCoroutine(
                  action: stage.rotate,
                  target: (pi / 4),
                  speed: rotationSpeed,
                  isPositive: isRightSideRotation,
                  onComplete: () {
                    state = GameState.IDLE;
                  },
                ),
              );
            }),
          );
        },
      ),
    );
  }

  // bool isMouseDown = false;

  // onMouseUp(MouseEvent me) {
  //   isMouseDown = false;
  // }
  //
  // onMouseDown(MouseEvent me) {
  //   isMouseDown = true;
  //
  //   if (me.button != 0 || state != GameState.IDLE) return;
  //
  //   var rect = canvas.getBoundingClientRect();
  //   var x = me.client.x - rect.left;
  //
  //   state = GameState.ROTATING_HALF;
  // }

  List<Coroutine> coroutines = [];
  List<Coroutine> planned = [];

  // dart's animationFrame automatically lock 60 fps
  void update(num time) {
    timer.currentTime = time;

    // invoke coroutines
    // remove completed
    coroutines
      ..removeWhere((coroutine) => coroutine.execute())
      ..addAll(planned);
    planned.clear();

    // main draw section
    clear();
    // stage.rotate(0.01);
    emitters.forEach((emitter) => emitter.draw());
    stage.draw();
  }

  void clear() {
    ctx
      ..fillStyle = "rgb(220,220,220)"
      ..fillRect(0, 0, canvas.width, canvas.height);
  }
}
