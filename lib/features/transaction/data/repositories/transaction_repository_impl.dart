import '../../domain/repositories/transaction_repository.dart';
import '../../domain/entities/transaction.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    try {
      final localModels = await localDataSource.getLastTransactions();
      // Cast the collection from Data models implicitly up to domain entities safely
      return localModels;
    } catch (e) {
      throw Exception("Failed to retrieve transaction registries: $e");
    }
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    final model = TransactionModel(
      id: transaction.id,
      personName: transaction.personName,
      description: transaction.description,
      amount: transaction.amount,
      isYouOwe: transaction.isYouOwe,
      isPaid: transaction.isPaid,
      date: transaction.date,
    );
    return await localDataSource.cacheTransaction(model);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    return await localDataSource.deleteTransaction(id);
  }

  @override
  Future<void> togglePaymentStatus(String id) async {
    // TODO: Implement toggle updates by fetching, changing boolean state, and re-saving
  }
}