import 'package:flutter_local_notifications/flutter_local_notifications.dart';
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {

  print("Notification tapped in background: ${details.actionId}");
  
  
  if (details.actionId == 'id_food') {

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
  print("Notification tapped in foreground: ${details.actionId}");
}
  static String _mapActionIdToCategory(String actionId) {
    switch (actionId) {
      case 'id_food': return 'Food';
      case 'id_travel': return 'Transport';
      case 'id_shopping': return 'Shopping';
      default: return 'Others';
    }
  }

  static Future<void> showCategorizationAlert(double amount) async {
    const androidDetails = AndroidNotificationDetails(
      'expense_tracker_01', 
      'Transaction Alerts',
      channelDescription: 'Alerts for categorizing automated expenses', 
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher', 
      actions: [
        AndroidNotificationAction('id_food', '🍔 Food', showsUserInterface: true),
        AndroidNotificationAction('id_travel', '🚗 Travel', showsUserInterface: true),
        AndroidNotificationAction('id_shopping', '🛍️ Shopping', showsUserInterface: true),
      ],
    );

    await _notifications.show(
      DateTime.now().millisecond, 
      'New Expense Detected!',
      'You spent ₹$amount. Tap a category to save.',
      const NotificationDetails(android: androidDetails),
      payload: amount.toString(),
    );
  }
}