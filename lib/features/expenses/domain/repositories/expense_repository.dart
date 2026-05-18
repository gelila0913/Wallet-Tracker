import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<Expense> addExpense(Expense expense);
  Future<Expense> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
}