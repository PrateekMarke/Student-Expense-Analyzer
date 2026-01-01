import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_expense_analyzer/core/pages/splash_screen.dart';
import 'package:student_expense_analyzer/config/route/onboarding_routes.dart';



class Approuter {

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final parentNavigatorKey = GlobalKey<NavigatorState>();
  static final homeTabNavigatorKey = GlobalKey<NavigatorState>();
  static final settingTabNavigatorKey = GlobalKey<NavigatorState>();
  static final analyticsTabNavigatorKey = GlobalKey<NavigatorState>();
  static final transactionsTabNavigatorKey = GlobalKey<NavigatorState>();
  static final budgetTabNavigatorKey = GlobalKey<NavigatorState>();

 
  static final GoRouter router = GoRouter(
    initialLocation: SplashScreen.routePath,
    navigatorKey: rootNavigatorKey,
    routes: onboardingRoutes, 
    debugLogDiagnostics: true,
  );
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
