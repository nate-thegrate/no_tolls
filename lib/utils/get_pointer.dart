import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:no_tolls/the_good_stuff.dart';

// dart format off
final getPointer = Get.it(switch (defaultTargetPlatform) {
  TargetPlatform.android || TargetPlatform.fuchsia || TargetPlatform.iOS => PointerDeviceKind.touch,
  TargetPlatform.linux || TargetPlatform.macOS || TargetPlatform.windows => PointerDeviceKind.mouse,
});
// dart format on

extension IsTouch on GetValue<PointerDeviceKind> {
  bool get isTouch => switch (value) {
    PointerDeviceKind.mouse || PointerDeviceKind.trackpad => false,
    _ => true,
  };
}

class GetPointer extends SingleChildRenderObjectWidget {
  GetPointer({super.key, required Widget child}) : super(child: _MouseRegion(child: child));

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPointerListener(onPointerDown: (event) => getPointer.value = event.kind);
  }
}

class _MouseRegion extends SingleChildRenderObjectWidget {
  const _MouseRegion({required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMouseRegion(onHover: (event) => getPointer.value = event.kind);
  }
}
