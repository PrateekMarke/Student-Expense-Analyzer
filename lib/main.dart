import 'package:flutter/material.dart';
import 'package:student_expense_analyzer/core/constants/keys.dart';
import 'package:student_expense_analyzer/config/route/app_router.dart';
import 'package:student_expense_analyzer/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Student Expense Analyser',

      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scaffoldMessengerKey: scaffoldMessangerKey,
      themeMode: ThemeMode.light,
      routerConfig: Approuter.router,
    );
  }
}
