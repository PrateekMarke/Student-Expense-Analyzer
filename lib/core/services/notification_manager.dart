import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:student_expense_analyzer/core/get_it/service_locator.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/entites/dected_transaction.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/usecase/create_tran.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/automation_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/automation_event.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  if (details.payload == null || details.actionId == null) return;

  final data = jsonDecode(details.payload!);
  final double amount = data['amount'];
  final String title = data['title'];
  final String type = data['type'];
  final String category = NotificationManager.mapActionIdToCategory(
    details.actionId!,
  );

  if (GetIt.I.isRegistered<CreateTransactionUseCase>()) {
    GetIt.I<CreateTransactionUseCase>().call(
      amount: amount,
      type: type,
      category: category,
      title: title,
    );
  }
}

class NotificationManager {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notifications.initialize(
      const InitializationSettings(android: androidInit),
      onDidReceiveNotificationResponse: _handleNotificationClick,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void _handleNotificationClick(NotificationResponse details) {
    if (details.payload == null || details.actionId == null) return;

    final data = jsonDecode(details.payload!);
    final double amount = data['amount'];
    final String title = data['title'];
    final String type = data['type'];
    final String category = mapActionIdToCategory(details.actionId!);

    sl<AutomationBloc>().add(
      CategorizeTransaction(
        DetectedTransaction(
          amount: amount,
          rawBody: "Categorized from notification",
          source: "Notification",
          title: title, type: type,
        ),
        category,
        title: title,
      ),
    );
  }

  static String mapActionIdToCategory(String actionId) {
    switch (actionId) {
      case 'id_food':
        return 'Food';
      case 'id_travel':
        return 'Transport';
      case 'id_shopping':
        return 'Shopping';
      default:
        return 'Others';
    }
  }

  static Future<void> showCategorizationAlert(
    double amount,
    String title,
    String type
  ) async {
    final String payload = jsonEncode({'amount': amount, 'title': title, 'type': type});

    final androidDetails = AndroidNotificationDetails(
      'expense_tracker_01',
      'Transaction Alerts',
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        const AndroidNotificationAction(
          'id_food',
          '🍔 Food',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'id_travel',
          '🚗 Travel',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'id_shopping',
          '🛍️ Shopping',
          showsUserInterface: true,
        ),
      ],
    );

    await _notifications.show(
      DateTime.now().millisecond,
      'New Expense: ₹$amount',
      'Transaction at $title. Tap to categorize.',
      NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }
}
