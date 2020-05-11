import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';

class AnimationController extends FlareController {
  final String _animation;
  final double _loopAmount;
  final double _mix;
  ActorAnimation _actor;
  double _duration = 0;
  int _loopCount = 0;

  AnimationController(this._animation, this._loopAmount, [this._mix = 0.5]);

@override
void initialize(FlutterActorArtboard artBoard) {
  _actor = artBoard.getAnimation(_animation);
}

@override
bool advance(FlutterActorArtboard artBoard, double elapsed) {
  if(_loopCount >= _loopAmount) {
    // Looped enough times!
    _actor.apply(_actor.duration, artBoard, 1);
    return false;
  }
  _duration += elapsed;

  if (_duration >= _actor.duration) {
    // Loop!
    _loopCount++;
    _duration %= _actor.duration;
  }
  _actor.apply(_duration, artBoard, _mix);
  return true;
}

@override
void setViewTransform(Mat2D viewTransform) {}
}