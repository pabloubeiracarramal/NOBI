import 'package:desktop/src/services/DataService.dart';
import 'package:desktop/src/views/DashboardPage/DashboardPage.dart';
import 'package:desktop/src/views/HomePage/HomePage.dart';
import 'package:desktop/src/views/LoginPage/LoginPage.dart';
import 'package:desktop/src/views/WelcomePage/WelcomePage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'models/AuthModel.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  Page<void> fadePageBuilder(
      BuildContext context, GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  return GoRouter(
    routes: [
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) =>
            fadePageBuilder(context, state, const HomePage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            fadePageBuilder(context, state, const LoginPage()),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) =>
            fadePageBuilder(context, state, const WelcomePage()),
      ),
      GoRoute(
        path: '/dashboard/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return fadePageBuilder(
              context, state, DashboardPage(dashboardId: id));
        },
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = authService.currentUser != null;

      if (state.fullPath == '/login') {
        return '/login';
      }

      return isAuthenticated ? state.matchedLocation : '/welcome';
    },
  );
});

class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    DataService().setRef(ref);
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color.fromRGBO(0, 0, 0, 1),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: Color.fromRGBO(255, 255, 255, 1),
      ),
    );
  }
}
