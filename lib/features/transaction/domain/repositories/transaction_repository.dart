import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();
  Future<void> addTransaction(TransactionEntity transaction);
  Future<void> deleteTransaction(String id);
  Future<void> editTransaction(TransactionEntity transaction);
  Future<void> togglePaymentStatus(String id);
}