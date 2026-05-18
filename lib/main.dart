import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── EXPENSES IMPORT BOUNDARIES ───
import 'features/dashboard/dashboard.dart';
import 'features/expenses/data/datasources/expense_remote_datasource.dart';
import 'features/expenses/data/repositories/expense_repository_impl.dart';
import 'features/expenses/presentation/bloc/expense_bloc.dart';

// ─── TRANSACTIONS IMPORT BOUNDARIES ───
import 'features/transaction/data/datasources/transaction_local_datasource.dart';
import 'features/transaction/data/repositories/transaction_repository_impl.dart';
import 'features/transaction/presentation/bloc/transaction_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Initialize Expenses Concrete Infrastructure
    final expenseDataSource = ExpenseRemoteDataSourceImpl();
    final expenseRepository = ExpenseRepositoryImpl(remoteDataSource: expenseDataSource);

    // 2. Initialize Transactions Concrete Infrastructure
    final transactionLocalDataSource = TransactionLocalDataSourceImpl();
    final transactionRepository = TransactionRepositoryImpl(localDataSource: transactionLocalDataSource);

    return MultiBlocProvider(
      providers: [
        // Provide your existing Expenses Business Controller
        BlocProvider<ExpenseBloc>(
          create: (context) => ExpenseBloc(repository: expenseRepository),
        ),
        
        // Provide your new Transactions Business Controller globally
        BlocProvider<TransactionBloc>(
          create: (context) => TransactionBloc(repository: transactionRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Wallet-Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00829B), // Adjusted theme seed color to match your design system accent cyan
          ),
          useMaterial3: true,
        ),
        home: const DashboardPage(),
      ),
    );
  }
}