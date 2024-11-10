import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:no_tolls/the_good_stuff.dart';

class GetHooked extends StatelessWidget {
  const GetHooked({super.key});

  static void _getHooked() => launchUrlString('https://pub.dev/packages/get_hooked');
  static void _back() => Route.go(Route.home);

  static OutlinedBorder _shape(Set<WidgetState> states) {
    final radius = BorderRadius.circular(states.contains(WidgetState.hovered) ? 0.0 : 32.0);
    return RoundedRectangleBorder(borderRadius: radius);
  }

  @override
  Widget build(BuildContext context) {
    const logo = RepaintBoundary(
      child: FittedBox(child: SizedBox(width: 200, height: 300, child: HookedLogo())),
    );
    const button = ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateOutlinedBorder.resolveWith(_shape),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 48, vertical: 24)),
        backgroundColor: WidgetStatePropertyAll(Color(0xff002c80)),
        elevation: WidgetStateMapper({WidgetState.pressed: 0, WidgetState.any: 4}),
        overlayColor: WidgetStateMapper({
          WidgetState.pressed: Color(0x40101010),
          WidgetState.hovered: Color(0x01010101),
          WidgetState.any: Colors.transparent,
        }),
      ),
      onPressed: _getHooked,
      child: Text(
        'get_hooked\non pub.dev',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xffe0e0e0), fontSize: 24, fontWeight: FontWeight.w300),
      ),
    );

    return const Scaffold(
      backgroundColor: Color(0xff202020),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: FadeIn(
            child: Column(children: [Spacer(), logo, Spacer(flex: 2), button, Spacer(flex: 2)]),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 8.0, top: 24.0),
        child: IconButton.filled(
          style: ButtonStyle(
            elevation: WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(Colors.black26),
            foregroundColor: WidgetStatePropertyAll(Colors.white54),
          ),
          onPressed: _back,
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}

final getFade = Get.vsync();

final getGradient = Get.vsyncValue(0.0, duration: const Seconds(5 / 3));

class FadeIn extends SingleChildRenderObjectWidget {
  const FadeIn({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    final AnimationController opacityController = getFade.attach(context);

    Future<void>.delayed(
      Durations.medium1,
      () => opacityController.animateTo(
        1.0,
        duration: const Seconds(1),
        curve: Curves.easeInOutSine,
      ),
    );

    return RenderAnimatedOpacity(opacity: opacityController);
  }
}

class HookedLogo extends LeafRenderObjectWidget {
  const HookedLogo({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    getGradient.attach(context);
    return _RenderHookedLogo();
  }
}

class _RenderHookedLogo extends BigBox {
  _RenderHookedLogo() {
    init();
  }

  final animation = getGradient.it;

  void init() async {
    if (getFade.controls.value < 1) {
      await Future<void>.delayed(Durations.extralong1);
    }
    animation
      ..animateTo(1.0, from: 0.0)
      ..addListener(markNeedsPaint);
  }

  @override
  void dispose() {
    animation.removeListener(markNeedsPaint);
    super.dispose();
  }

  static const double scale = 300 / 16;
  static final canvasTransform = Matrix4.diagonal3Values(scale, scale, scale).storage;
  static final ovalTransform =
      Matrix4.rotationZ(-math.pi / 4).storage
        ..[12] = 6.25
        ..[13] = 1.5;

  // dart format off
  static final path = Path()
    ..moveTo(10.55, 10)
    ..cubicTo(10.55, 20.75, -9, 16, 5.5, 1.5)
    ..lineTo(6.33, 2.2)
    ..cubicTo(-6, 15, 8.25, 17.75, 9.5, 11.5)
    ..cubicTo(9.9, 10, 9, 10.5, 8.45, 10.5)
    ..lineTo(10.55, 8)
    ..close()
    ..addPath((
        Path()..addOval(Rect.fromCenter(center: Offset.zero, width: 3.25, height: 1.25))
      ).transform(ovalTransform),
      Offset.zero,
    );

  @override
  void paint(PaintingContext context, Offset offset) {
    final gradient = SweepGradient(
      colors: const [
        Color(0xff00ffff),
        Color(0xff0078b0),
        Color(0xff003090),
        Color(0xff000e30),
      ],
      stops: [for (int i = 0; i < 4; i++) i / 3 + animation.value - 1],
    );
    // dart format on

    final Rect rect = Rect.fromLTWH(0, 0, 16 * size.width / 300, 16);
    final Offset(:double dx, :double dy) = offset;
    context.canvas
      ..transform(
        canvasTransform
          ..[12] = dx
          ..[13] = dy,
      )
      ..drawShadow(path, Colors.black, 4, false)
      ..clipPath(path)
      ..drawRect(rect, Paint()..shader = gradient.createShader(rect))
      ..transform(ovalTransform)
      ..drawOval(
        Rect.fromCenter(center: Offset.zero, width: 2.1, height: 0.45),
        Paint()..color = const Color(0xff181818),
      );
  }
}
