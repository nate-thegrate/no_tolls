import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:no_tolls/get_hooked/get_hooked.dart';
import 'package:no_tolls/home/home.dart';

part 'route.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  static const _navigatorKey = GlobalObjectKey<NavigatorState>(Navigator);
  static BuildContext get context => _navigatorKey.currentContext!;
  static NavigatorState get navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff00ffff),
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _goRouter,
    );
  }
}
