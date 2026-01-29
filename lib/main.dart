import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student_expense_analyzer/core/constants/keys.dart';
import 'package:student_expense_analyzer/config/route/app_router.dart';
import 'package:student_expense_analyzer/config/theme/app_theme.dart';
import 'package:student_expense_analyzer/core/get_it/service_locator.dart';
import 'package:student_expense_analyzer/core/services/notification_manager.dart';
import 'package:student_expense_analyzer/firebase_options.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    try {
      if (task == "process_transaction_task") {
        final double amount = inputData?['amount'] ?? 0.0;
        await NotificationManager.init(); 
        await NotificationManager.showCategorizationAlert(amount);
      }
      return Future.value(true);
    } catch (e) {
      print("Workmanager Error: $e");
      return Future.value(false);
    }
  });
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  HydratedBloc.storage = storage;
  await NotificationManager.init();
  await initInjection();
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
