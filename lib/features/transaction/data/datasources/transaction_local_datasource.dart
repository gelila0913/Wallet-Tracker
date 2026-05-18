import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getLastTransactions();
  Future<void> cacheTransaction(TransactionModel transactionToCache);
  Future<void> deleteTransaction(String id);
  Future<void> editTransaction(TransactionModel transaction);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final List<TransactionModel> _mockDatabase = [
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

  TransactionLocalDataSourceImpl();

  @override
  Future<List<TransactionModel>> getLastTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockDatabase);
  }

  @override
  Future<void> cacheTransaction(TransactionModel transactionToCache) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockDatabase.insert(0, transactionToCache);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockDatabase.removeWhere((element) => element.id == id);
  }

  @override
  Future<void> editTransaction(TransactionModel transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockDatabase.indexWhere((element) => element.id == transaction.id);
    if (index != -1) {
      _mockDatabase[index] = transaction;
    }
  }
}