import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:student_expense_analyzer/core/get_it/service_locator.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/bloc/bloc/analytics_bloc.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/pages/analytics.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:student_expense_analyzer/feature/budget/presentation/pages/budget.dart';
import 'package:student_expense_analyzer/config/route/app_router.dart';
import 'package:student_expense_analyzer/core/pages/splash_screen.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/pages/home.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/pages/login.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/pages/main%20navigation.dart';
import 'package:student_expense_analyzer/feature/settings/presentation/pages/settings.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/pages/signup.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/automation_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/transcation_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/pages/transaction.dart';

final onboardingRoutes = <RouteBase>[
  GoRoute(
    path: SplashScreen.routePath,
    name: SplashScreen.routeName,
    pageBuilder: (context, state) =>
        getPage(child: const SplashScreen(), state: state),
  ),
  GoRoute(
    path: LoginPage.routePath,
    name: LoginPage.routeName,
    pageBuilder: (context, state) =>
        getPage(child: const LoginPage(), state: state),
  ),
  GoRoute(
    path: SignUpPage.routePath,
    name: SignUpPage.routeName,
    pageBuilder: (context, state) =>
        getPage(child: const SignUpPage(), state: state),
  ),

  StatefulShellRoute.indexedStack(
    parentNavigatorKey: Approuter.rootNavigatorKey,
    pageBuilder: (context, state, navigationShell) => getPage(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<AuthBloc>()),
          BlocProvider(create: (context) => sl<AutomationBloc>()),
          BlocProvider(create: (context) => sl<DashboardBloc>()),
          BlocProvider(create: (context) => sl<TransactionBloc>()),
          BlocProvider(create: (context) => sl<AnalyticsBloc>()),
        ],
        child: MainWrapperPage(navigationShell: navigationShell),
      ),
      state: state,
    ),
    branches: [
      StatefulShellBranch(
        navigatorKey: Approuter.homeTabNavigatorKey,
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: Approuter.transactionsTabNavigatorKey,
        routes: [
          GoRoute(
            path: '/transactions',
            builder: (context, state) => const TransactionsScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: Approuter.budgetTabNavigatorKey,
        routes: [
          GoRoute(
            path: '/budget',
            builder: (context, state) => const BudgetScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: Approuter.analyticsTabNavigatorKey,
        routes: [
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: Approuter.settingTabNavigatorKey,
        routes: [
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  ),
];
