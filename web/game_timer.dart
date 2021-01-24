import 'dart:html';
import 'dart:math';

class GameTimer {
  num _currentTime;
  num _delta;

  GameTimer(this._currentTime);

  get currentTime => _currentTime;

  set currentTime(num val) {
   _delta = val - _currentTime;
   _currentTime = val;
  }

  get delta => _delta;

  bool isTimeout(num finishTime) {
    return (_currentTime > finishTime);
  }
}
