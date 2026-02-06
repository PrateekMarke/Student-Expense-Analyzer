class AutomationParser {
  static double? extractAmount(String text) {
    final regex = RegExp(
      r'(?:Rs\.?|INR|₹|spent|debited)\s?(\d+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)!);
    }
    return null;
  }
  static String extractType(String text) {
    final body = text.toLowerCase();
    if (body.contains('credited') || body.contains('received') || body.contains('added')) {
      return 'deposit';
    }

    return 'withdrawal';
  }

  static String extractTitle(String text) {
    
    final merchantRegex = RegExp(
      r'(?:at|to|paid to)\s+([a-zA-Z0-9\s]+?)(?=\s+(?:\bon\b|\bfor\b|ref|link)|\.|$)',
      caseSensitive: false,
    );

    final match = merchantRegex.firstMatch(text);

    if (match != null) {
      String found = match.group(1)!.trim();

      return found.isNotEmpty
          ? found[0].toUpperCase() + found.substring(1)
          : "Transaction";
    }

    return "Recent Expense";
  }

  static bool isTransaction(String text) {
    final body = text.toLowerCase();
    if (body.contains("tap a category to save")) {
      return false;
    }
    final keywords = [
      'debited',
      'spent',
      'paid',
      'vpa',
      'upi',
      'hdfc',
      'icici',
      'sbi',
      'axis',
      'paytm',
      'gpay',
      'phonepe',
      'bank',
      'amazon',
      'flipkart',
      'paytm',
      'ola',
      'swiggy',
      'zomato',
      'netflix',
      'amazon prime',
    ];

    bool isExpense =
        body.contains('debited') ||
        body.contains('paid to') ||
        body.contains('spent');
    bool hasBankKeyword = keywords.any((k) => body.contains(k));

    return isExpense && hasBankKeyword;
  }
}
