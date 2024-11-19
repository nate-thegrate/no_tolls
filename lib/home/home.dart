import 'package:no_tolls/the_good_stuff.dart';
import 'tackle_box.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static void neverMind() => App.navigator.pop();

  static final themeData = ThemeData(
    filledButtonTheme: const FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
        backgroundColor: WidgetStateMapper({
          WidgetState.hovered: Color(0x1000ffff),
          WidgetState.any: Color(0x1000ffff),
        }),
        elevation: WidgetStatePropertyAll(0),
        foregroundColor: WidgetStatePropertyAll(Colors.black),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 32, vertical: 20)),
      ),
    ),
  );

  static Widget _dialogButtons(BuildContext context) {
    Ref.watch(getPointer);
    final bool isTouch = getPointer.isTouch;
    const tolls = Color(0xc0f7b943);
    const sargnarg = Color(0xc066a3ff);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilledButton(
          style: ButtonStyle(
            overlayColor:
                isTouch
                    ? const WidgetStatePropertyAll(tolls)
                    : const WidgetStateMapper({
                      WidgetState.hovered: tolls,
                      WidgetState.any: Color(0x10f7b943),
                    }),
          ),
          onPressed: neverMind,
          child: const Text('no'),
        ),
        FilledButton(
          style: ButtonStyle(
            overlayColor:
                isTouch
                    ? const WidgetStatePropertyAll(sargnarg)
                    : const WidgetStateMapper({
                      WidgetState.hovered: sargnarg,
                      WidgetState.any: Color(0x1066a3ff),
                    }),
          ),
          onPressed: () {
            launchUrlString('https://youtu.be/ywZt6igT5Dw');
            Future.delayed(const Seconds(1), neverMind);
          },
          child: const Text('yes'),
        ),
      ],
    );
  }

  static Widget dialogBuilder(BuildContext context) {
    const funLittleBar = Expanded(
      child: ColoredBox(color: Color(0xff00ffff), child: SizedBox.expand()),
    );
    return Theme(
      data: themeData,
      child: const Center(
        child: DefaultTextStyle(
          style: TextStyle(inherit: false, color: Colors.black),
          child: PhysicalShape(
            clipper: ShapeBorderClipper(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(48)),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Color(0xfff0ffff),
            child: SizedBox(
              width: 250,
              height: 300,
              child: Column(
                children: [
                  funLittleBar,
                  Spacer(flex: 5),
                  Text(
                    'Watch a video?',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                  Spacer(flex: 2),
                  Text('it has swear words.'),
                  Spacer(flex: 8),
                  HookBuilder(builder: _dialogButtons),
                  Spacer(flex: 8),
                  funLittleBar,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void swearWordDialog() => showDialog<void>(context: App.context, builder: dialogBuilder);

  static const _mainContent = Expanded(
    child: ColoredBox(
      color: Colors.white,
      child: DefaultTextStyle(
        style: TextStyle(
          inherit: false,
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        child: Center(
          child: Column(
            children: [
              Spacer(flex: 3),
              ElevatedButton(
                onHover: _hover,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xff80ffff)),
                  shape: WidgetStatePropertyAll(
                    ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  overlayColor: WidgetStatePropertyAll(Color(0x4000ffff)),
                ),
                onPressed: swearWordDialog,
                child: SizedBox.square(
                  dimension: 200,
                  child: IgnorePointer(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(26.0),
                          child: Image(image: AssetImage('assets/images/tolls.png')),
                        ),
                        _NO(),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text('open source = free\nfree = good\n'),
              Spacer(flex: 6),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return const Column(children: [_mainContent, TackleBox()]);
  }
}

final getNo = Get.vsync();
void _hover(bool hovering) {
  hovering
      ? getNo.animateTo(1.0, duration: Durations.short3, curve: Curves.easeInQuad)
      : getNo.animateBack(0.0, duration: Durations.short2, curve: Curves.ease);
}

class _NO extends HookWidget {
  const _NO();

  static void listener() => _hover(getPointer.isTouch);

  @override
  Widget build(BuildContext context) {
    Ref.vsync(getNo);
    useEffect(() {
      if (getPointer.isTouch) {
        Future.delayed(Durations.medium1, listener);
      }

      getPointer.hooked.addListener(listener);

      return () => getPointer.hooked.removeListener(listener);
    });

    return MatrixTransition(
      animation: getNo.hooked,
      onTransform: (t) {
        final double scale = getNo.isForwardOrCompleted ? 2 - t : 1.25 - 0.25 * t;
        return Matrix4.diagonal3Values(scale, scale, scale);
      },
      child: FadeTransition(
        opacity: getNo.hooked,
        child: const Icon(Icons.block_flipped, size: 200, color: Color(0xffe01030)),
      ),
    );
  }
}
