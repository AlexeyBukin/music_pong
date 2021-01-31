import 'game_timer.dart';
import 'package:meta/meta.dart';
/// execute() method should return bool value 'isCompleted'
// basic coroutine that never dies
class Coroutine {

  static GameTimer gameTimer;

  void Function() onComplete = () {};
  bool Function() task = () => false;

  Coroutine({this.task, this.onComplete});

  bool execute() {
    if (task() == true) {
      onComplete(); return true;
    }
    return false;
  }
}

// class TimeoutCoroutine extends Coroutine {
//   num creationTime;
//   num timeout;
//
//   TimeoutCoroutine(bool Function() task,  this.timeout)
//       : super(task : task) {
//     creationTime = Coroutine.gameTimer.currentTime;
//   }
//
//   @override
//   bool execute() => (task() || Coroutine.gameTimer.isTimeout(creationTime + timeout));
// }
void doNothing(num a){}

class ValueCoroutine extends Coroutine {
  num creationTime;
  void Function(num) action;
  num speed = 0;
  num current = 0;
  num target = 0;
  bool isPositive;

  ValueCoroutine({this.action = null, this.target,
    this.speed, num start = 0, this.isPositive = true, bool Function() customTask = null,
    void Function() onComplete}) {
    current = start;
    action ??= doNothing;
    customTask ??= valueTask;//(isPositive ? valueTaskPositive : valueTaskNegative);
    if (onComplete != null)
      super.onComplete = onComplete;
    task = customTask;
    if (isPositive == false) {
      target *= -1;
      speed *= -1;
    }
    creationTime = Coroutine.gameTimer.currentTime;
  }

  bool valueTask() {
    var valueDelta = speed * Coroutine.gameTimer.delta;
    action(valueDelta);
    current += valueDelta;
    if ((isPositive && current > target) || (!isPositive && current < target)) {
      action(target - current);
      return true;
    }
    return false;
  }
}
