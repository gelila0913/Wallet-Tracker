import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc({required this.repository}) : super(TransactionInitial()) {
    // Map event handlers
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<ToggleTransactionStatusEvent>(_onToggleTransactionStatus);
    on<EditTransactionEvent>(_onEditTransaction);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final transactions = await repository.getTransactions();
      emit(TransactionLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.addTransaction(event.transaction);
      // Reload up-to-date data following the mutation execution
      final transactions = await repository.getTransactions();
      emit(TransactionLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionError("Could not save new record: ${e.toString()}"));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.deleteTransaction(event.id);
      final transactions = await repository.getTransactions();
      emit(TransactionLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionError("Could not delete record: ${e.toString()}"));
    }
  }

  Future<void> _onToggleTransactionStatus(
    ToggleTransactionStatusEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.togglePaymentStatus(event.id);
      final transactions = await repository.getTransactions();
      emit(TransactionLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionError("Could not update payment status: ${e.toString()}"));
    }
  }

  Future<void> _onEditTransaction(
    EditTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await repository.editTransaction(event.transaction);
      final transactions = await repository.getTransactions();
      emit(TransactionLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionError("Could not edit record: ${e.toString()}"));
    }
  }
}