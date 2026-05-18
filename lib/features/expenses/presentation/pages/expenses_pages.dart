import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_card.dart';
import '../../domain/entities/expense.dart';

class ExpensesPage extends StatefulWidget {
  final ValueNotifier<double> budgetNotifier;

  const ExpensesPage({super.key, required this.budgetNotifier});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  String _searchQuery = '';
  DateTime? _selectedDate;
  final Set<String> _expandedDateGroups = {};

  @override
  void initState() {
    super.initState();
    // Dispatch initial read load sequence event
    context.read<ExpenseBloc>().add(LoadExpensesEvent());
  }

  Future<void> _pickDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (selected != null) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
                      _showAddExpenseDialog(context);
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
                        ValueListenableBuilder<double>(
                          valueListenable: widget.budgetNotifier,
                          builder: (context, budget, _) {
                            return Text('\$${budget.toStringAsFixed(2)}', style: const TextStyle(color: textDark, fontSize: 28, fontWeight: FontWeight.bold));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: textMuted, size: 20),
                          onPressed: () {
                            _showEditBudgetDialog(context);
                          },
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

              // Today's Expense Total Card
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  double todaySum = 0.00;
                  if (state is ExpenseLoaded) {
                    final now = DateTime.now();
                    todaySum = state.expenses
                        .where((item) =>
                            item.date.year == now.year &&
                            item.date.month == now.month &&
                            item.date.day == now.day)
                        .fold(0.0, (sum, item) => sum + item.amount);
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
                        const Text('Today\'s Total', style: TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Text(
                          '\$${todaySum.toStringAsFixed(2)}',
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
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search expenses...',
                  prefixIcon: const Icon(Icons.search_rounded, color: textMuted),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_selectedDate != null)
                        GestureDetector(
                          onTap: () => setState(() => _selectedDate = null),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.close, size: 18, color: Color(0xFF64748B)),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month_rounded, color: textMuted),
                        onPressed: () => _pickDate(context),
                      ),
                    ],
                  ),
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
              if (_selectedDate != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          'Showing expenses for ${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: textMuted, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: textMuted),
                      onPressed: () => setState(() => _selectedDate = null),
                    ),
                  ],
                ),
              ],
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
                    final filteredExpenses = state.expenses.where((expense) {
                      final queryText = '${expense.title} ${expense.category}'.toLowerCase();
                      final matchesSearch = _searchQuery.isEmpty || queryText.contains(_searchQuery.toLowerCase());
                      final matchesDate = _selectedDate == null || (
                        expense.date.year == _selectedDate!.year &&
                        expense.date.month == _selectedDate!.month &&
                        expense.date.day == _selectedDate!.day
                      );
                      return matchesSearch && matchesDate;
                    }).toList();

                    if (filteredExpenses.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            _searchQuery.isNotEmpty || _selectedDate != null
                              ? 'No expenses match this filter.'
                              : 'No expense metrics recorded yet.',
                            style: const TextStyle(color: textMuted),
                          ),
                        ),
                      );
                    }

                    final Map<String, List<Expense>> groupedExpenses = {};
                    for (final expense in filteredExpenses) {
                      final dateKey = _formatDate(expense.date);
                      groupedExpenses.putIfAbsent(dateKey, () => []).add(expense);
                    }

                    final sortedDateKeys = groupedExpenses.keys.toList()
                      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedDateKeys.length,
                      itemBuilder: (context, index) {
                        final dayKey = sortedDateKeys[index];
                        final dayExpenses = groupedExpenses[dayKey]!;
                        final dayTotal = dayExpenses.fold(0.0, (sum, item) => sum + item.amount);
                        final isExpanded = _expandedDateGroups.contains(dayKey);

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isExpanded) {
                                    _expandedDateGroups.remove(dayKey);
                                  } else {
                                    _expandedDateGroups.add(dayKey);
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dayKey,
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textDark),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '${dayExpenses.length} expense${dayExpenses.length == 1 ? '' : 's'} • Total: \$${dayTotal.toStringAsFixed(2)}',
                                            style: const TextStyle(fontSize: 13, color: textMuted),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                                      color: textMuted,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded)
                              Column(
                                children: dayExpenses
                                    .map((expense) => ExpenseCard(expense: expense))
                                    .toList(),
                              ),
                          ],
                        );
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

  void _showEditBudgetDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: widget.budgetNotifier.value.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Daily Budget'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Budget Amount',
            prefixText: '\$',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newBudget = double.tryParse(controller.text);
              if (newBudget != null) {
                widget.budgetNotifier.value = newBudget;
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController categoryController = TextEditingController(text: 'General');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Expense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text);
                    if (titleController.text.isNotEmpty && amount != null) {
                      // We need to import the entity for the model if not there, but it is typically handled by bloc event.
                      // Wait, we need Expense entity! The import might be missing.
                      // We will add import '../../domain/entities/expense.dart'; at the top of the file if needed.
                      // Let's create an expense with a dummy ID using DateTime and current date.
                      final newExpense = Expense(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        amount: amount,
                        category: categoryController.text,
                        date: DateTime.now(),
                      );
                      context.read<ExpenseBloc>().add(AddExpenseEvent(newExpense));
                      Navigator.pop(ctx);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid title and numeric amount'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF9333EA),
                  ),
                  child: const Text('Save Expense', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}