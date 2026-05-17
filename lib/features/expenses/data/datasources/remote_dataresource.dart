import '../models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseModel>> getExpenses();
  Future<void> addExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  // Simulate a local cache or raw database tracker for testing
  final List<ExpenseModel> _mockDatabase = [
    ExpenseModel(
      id: '1',
      title: 'Groceries',
      amount: 85.40,
      category: 'Food',
      date: DateTime(2026, 1, 15),
    ),
    ExpenseModel(
      id: '2',
      title: 'Gas',
      amount: 45.00,
      category: 'Transport',
      date: DateTime(2026, 1, 14),
    ),
    ExpenseModel(
      id: '3',
      title: 'Movie Tickets',
      amount: 30.00,
      category: 'Entertainment',
      date: DateTime(2026, 1, 13),
    ),
  ];

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    // Simulate API Network Delay
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_mockDatabase);
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDatabase.insert(0, expense); // Prepend new items to the top
  }

  @override
  Future<void> deleteExpense(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _mockDatabase.removeWhere((element) => element.id == id);
  }
}