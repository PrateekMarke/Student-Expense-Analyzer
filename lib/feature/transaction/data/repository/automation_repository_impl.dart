import 'package:another_telephony/telephony.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:student_expense_analyzer/core/services/notification_manager.dart';
import 'package:student_expense_analyzer/feature/transaction/data/services/automation_parser.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/entites/dected_transaction.dart';
import 'package:workmanager/workmanager.dart';


@pragma('vm:entry-point')
Future<bool> backgroudMessageHandler(SmsMessage message) async {
 
  print("Background SMS received: ${message.body}");
  final body = message.body ?? "";
  

  if (AutomationParser.isTransaction(body)) {
    final amount = AutomationParser.extractAmount(body);
    
    if (amount != null) {
      await NotificationManager.showCategorizationAlert(amount);
    }
  }

  return true;
}

class AutomationRepositoryImpl {
  final _telephony = Telephony.instance;

  void initSMSListener(Function(DetectedTransaction) onDetected) {
    _telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        final body = message.body ?? "";
        if (AutomationParser.isTransaction(body)) {
          final amount = AutomationParser.extractAmount(body);
          if (amount != null) {
            onDetected(
              DetectedTransaction(amount: amount, rawBody: body, source: "SMS"),
            );
          }
        }
      },
      listenInBackground: true,
      onBackgroundMessage: backgroudMessageHandler,
    );
  }

  void initNotificationListener(
    Function(DetectedTransaction) onDetected,
  ) async {
    bool status = await NotificationListenerService.isPermissionGranted();
    if (!status) {
      await NotificationListenerService.requestPermission();
    }
    NotificationListenerService.notificationsStream.listen((event) {
  if (event.hasRemoved == true || event.packageName == "com.example.student_expense_analyzer") return;
  final String title = event.title ?? "";
  final String content = event.content ?? "";
  final fullText = "$title $content";


  if (AutomationParser.isTransaction(fullText)) {
    final amount = AutomationParser.extractAmount(fullText);
    if (amount != null) {
      
    
      onDetected(DetectedTransaction(amount: amount, rawBody: fullText, source: event.packageName ?? "App"));
      Workmanager().registerOneOffTask(
        "transaction_${DateTime.now().millisecondsSinceEpoch}", 
        "process_transaction",
        inputData: {
          'amount': amount,
          'body': fullText,
        },
      );
    }
  }
});
  }
}
