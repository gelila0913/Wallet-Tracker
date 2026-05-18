import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

// Triggered when the Transactions screen first opens
class LoadTransactions extends TransactionEvent {}

// Triggered when submitting the "Add Transaction" form
class AddTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

// Triggered when tapping the trash bin icon
class DeleteTransactionEvent extends TransactionEvent {
  final String id;

  const DeleteTransactionEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// Triggered when tapping the checkmark circle to mark as Paid/Pending
class ToggleTransactionStatusEvent extends TransactionEvent {
  final String id;

  const ToggleTransactionStatusEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// Triggered when editing a transaction
class EditTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  const EditTransactionEvent(this.transaction);

  @override
  List<Object?> get props => [transaction];
}