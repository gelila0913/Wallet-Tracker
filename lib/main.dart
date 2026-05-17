import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import your architecture layers
import 'features/dashboard/dashboard.dart';
import 'features/expenses/data/datasources/expense_remote_datasource.dart';
import 'features/expenses/data/repositories/expense_repository_impl.dart';
import 'features/expenses/presentation/bloc/expense_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Initialize the concrete data layer implementations
    final expenseDataSource = ExpenseRemoteDataSourceImpl();
    final expenseRepository = ExpenseRepositoryImpl(remoteDataSource: expenseDataSource);

    return MultiBlocProvider(
      providers: [
        // 2. Inject and provide the BLoC globally across the widget tree
        BlocProvider<ExpenseBloc>(
          create: (context) => ExpenseBloc(repository: expenseRepository),
        ),
      ],
      child: MaterialApp(
        title: 'ExpenseBook',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF9333EA),
          ),
          useMaterial3: true,
        ),
        home: const DashboardPage(),
      ),
    );
  }
}