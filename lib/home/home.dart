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

  static void swearWordDialog() => showDialog<void>(context: App.context, builder: dialogBuilder);
  static void getHooked() => Route.go(Route.getHooked);

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
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
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'No Tolls', style: TextStyle(fontSize: 42)),
                    TextSpan(text: '\nopen source = free'),
                    TextSpan(text: '\nfree = good\n'),
                  ],
                ),
              ),
              Spacer(flex: 4),
              FilledButton(
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff004080))),
                onPressed: getHooked,
                child: Text('Get Hooked!', style: TextStyle(fontWeight: FontWeight.normal)),
              ),
              Spacer(flex: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _NO extends StatelessWidget {
  const _NO();

  @override
  Widget build(BuildContext context) {
    const icon = Icon(Icons.block_flipped, size: 200, color: Color(0xffe01030));

    return AnimatedOpacity(
      opacity: ModalRoute.isCurrentOf(context)! ? 1 : 0,
      duration: Durations.short4,
      child: icon,
    );
  }
}
