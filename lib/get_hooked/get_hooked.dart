// import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:no_tolls/the_good_stuff.dart';

class GetHookedScreen extends Scaffold {
  const GetHookedScreen({super.key})
    : super(
        backgroundColor: const Color(0xff202020),
        body: _body,
        floatingActionButton: _backButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      );

  static const _body = Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: FadeIn(
        child: Column(
          children: [
            Spacer(),
            RepaintBoundary(
              child: FittedBox(child: SizedBox(width: 200, height: 300, child: HookedLogo())),
            ),
            Spacer(flex: 2),
            ElevatedButton(
              style: _buttonStyle,
              onPressed: _getHooked,
              child: Text(
                'get_hooked\non pub.dev',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffe0e0e0),
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    ),
  );

  static void _getHooked() => launchUrlString('https://pub.dev/packages/get_hooked');
  static void _back() => Route.go(Route.home);

  static OutlinedBorder _shape(Set<WidgetState> states) {
    final radius = BorderRadius.circular(states.contains(WidgetState.hovered) ? 0.0 : 24.0);
    return RoundedRectangleBorder(borderRadius: radius);
  }

  static const _buttonStyle = ButtonStyle(
    shape: WidgetStateOutlinedBorder.resolveWith(_shape),
    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 48, vertical: 24)),
    backgroundColor: WidgetStateMapper({
      WidgetState.hovered: Color(0xff003494),
      WidgetState.any: Color(0xff002c80),
    }),
    elevation: WidgetStateMapper({WidgetState.pressed: 0, WidgetState.any: 4}),
    overlayColor: WidgetStateMapper({
      WidgetState.pressed: Color(0x40101010),
      WidgetState.hovered: Color(0x01010101),
      WidgetState.any: Colors.transparent,
    }),
  );

  static const _backButton = Padding(
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
  );
}

final getFade = Get.vsync();

final getGradient = Get.vsyncValue(0.0, duration: const Seconds(2));

class FadeIn extends SingleChildRenderObjectWidget {
  const FadeIn({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    final AnimationController opacity = getFade.hooked;

    Future<void>.delayed(
      Durations.medium1,
      () => opacity.animateTo(1.0, duration: const Seconds(1), curve: Curves.easeInOutSine),
    );

    return RenderAnimatedOpacity(opacity: opacity);
  }
}

class HookedLogo extends HookWidget {
  const HookedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final GetVsyncValue<double> animation = Ref.vsync(getGradient, watch: true);
    useMemoized(() async {
      if (getFade.value < 1) {
        await Future<void>.delayed(Durations.extralong1);
      }
      animation.animateTo(0.8, from: 0.0);
    });

    final gradient = SweepGradient(
      colors: const [
        Color(0xff00ffff), //
        Color(0xff0088f0), //
        Color(0xff0050c0), //
        Color(0xff001880), //
      ],
      transform: const GradientRotation(-0.1),
      stops: [for (var i = -0.5; i < 3.5; i++) i / 2.5 + animation.value - 0.8],
    );

    return Stack(
      children: [
        ShaderMask(
          shaderCallback: gradient.createShader,
          child: const Image(image: AssetImage('assets/images/get_hooked_logo.png')),
        ),
        ShaderMask(
          shaderCallback: gradient.createShader,
          blendMode: BlendMode.srcATop,
          child: const _FadeInTopLayer(
            child: Image(image: AssetImage('assets/images/get_hooked_logo.png')),
          ),
        ),
      ],
    );
  }
}

class _FadeInTopLayer extends SingleChildRenderObjectWidget {
  const _FadeInTopLayer({super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAnimatedOpacity(opacity: getGradient.hooked);
  }
}
