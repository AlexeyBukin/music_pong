import 'game_timer.dart';

/// execute() method should return bool value 'isCompleted'
// basic coroutine that never dies
abstract class Coroutine {

  static GameTimer gameTimer;

  bool Function() task = () => false;

  Coroutine(this.task);

  bool execute() => task();
}

class TimeoutCoroutine extends Coroutine {
  num creationTime;
  num timeout;

  TimeoutCoroutine(bool Function() task,  this.timeout)
      : super(task) {
    creationTime = Coroutine.gameTimer.currentTime;
  }

  @override
  bool execute() => (task() || Coroutine.gameTimer.isTimeout(creationTime + timeout));
}

// rotation speed can be negative => rotation left
class RotateCoroutine extends Coroutine {
  num creationTime;
  dynamic rotateMe;
  num rotationSpeed = 0;
  num currentAngle = 0;
  num targetAngle = 0;

  RotateCoroutine(this.rotateMe, {this.targetAngle, this.rotationSpeed, bool Function() task})
      : super(task) {
    task ??= rotateTask;
    targetAngle = targetAngle.abs();
    creationTime = Coroutine.gameTimer.currentTime;
  }

  bool rotateTask() {
    var rotateAngle = rotationSpeed * Coroutine.gameTimer.delta;
    currentAngle += rotateAngle.abs();
    rotateMe.rotate(rotateAngle);
    if (currentAngle > targetAngle) {
      rotateMe.rotate((targetAngle - currentAngle) * rotationSpeed.sign);
      return true;
    }
    return false;
  }

  @override
  bool execute() => (task == null ? rotateTask() : task());
}
