
abstract class TransactionRepository {
  Future<void> createTransaction({
    required double amount,
    required String type,
    required String category,
  });
}