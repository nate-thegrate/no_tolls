part of '../poem.dart';

class CupidBow extends StatefulWidget {
  const CupidBow() : super(key: _key);

  static const _key = GlobalObjectKey<CupidAnimations>(CupidBow);

  @override
  State<CupidBow> createState() => CupidAnimations();
}

class CupidAnimations extends State<CupidBow> with TickerProviderStateMixin {
  static CupidAnimations get instance => CupidBow._key.currentState!;

  final animating = ValueNotifier(false);

  late final twist = AnimationController(
    value: 2.64,
    vsync: this,
    upperBound: pi * 2,
    duration: const Duration(milliseconds: 2000),
  );
  late final pierce = ValueAnimation(
    vsync: this,
    initialValue: 1.0,
    duration: Durations.medium2,
    curve: Curves.easeOutQuad,
  );
  late final tension = ValueAnimation(
    vsync: this,
    initialValue: const Offset(1, 0),
    duration: Durations.extralong4,
    curve: Curves.easeOutQuart,
  );
  static const camDelay = Durations.short2;
  late final camera = ValueAnimation(
    vsync: this,
    initialValue: Offset.zero,
    duration: Durations.medium1 - camDelay,
    curve: Curves.easeInSine,
  );
  late final angle = ValueAnimation(
    vsync: this,
    initialValue: 0.0,
    duration: const Duration(seconds: 5),
    curve: Curves.easeOutSine,
  );

  @override
  void initState() {
    super.initState();

    tension.animateTo(Offset.zero);

    // if ((() => true)()) {
    //   return;
    // }

    void updateAnimation() {
      if (animating.value) {
        twist.repeat();
        return;
      }

      animating.removeListener(updateAnimation);
      try {
        twist.forward().orCancel;
      } on TickerCanceled {
        // ignore
      }
      pierce.animateTo(0);
    }

    animating.addListener(updateAnimation);

    () async {
      await Future.delayed(const Duration(seconds: 2));
      tension.animateTo(
        const Offset(1, 0),
        duration: Durations.medium1,
        curve: Curves.easeInQuad,
      );

      animating.value = true;

      await Future.delayed(camDelay);
      camera.animateTo(const Offset(-1, 0));
      try {
        await angle.animateTo(1 / 8).orCancel;
      } on TickerCanceled {
        // ignore
      }
      if (!mounted) return;

      animating.value = false;
    }();
  }

  @override
  void dispose() {
    tension.dispose();
    animating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox.expand(
          child: FittedBox(
            child: SizedBox.square(
              dimension: 500,
              child: ColoredBox(
                // color: const Color(0xff202020),
                color: const Color(0xfff0f0f0),
                child: SlideTransition(
                  position: camera,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // FractionallySizedBox(widthFactor: 0.45, child: _Dart()),
                      const Bow(),
                      Heart(pierce),
                      SlideTransition(
                        position: tension,
                        child: RotationTransition(
                          turns: angle,
                          child: const DartDart(),
                        ),
                      ),
                      const Bowstring(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Bow extends CustomPaint {
  const Bow({super.key}) : super(painter: const _Bow(), size: const Size.square(500));
}

class _Bow extends CustomPainter {
  const _Bow();

  static final fill = Paint()..color = const Color(0xffff80a0);
  static final sheenFill = Paint()..color = const Color(0xffffc0d0);
  static final path = Path()
    ..moveTo(0.51, 0)
    ..cubicTo(0.55, 0, 0.54, 0.05, 0.54, 0.1)
    ..cubicTo(0.54, 0.3, 0.75, 0.3, 0.57, 0.5)
    ..lineTo(0.5, 0.5)
    ..cubicTo(0.575, 0.33, 0.5, 0.3, 0.5, 0.2)
    ..cubicTo(0.5, 0.18, 0.51, 0.15, 0.51, 0.1)
    ..cubicTo(0.51, 0.06, 0.5, 0.03, 0.5, 1 / 64)
    ..cubicTo(0.5, 0.005, 0.505, 0, 0.51, 0)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..scale(size.width)
      ..save()
      ..clipPath(path)
      ..drawPaint(fill)
      ..drawPath(path.shift(const Offset(-0.015, 0.005)), sheenFill)
      ..restore()
      ..transform(
        // bottom half of bow (mirrored)
        Matrix4.identity().storage
          ..[5] = -1
          ..[13] = 1,
      )
      ..clipPath(path)
      ..drawPaint(fill)
      ..drawPath(path.shift(const Offset(-0.012, -0.005)), sheenFill);
  }

  @override
  bool shouldRepaint(_Bow oldDelegate) => false;
}

class Bowstring extends LeafRenderObjectWidget {
  const Bowstring({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderBowstring();
}

class _RenderBowstring extends RenderBox {
  _RenderBowstring() {
    tension.addListener(markNeedsPaint);
  }

  final Animation<Offset> tension = CupidAnimations.instance.tension;

  @override
  void dispose() {
    tension.removeListener(markNeedsPaint);
    super.dispose();
  }

  @override
  void performLayout() => size = constraints.biggest;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final Rect rect = offset & size;
    final double tension = this.tension.value.dx;

    final midpoint = Offset(
      lerpDouble(rect.centerLeft.dx, rect.center.dx, min(tension * 2, 1))!,
      rect.center.dy,
    );

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xff201000);

    final inset = Offset(0, -rect.height / 64);
    canvas.drawLine(rect.bottomCenter + inset, midpoint, stroke);
    canvas.drawLine(midpoint, rect.topCenter - inset, stroke);
  }
}

class DartDart extends RotatedBox {
  const DartDart({super.key}) : super(quarterTurns: -1, child: _child);

  static const _child = Center(child: AspectRatio(aspectRatio: 1 / 2, child: _Dart()));
}

class _Dart extends LeafRenderObjectWidget {
  const _Dart();

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderDart();
}

class _RenderDart extends RenderBox {
  _RenderDart() {
    twist.addListener(markNeedsPaint);
    pierce.addListener(markNeedsPaint);
  }

  final CupidAnimations animations = CupidAnimations.instance;
  late final twist = animations.twist;
  late final pierce = animations.pierce;

  @override
  void dispose() {
    twist.removeListener(markNeedsPaint);
    pierce.removeListener(markNeedsPaint);
    super.dispose();
  }

  @override
  void performLayout() => size = constraints.biggest;

  static final path = Path()
    ..moveTo(0, 0)
    ..lineTo(0, 0.8)
    ..lineTo(0.175, 0.875)
    ..lineTo(0.5, 0.55)
    ..lineTo(0.5, 0.25)
    ..cubicTo(0.5, 0.2, 0.45, 0.18, 0.4, 0.16)
    ..lineTo(0, 0);

  static final shaft = Paint()..color = const Color(0xffc0c0c0);

  static final tip = Paint()..color = const Color(0xff0058a0);
  static final tipPath = Path()
    ..moveTo(0.03, 1.77)
    ..cubicTo(0.02, 1.9, 0.005, 1.9, 0.002, 2)
    ..lineTo(-0.002, 2)
    ..cubicTo(-0.005, 1.9, -0.02, 1.9, -0.03, 1.77)
    ..close();

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final double dimension = min(size.width, size.height);
    final fletching = <Flap>[
      for (int i = 0; i < 4; i++)
        Flap(
          twist.value + (i + 0.5) * pi / 2,
          (i.isEven) ? const Color(0xff0058a0) : const Color(0xff40c0ff),
        )
    ]..sort();

    final double pierce = this.pierce.value;

    canvas
      ..save()
      ..translate(offset.dx, offset.dy + size.height * (1 - pierce) / 4.2)
      ..transform(Matrix4.translationValues(dimension / 2, 0, 0).storage)
      ..transform(Matrix4.diagonal3Values(dimension, dimension, 0).storage);

    void paintFlap(Flap flap) {
      canvas
        ..save()
        ..transform(flap.rotated)
        ..transform(flap.skewed)
        ..drawPath(path, flap.paint)
        ..restore();
    }

    fletching.take(2).forEach(paintFlap);
    const shaftRect = Rect.fromLTRB(-0.04, 2 / 3, 0.04, 1.92);

    canvas
      ..save()
      ..clipRect(Rect.fromLTWH(-0.5, 0.8, 1, lerpDouble(0, 1.2, pierce)!))
      ..drawOval(shaftRect, shaft)
      ..drawPath(tipPath, tip)
      ..restore();
    fletching.skip(2).forEach(paintFlap);

    canvas.restore();
  }
}

class Flap implements Comparable<Flap> {
  Flap(this.rotation, this.color);

  final double rotation;
  final Color color;

  static const dark = Color(0xff0058a0);
  static const light = Color(0xff40c0ff);

  static double _skew(double t) => cos(t - pi / 2);

  Float64List get rotated => Matrix4.rotationY(rotation).storage;
  Float64List get skewed => Matrix4.skewY(_skew(rotation) / 3 + 0.05).storage;
  Paint get paint {
    final double progress = (rotation - pi / 4) % (pi / 2);
    const multiplier = 1.25;
    final double t =
        Curves.easeOutQuad.transform(progress * 2 / pi) * multiplier - (multiplier - 1) / 2;
    final bool increasing = ((rotation - pi / 4) % pi) == progress;
    return Paint()
      ..color = Color.lerp(
        color,
        Color.lerp(dark, light, increasing ? t : 1 - t)!,
        0.2,
      )!;
  }

  @override
  int compareTo(Flap other) => _skew(rotation).compareTo(_skew(other.rotation));
}

class Heart extends SingleChildRenderObjectWidget with RenderListenable {
  const Heart(this.pierce, {super.key}) : super(child: const CustomPaint(painter: _Heart()));

  final Animation<double> pierce;

  @override
  Listenable get listenable => pierce;

  @override
  RenderFractionalTranslation createRenderObject(BuildContext context) {
    final double pierce = this.pierce.value;
    return RenderFractionalTranslation(translation: Offset(1 + pierce, pierce));
  }

  @override
  void updateRenderObject(BuildContext context, RenderFractionalTranslation renderObject) {
    final double pierce = this.pierce.value;
    renderObject.translation = Offset(1 + pierce, pierce);
  }
}

class _Heart extends CustomPainter {
  const _Heart();

  static final path = Path()
    ..moveTo(0.5, 0.2)
    ..cubicTo(0.525, -0.2, 1.52, 0, 0.5, 0.9)
    ..cubicTo(-0.52, 0, 0.475, -0.2, 0.5, 0.2);
  static final fill = Paint()..color = const Color(0xffff2266);

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..scale(size.width)
      ..drawPath(path, fill);
  }

  @override
  bool shouldRepaint(_Heart oldDelegate) => false;
}
