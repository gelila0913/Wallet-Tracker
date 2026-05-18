import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      final modelList = await remoteDataSource.getExpenses();
      // Safely upcast ExpenseModel items to abstract Expense entities
      return modelList;
    } catch (e) {
      // You can plug in custom failures/exceptions here later
      throw Exception('Failed to fetch expenses from source: $e');
    }
  }

  @override
  Future<Expense> addExpense(Expense expense) async {
    try {
      final model = ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        category: expense.category,
        date: expense.date,
      );
      return await remoteDataSource.addExpense(model);
    } catch (e) {
      throw Exception('Failed to save new record: $e');
    }
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    try {
      final model = ExpenseModel(
        id: expense.id,
        title: expense.title,
        amount: expense.amount,
        category: expense.category,
        date: expense.date,
      );
      return await remoteDataSource.updateExpense(model);
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await remoteDataSource.deleteExpense(id);
    } catch (e) {
      throw Exception('Failed to complete deletion routine: $e');
    }
  }
}