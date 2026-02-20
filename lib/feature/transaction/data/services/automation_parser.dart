class AutomationParser {
  static double? extractAmount(String text) {
    final regex = RegExp(
      r'(?:Rs\.?|INR|₹|spent|debited|received|credited|amt)\s?[\s\w]*?(\d{1,3}(?:,\d{3})*(?:\.\d{1,2})?|\d+(?:\.\d{1,2})?)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(text);
    if (match != null) {
      String amountStr = match.group(1)!.replaceAll(',', '');
      return double.tryParse(amountStr);
    }
    return null;
  }

  static String extractType(String text) {
    final body = text.toLowerCase();
    if (body.contains('credited') ||
        body.contains('received') ||
        body.contains('added')) {
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

    // Dynamic fallback for income vs expense
    return extractType(text) == 'deposit' ? "Recent Income" : "Recent Expense";
  }

  static bool isTransaction(String text) {
    final body = text.toLowerCase();
    if (body.contains("tap a category to save")) {
      return false;
    }

    final keywords = [
      'debited', 'spent', 'paid', 'vpa', 'upi', 'hdfc', 'icici', 'sbi',
      'axis', 'paytm', 'gpay', 'phonepe', 'bank', 'amazon', 'flipkart',
      'ola', 'swiggy', 'zomato', 'netflix', 'amazon prime',
      'credited', 'received', 'added', // Added income keywords
    ];

    // Logic updated: Detect if it's an expense OR an income
    bool isExpense =
        body.contains('debited') ||
        body.contains('paid to') ||
        body.contains('spent');
    bool isIncome =
        body.contains('credited') ||
        body.contains('received') ||
        body.contains('added');

    bool hasBankKeyword = keywords.any((k) => body.contains(k));

    return (isExpense || isIncome) && hasBankKeyword;
  }
}
