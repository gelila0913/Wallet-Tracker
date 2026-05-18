import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getLastTransactions();
  Future<void> cacheTransaction(TransactionModel transactionToCache);
  Future<void> deleteTransaction(String id);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  // Inject your database helper or SharedPreferences instance here
  // e.g., final SharedPreferences sharedPreferences;
  
  TransactionLocalDataSourceImpl();

  @override
  Future<List<TransactionModel>> getLastTransactions() async {
    // TODO: Implement actual database reading logic
    // Returning dummy data that mimics your current running UI:
    return [
      TransactionModel(
        id: '1',
        personName: 'John',
        description: 'Loan repayment',
        amount: 200.0,
        isYouOwe: true,
        isPaid: true,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TransactionModel(
        id: '2',
        personName: 'Sarah',
        description: 'Rent split',
        amount: 150.0,
        isYouOwe: false,
        isPaid: false,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<void> cacheTransaction(TransactionModel transactionToCache) async {
    // TODO: Write code to persist transaction to local storage file system
  }

  @override
  Future<void> deleteTransaction(String id) async {
    // TODO: Remove entry matching the specific UUID id
  }
}