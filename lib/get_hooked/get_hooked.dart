import 'dart:math' as math;

import 'package:no_tolls/the_good_stuff.dart';
// import 'package:get_hooked/get_hooked.dart';

class GetHooked extends StatelessWidget {
  const GetHooked({super.key});

  static _getHooked() => launchUrlString('https://pub.dev/');
  static _back() => Route.go(Route.home);

  static OutlinedBorder _shape(Set<WidgetState> states) {
    final radius = BorderRadius.circular(
      states.contains(WidgetState.hovered) ? 0.0 : 32.0,
    );
    return RoundedRectangleBorder(borderRadius: radius);
  }

  @override
  Widget build(BuildContext context) {
    const logo = FittedBox(
      child: SizedBox(width: 200, height: 300, child: CustomPaint(painter: _HookLogoPainter())),
    );
    const button = ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateOutlinedBorder.resolveWith(_shape),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        ),
        backgroundColor: WidgetStatePropertyAll(Color(0xff002c80)),
        elevation: WidgetStateMapper({
          WidgetState.pressed: 0,
          WidgetState.any: 4,
        }),
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
        style: TextStyle(
          color: Color(0xffe0e0e0),
          fontSize: 24,
          fontWeight: FontWeight.w300,
        ),
      ),
    );

    return const Scaffold(
      backgroundColor: Color(0xff202020),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            Spacer(),
            logo,
            Spacer(flex: 2),
            button,
            Spacer(flex: 2),
          ]),
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

class _HookLogoPainter extends CustomPainter {
  const _HookLogoPainter();

  static const double scale = 300 / 16;
  static final canvasTransform = Matrix4.diagonal3Values(scale, scale, scale).storage;
  static final ovalTransform = Matrix4.rotationZ(-math.pi / 4).storage
    ..[12] = 6.25
    ..[13] = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(10.55, 10)
      ..cubicTo(10.55, 20.75, -9, 16, 5.5, 1.5)
      ..lineTo(6.33, 2.2)
      ..cubicTo(-6, 15, 8.25, 17.75, 9.5, 11.5)
      ..cubicTo(9.9, 10, 9, 10.5, 8.45, 10.5)
      ..lineTo(10.55, 8)
      ..close()
      ..addPath(
        (Path()..addOval(Rect.fromCenter(center: Offset.zero, width: 3.25, height: 1.25)))
            .transform(ovalTransform),
        Offset.zero,
      );

    final Rect rect = Rect.fromLTWH(0, 0, 16 * size.width / 300, 16);
    const gradient = SweepGradient(
      colors: [
        Color(0xff00ffff),
        Color(0xff0078b0),
        Color(0xff003090),
        Color(0xff000820),
      ],
    );
    canvas
      ..transform(canvasTransform)
      ..drawShadow(path, Colors.black, 4, false)
      ..drawShadow(path, Colors.black, 8, false)
      ..clipPath(path)
      ..drawRect(
        rect,
        Paint()..shader = gradient.createShader(rect),
      )
      ..transform(ovalTransform)
      ..drawOval(
        Rect.fromCenter(center: Offset.zero, width: 2.1, height: 0.45),
        Paint()..color = const Color(0xff101010),
      );
  }

  @override
  bool shouldRepaint(_HookLogoPainter oldDelegate) => false;
}
