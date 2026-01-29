

class AutomationParser {
  static double? extractAmount(String text) {
   
    final regex = RegExp(r'(?:Rs\.?|INR|₹|spent|debited)\s?(\d+(?:\.\d{1,2})?)', caseSensitive: false);
    final match = regex.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)!);
    }
    return null;
  }

  static bool isTransaction(String text) {
    final body = text.toLowerCase();
    if (body.contains("tap a category to save")) {
    return false;
  }
    final keywords = [
      'debited', 'spent', 'paid', 'vpa', 'upi', 'hdfc', 'icici', 
      'sbi', 'axis', 'paytm', 'gpay', 'phonepe', 'bank'
    ];
    
    bool isExpense = body.contains('debited') || body.contains('paid to') || body.contains('spent');
    bool hasBankKeyword = keywords.any((k) => body.contains(k));
    
    return isExpense && hasBankKeyword;
  }
}