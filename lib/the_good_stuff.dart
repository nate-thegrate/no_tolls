export 'package:flutter/material.dart' hide Route;
export 'package:url_launcher/url_launcher_string.dart';

export 'main.dart';

class Seconds extends Duration {
  const Seconds(double seconds)
      : super(microseconds: (seconds * Duration.microsecondsPerSecond) ~/ 1);
}
