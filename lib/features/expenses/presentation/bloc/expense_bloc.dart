import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/expense_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;

  ExpenseBloc({required this.repository}) : super(ExpenseInitial()) {
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<EditExpenseEvent>(_onEditExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
    LoadExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await repository.getExpenses();
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseLoaded) {
      final currentList = (state as ExpenseLoaded).expenses;
      emit(ExpenseLoading());
      try {
        final addedExpense = await repository.addExpense(event.expense);
        emit(ExpenseLoaded([addedExpense, ...currentList]));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    } else {
      try {
        final addedExpense = await repository.addExpense(event.expense);
        emit(ExpenseLoaded([addedExpense]));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    }
  }

  Future<void> _onEditExpense(
    EditExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseLoaded) {
      final currentList = (state as ExpenseLoaded).expenses;
      emit(ExpenseLoading());
      try {
        final updatedExpense = await repository.updateExpense(event.expense);
        final updatedList = currentList.map((expense) {
          return expense.id == updatedExpense.id ? updatedExpense : expense;
        }).toList();
        emit(ExpenseLoaded(updatedList));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseLoaded) {
      final currentList = (state as ExpenseLoaded).expenses;
      emit(ExpenseLoading());
      try {
        await repository.deleteExpense(event.id);
        final updatedList = currentList.where((expense) => expense.id != event.id).toList();
        emit(ExpenseLoaded(updatedList));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    }
  }
}