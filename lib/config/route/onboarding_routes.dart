import 'package:go_router/go_router.dart';
import 'package:student_expense_analyzer/core/pages/splash_screen.dart';
import 'package:student_expense_analyzer/config/route/app_router.dart';

final onboardingRoutes = <RouteBase>[
  GoRoute(
    path: SplashScreen.routePath,
    name: SplashScreen.routeName,
    pageBuilder:
        (context, state) => getPage(child: const SplashScreen(), state: state),
  ),
  // GoRoute(
  //       path: LoginPage.routePath,
  //       name: LoginPage.routeName,
  //       pageBuilder: (context, state) => getPage(
  //         child: const LoginPage(),
  //         state: state,
  //       ),
  //     ),
     // bottom app bar routes and stacks

      // StatefulShellRoute.indexedStack(
      //   parentNavigatorKey: parentNavigatorKey,
      //   pageBuilder: (context, state, navigationShell) => getPage(
      //     child: BottomBarPage(shell: navigationShell),
      //     state: state,
      //   ),
      //   branches: [
      //     StatefulShellBranch(
      //       navigatorKey: homeTabNavigatorKey,
      //       routes: [
      //         GoRoute(
      //           path: Homepage.routePath,
      //           name: Homepage.routeName,
      //           pageBuilder: (context, state) =>
      //               getPage(child: const Homepage(), state: state),
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       navigatorKey: complaintsTabNavigatorKey,
      //       routes: [
      //         GoRoute(
      //           path: '/complaints',
      //           name: '/complaints',
      //           pageBuilder: (context, state) =>
      //               getPage(child: const Homepage(), state: state),
      //         ),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       navigatorKey: settingsTabNavigatorKey,
      //       routes: [
      //         GoRoute(
      //           path: '/settings',
      //           name: '/settings',
      //           pageBuilder: (context, state) =>
      //               getPage(child: const Homepage(), state: state),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),

];
