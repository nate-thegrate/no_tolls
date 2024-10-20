import 'package:no_tolls/main.dart';
import 'package:no_tolls/the_good_stuff.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static void watch() {
    launchUrlString('https://youtu.be/ywZt6igT5Dw');
    Future.delayed(const Seconds(1), neverMind);
  }

  static void neverMind() => App.navigator.pop();

  static Widget dialogBuilder(BuildContext context) {
    return const AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Text('Watch a video?', textAlign: TextAlign.center),
      content: Text('(it has swear words.)', textAlign: TextAlign.center),
      actions: [
        TextButton(onPressed: neverMind, child: Text('no')),
        FilledButton(onPressed: watch, child: Text('yes')),
      ],
    );
  }

  static void swearWordDialog() => showDialog(context: App.context, builder: dialogBuilder);

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        ColoredBox(
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
                  Text.rich(TextSpan(children: [
                    TextSpan(text: 'No Tolls', style: TextStyle(fontSize: 42)),
                    TextSpan(text: '\nopen source = free'),
                    TextSpan(text: '\nfree = good\n'),
                  ])),
                  Spacer(flex: 4),
                  Spacer(flex: 8),
                  Text(
                    "At some point, if/when I publish something to pub.dev, I'll link to it here!",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
        IgnorePointer(child: _PoemScrim()),
        Align(
          alignment: Alignment(0, 0.5),
          child: PoemButton(),
        ),
      ],
    );
  }
}

class _NO extends StatelessWidget {
  const _NO();

  @override
  Widget build(BuildContext context) {
    const icon = Icon(
      Icons.block_flipped,
      size: 200,
      color: Color(0xffe01030),
    );

    return AnimatedOpacity(
      opacity: ModalRoute.isCurrentOf(context)! ? 1 : 0,
      duration: Durations.short4,
      child: icon,
    );
  }
}

class _PoemScrim extends SingleChildRenderObjectWidget with RenderListenable {
  const _PoemScrim() : super(child: const SizedBox.expand());

  static ValueAnimation<Color>? _animation;
  static ValueAnimation<Color> get animation => _animation ??= ValueAnimation(
        vsync: App.navigator,
        initialValue: Colors.transparent,
        curve: Curves.easeInOutSine,
        duration: PoemButton.duration,
      );

  @override
  Listenable get listenable => animation;

  @override
  RenderColoredBox createRenderObject(BuildContext context) {
    return RenderColoredBox(color: animation.value);
  }

  @override
  void updateRenderObject(BuildContext context, RenderColoredBox renderObject) {
    renderObject.color = animation.value;
  }
}

extension type const PoemButton._(FilledButton _button) implements ButtonStyleButton {
  const PoemButton()
      : _button = const FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xFF9020FF)),
            foregroundColor: WidgetStatePropertyAll(Colors.black),
            shape: WidgetStatePropertyAll(
              ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            ),
          ),
          onPressed: viewPoem,
          onHover: hover,
          child: Text('VIEW POEM'),
        );

  static const duration = Durations.medium1;
  static void viewPoem() async {
    clicked = true;
    _PoemScrim.animation.value = const Color(0xff100020);
    await Future.delayed(duration);
    Route.go(Route.poem);
  }

  static bool clicked = false;
  static void hover(bool hovering) {
    if (clicked) return;
    _PoemScrim.animation.value = hovering ? const Color(0xf8000000) : Colors.transparent;
  }
}
