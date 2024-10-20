part of 'main.dart';

enum Route {
  home,
  poem;

  factory Route.fromUri(Uri uri) {
    final List<String> segments = uri.pathSegments;
    final String name = switch (segments.last) {
      final s when !s.contains('true') && !s.contains('false') => s,
      _ => segments[segments.length - 2],
    };

    try {
      return values.byName(name);
    } on Object {
      throw ArgumentError('uri: $uri, segments: ${uri.pathSegments}');
    }
  }

  static void go(Route route, {Map<String, String>? params, Object? extra}) {
    if (params == null) {
      return _goRouter.go(route.uri, extra: extra);
    }
    _goRouter.goNamed(route.name, pathParameters: params, extra: extra);
  }

  String get uri => switch (this) { home => '/', poem => '/poem' };
}

final _goRouter = GoRouter(
  navigatorKey: App._navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: Route.home.name,
      pageBuilder: (context, state) => const NoTransitionPage(child: Home()),
      routes: [
        GoRoute(
          path: '/poem',
          name: Route.poem.name,
          pageBuilder: (context, state) => const NoTransitionPage(child: Poem()),
        ),
      ],
    ),
  ],
);
