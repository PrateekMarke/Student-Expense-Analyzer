import 'package:intl/intl.dart';

class DateFormatter {
  static String formatReadable(DateTime dateTime) {
    final now = DateTime.now();
    final localDateTime = dateTime.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDay = DateTime(localDateTime.year, localDateTime.month, localDateTime.day);

    String dateLabel;
    
    if (transactionDay == today) {
      dateLabel = "Today";
    } else if (transactionDay == yesterday) {
      dateLabel = "Yesterday";
    } else if (now.difference(localDateTime).inDays < 7) {
      
      dateLabel = DateFormat('EEEE').format(localDateTime);
    } else {
     
      dateLabel = DateFormat('MMM d').format(localDateTime);
    }

    final String time = DateFormat('hh:mm a').format(localDateTime);
    return "$dateLabel, $time";
  }
}