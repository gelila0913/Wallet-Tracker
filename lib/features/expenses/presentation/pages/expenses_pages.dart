import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_card.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch initial read load sequence event
    context.read<ExpenseBloc>().add(LoadExpensesEvent());
  }

  @override
  Widget build(BuildContext context) {
    const Color purpleAccent = Color(0xFF9333EA);
    const Color bgCanvas = Color(0xFFF8FAFC);
    const Color textDark = Color(0xFF0F172A);
    const Color textMuted = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row Block matching your screenshot design layout
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: textDark),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF2563EB), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expenses',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark, letterSpacing: -0.5),
                        ),
                        Text(
                          'Manage your daily expenses',
                          style: TextStyle(fontSize: 13, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // We will link your Add Expense overlay sheet or workflow here next
                    },
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: const Text('Add Expense', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purpleAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Daily Budget Tracker Panel Metric Box Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Daily Budget', style: TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('\$100.00', style: TextStyle(color: textDark, fontSize: 28, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: textMuted, size: 20),
                          onPressed: () {},
                          style: IconButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Total Sum Aggregator State Card Widget Block
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  double totalSum = 0.00;
                  if (state is ExpenseLoaded) {
                    totalSum = state.expenses.fold(0.0, (sum, item) => sum + item.amount);
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Expenses', style: TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Text(
                          '\$${totalSum.toStringAsFixed(2)}',
                          style: const TextStyle(color: textDark, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Search Control Box Input Decorator
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search expenses...',
                  prefixIcon: const Icon(Icons.search_rounded, color: textMuted),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: purpleAccent, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Reactive Activity Stream Feed Core Block
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(color: purpleAccent),
                      ),
                    );
                  } else if (state is ExpenseLoaded) {
                    if (state.expenses.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text('No expense metrics recorded yet.', style: TextStyle(color: textMuted)),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.expenses.length,
                      itemBuilder: (context, index) {
                        return ExpenseCard(expense: state.expenses[index]);
                      },
                    );
                  } else if (state is ExpenseError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text(state.message, style: const TextStyle(color: Colors.redAccent)),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}