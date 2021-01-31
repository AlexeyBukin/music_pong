import 'game_timer.dart';
import 'package:meta/meta.dart';
/// execute() method should return bool value 'isCompleted'
// basic coroutine that never dies
abstract class Coroutine {

  static GameTimer gameTimer;

  bool Function() task = () => false;

  Coroutine({this.task});

  bool execute() => task();
}

class TimeoutCoroutine extends Coroutine {
  num creationTime;
  num timeout;

  TimeoutCoroutine(bool Function() task,  this.timeout)
      : super(task : task) {
    creationTime = Coroutine.gameTimer.currentTime;
  }

  @override
  bool execute() => (task() || Coroutine.gameTimer.isTimeout(creationTime + timeout));
}

class ValueCoroutine extends Coroutine {
  num creationTime;
  void Function(num) action;
  num speed = 0;
  num current = 0;
  num target = 0;
  bool isPositive;

  ValueCoroutine({@required this.action, this.target, this.speed, this.isPositive = true, bool Function() customTask = null}) {
    customTask ??= (isPositive ? valueTaskPositive : valueTaskNegative);
    task = customTask;
    if (isPositive == false) {
      target *= -1;
      speed *= -1;
    }
    creationTime = Coroutine.gameTimer.currentTime;
  }

  bool valueTaskPositive() {
    var valueDelta = speed * Coroutine.gameTimer.delta;
    action(valueDelta);
    current += valueDelta;
    if (current > target) {
      action(target - current);
      return true;
    }
    return false;
  }

  bool valueTaskNegative() {
    var valueDelta = speed * Coroutine.gameTimer.delta;
    action(valueDelta);
    current += valueDelta;
    if (current < target) {
      action(target - current);
      return true;
    }
    return false;
  }
}
