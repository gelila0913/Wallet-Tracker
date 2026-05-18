import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  
  @override
  List<Object?> get props => [];
}

// Initial state before any data is requested
class TransactionInitial extends TransactionState {}

// State showing a loading indicator while fetching data
class TransactionLoading extends TransactionState {}

// State containing the successfully loaded transactions and computed totals
class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;
  final double totalYouOwe;
  final double totalTheyOwe;
  final int youOweCount;
  final int theyOweCount;

  TransactionLoaded({required this.transactions})
      : totalYouOwe = transactions
            .where((t) => t.isYouOwe && !t.isPaid)
            .fold(0.0, (sum, t) => sum + t.amount),
        totalTheyOwe = transactions
            .where((t) => !t.isYouOwe && !t.isPaid)
            .fold(0.0, (sum, t) => sum + t.amount),
        youOweCount = transactions.where((t) => t.isYouOwe && !t.isPaid).length,
        theyOweCount = transactions.where((t) => !t.isYouOwe && !t.isPaid).length;

  @override
  List<Object?> get props => [transactions, totalYouOwe, totalTheyOwe, youOweCount, theyOweCount];
}

// State representing a failure during data processing
class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}