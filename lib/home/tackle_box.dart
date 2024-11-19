import 'package:no_tolls/the_good_stuff.dart';

final getHovered = Get.vsyncValue(TackleBox.inactive);

class TackleBox extends StatelessWidget {
  const TackleBox({super.key});

  static const inactive = Color(0xff202020);
  static const active = Color(0xff303030);

  static void _onEnter([_]) {
    getHovered.animateTo(active, duration: Durations.long1, curve: Curves.ease);
  }

  static void _onExit([_]) {
    getHovered.animateTo(inactive, duration: Durations.medium1, curve: Curves.easeInOutSine);
  }

  static void goGetHooked([_]) => Route.go(Route.getHooked);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 125,
      child: ColoredBox(
        color: Colors.white,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: MouseRegion(
            opaque: false,
            onEnter: _onEnter,
            onExit: _onExit,
            cursor: SystemMouseCursors.click,
            child: TapRegion(
              onTapInside: goGetHooked,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment(0, -0.85),
                  ),
                ),
                position: DecorationPosition.foreground,
                child: _AnimatedStuff(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Image(image: AssetImage('assets/images/get_hooked_solid_color.png')),
                    ),
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

class _AnimatedStuff extends SingleChildRenderObjectWidget {
  const _AnimatedStuff({super.child});

  @override
  RenderBox createRenderObject(BuildContext context) => _RenderHeightAndColor();
}

final getHeight = Get.vsyncValue(0.0, duration: Durations.long2);

class _RenderHeightAndColor extends RenderProxyBox {
  _RenderHeightAndColor() {
    heightAnimation.addListener(markNeedsLayout);
    colorAnimation.addListener(markNeedsPaint);
    () async {
      await Future<void>.delayed(const Seconds(2));
      await heightAnimation.animateTo(120);
      if (getPointer.isTouch) TackleBox._onEnter();
    }();
  }

  final ValueListenable<Color> colorAnimation = getHovered.hooked;

  final heightAnimation = getHeight.hooked;
  double get height => heightAnimation.value;

  BoxConstraints get _constraints => BoxConstraints.expand(height: height);

  @override
  double computeMinIntrinsicHeight(double width) => height;

  @override
  double computeMaxIntrinsicHeight(double width) => height;

  @override
  double? computeDryBaseline(BoxConstraints constraints, TextBaseline baseline) {
    return child?.getDryBaseline(_constraints.enforce(constraints), baseline);
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    if (child case final child?) {
      child.layout(_constraints.enforce(constraints), parentUsesSize: true);
      size = child.size;
    } else {
      size = _constraints.enforce(constraints).constrain(Size.zero);
    }
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return child?.getDryLayout(_constraints.enforce(constraints)) ??
        _constraints.enforce(constraints).constrain(Size.zero);
  }

  @override
  void debugPaintSize(PaintingContext context, Offset offset) {
    super.debugPaintSize(context, offset);
    assert(() {
      final Paint paint;
      if (child == null || child!.size.isEmpty) {
        paint = Paint()..color = const Color(0x90909090);
        context.canvas.drawRect(offset & size, paint);
      }
      return true;
    }());
  }

  @override
  void dispose() {
    colorAnimation.removeListener(markNeedsPaint);
    heightAnimation.removeListener(markNeedsLayout);
    super.dispose();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawRect(offset & size, Paint()..color = colorAnimation.value);
    if (child case final child?) {
      context.paintChild(child, offset);
    }
  }
}
