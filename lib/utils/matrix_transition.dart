import 'package:no_tolls/the_good_stuff.dart';

class MatrixTransition extends SingleChildRenderObjectWidget {
  /// Creates a matrix transition.
  const MatrixTransition({
    super.key,
    required this.animation,
    required this.onTransform,
    this.alignment = Alignment.center,
    this.filterQuality,
    super.child,
  });

  /// The animation that controls the matrix of the child.
  ///
  /// The matrix will be computed from the animation with the [onTransform]
  /// callback.
  final Animation<double> animation;

  /// The callback to compute a [Matrix4] from the [animation]. It's called
  /// every time [animation] changes its value.
  final TransformCallback onTransform;

  /// The alignment of the origin of the coordinate system in which the
  /// transform takes place, relative to the size of the box.
  ///
  /// For example, to set the origin of the transform to bottom middle, you can
  /// use an alignment of (0.0, 1.0).
  final Alignment alignment;

  /// The filter quality with which to apply the transform as a bitmap operation.
  ///
  /// When the animation is stopped (either in [AnimationStatus.dismissed] or
  /// [AnimationStatus.completed]), the filter quality argument will be ignored.
  ///
  /// {@macro flutter.widgets.Transform.optional.FilterQuality}
  final FilterQuality? filterQuality;

  @override
  RenderAnimatedTransform createRenderObject(BuildContext context) {
    // The ImageFilter layer created by setting filterQuality will introduce
    // a saveLayer call. This is usually worthwhile when animating the layer,
    // but leaving it in the layer tree before the animation has started or after
    // it has finished significantly hurts performance.
    return RenderAnimatedTransform(
      animation: animation,
      onTransform: onTransform,
      alignment: alignment,
      filterQuality: filterQuality,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderAnimatedTransform renderObject) {
    renderObject
      ..animation = animation
      ..onTransform = onTransform
      ..alignment = alignment
      ..widgetFilterQuality = filterQuality
      ..textDirection = Directionality.maybeOf(context);
  }
}

class RenderAnimatedTransform extends RenderTransform {
  RenderAnimatedTransform({
    required Animation<double> animation,
    required this.onTransform,
    super.alignment,
    super.textDirection,
    FilterQuality? filterQuality,
    // super.origin,
    // super.transformHitTests,
  }) : _widgetFilterQuality = filterQuality,
       _animation = animation,
       super(
         transform: onTransform(animation.value),
         filterQuality: animation.isAnimating ? filterQuality : null,
       ) {
    animation.addListener(listener);
  }

  Animation<double> get animation => _animation;
  Animation<double> _animation;
  set animation(Animation<double> newValue) {
    if (newValue == _animation) {
      return;
    }
    _animation.removeListener(listener);
    _animation = newValue..addListener(listener);
    listener();
  }

  /// The [FilterQuality] as configured by [MatrixTransition.filterQuality].
  ///
  /// Applies an [ImageFilterLayer] only while the animation is in progress.
  FilterQuality? get widgetFilterQuality => _widgetFilterQuality;
  FilterQuality? _widgetFilterQuality;
  set widgetFilterQuality(FilterQuality? newValue) {
    _widgetFilterQuality = newValue;
    filterQuality = animation.isAnimating ? newValue : null;
  }

  TransformCallback onTransform;

  void listener() {
    transform = onTransform(animation.value);
    widgetFilterQuality = _widgetFilterQuality;
  }

  @override
  void dispose() {
    animation.removeListener(listener);
    super.dispose();
  }
}
