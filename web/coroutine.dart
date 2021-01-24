import 'dart:html';
import 'game_timer.dart';

/// execute() method should return bool value 'isCompleted'
// basic coroutine that never dies
class Coroutine {
  bool Function() task = () => false;
  
  Coroutine(this.task);
  
  bool execute() => task();
}

class TimeoutCoroutine extends Coroutine {
  GameTimer gameTimer;
  num creationTime;
  num timeout;
  
  TimeoutCoroutine(bool Function() task, this.gameTimer, this.timeout)
      : super(task) { creationTime = gameTimer.currentTime; }

  @override
  bool execute() => (task() || gameTimer.isTimeout(creationTime + timeout));
}
