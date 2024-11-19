import 'package:go_router/go_router.dart';
import 'package:no_tolls/get_hooked/get_hooked.dart';
import 'package:no_tolls/home/home.dart';
import 'package:no_tolls/the_good_stuff.dart';

part 'route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // getRoute = Get.it(Route.home);
  HardwareKeyboard.instance.addHandler(Route.pop);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static const _navigatorKey = GlobalObjectKey<NavigatorState>(Navigator);
  static BuildContext get context => _navigatorKey.currentContext!;
  static NavigatorState get navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    Vsync.defaultCurve = Curves.ease;

    return GetPointer(
      child: MaterialApp.router(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff00ffff),
            dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: _goRouter,
      ),
    );
  }
}
