import 'package:flutter/rendering.dart';

export 'package:flutter/material.dart' hide MatrixTransition, Route;
export 'package:flutter/rendering.dart';
export 'package:flutter/services.dart';
export 'package:get_hooked/get_hooked.dart';
export 'package:url_launcher/url_launcher_string.dart';

export 'main.dart';
export 'utils/get_pointer.dart';
export 'utils/matrix_transition.dart';

class Seconds extends Duration {
  const Seconds(double seconds)
    : super(microseconds: (seconds * Duration.microsecondsPerSecond) ~/ 1);
}

class BigBox extends RenderBox {
  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  void performResize() => size = constraints.biggest;
}
