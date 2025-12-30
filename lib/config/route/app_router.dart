import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_expense_analyzer/core/pages/splash_screen.dart';
import 'package:student_expense_analyzer/config/route/onboarding_routes.dart';

class Approuter {
  static final Approuter _instance = Approuter.init();

  static final instance = _instance;
  static late final GoRouter router;

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final parentNavigatorKey = GlobalKey<NavigatorState>();
  static final homeTabNavigatorKey = GlobalKey<NavigatorState>();
  static final searchTabNavigatorKey = GlobalKey<NavigatorState>();

  Approuter.init() {
    final List<RouteBase> routes = <RouteBase>[...onboardingRoutes];
    router = GoRouter(
      initialLocation: SplashScreen.routePath,
      navigatorKey: rootNavigatorKey,
      routes: routes,
    );
  }
}

extension GoRouterExtension on GoRouter {
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList =
        lastMatch is ImperativeRouteMatch
            ? lastMatch.matches
            : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }

  Stream<String> get locationStream =>
      Stream<String>.periodic(const Duration(seconds: 1), (computationCount) {
        return Approuter.router.location;
      });
}

Page getPage({required Widget child, required GoRouterState state}) {
  return MaterialPage(key: state.pageKey, child: child);
}
