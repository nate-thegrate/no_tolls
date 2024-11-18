part of 'main.dart';

enum Route {
  home,
  getHooked;

  factory Route.fromUri(Uri uri) {
    final List<String> segments = uri.pathSegments;
    final String last = segments.last;

    for (final Route value in values) {
      if (value.uri.endsWith(last)) return value;
    }
    throw ArgumentError('uri: $uri, segments: $segments');
  }

  static void go(Route route, {Map<String, String>? params, Object? extra}) {
    if (params == null) {
      return _goRouter.go(route.uri, extra: extra);
    }
    _goRouter.goNamed(route.name, pathParameters: params, extra: extra);
  }

  String get uri => switch (this) {
    home => '/',
    getHooked => '/get-hooked',
  };
}

final _goRouter = GoRouter(
  navigatorKey: App._navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: Route.home.name,
      pageBuilder: (context, state) => const MaterialPage(child: Home()),
      routes: [
        GoRoute(
          path: Route.getHooked.uri,
          name: Route.getHooked.name,
          pageBuilder: (context, state) => const MaterialPage(child: GetHookedScreen()),
        ),
      ],
    ),
  ],
);
