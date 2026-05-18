import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../../domain/entities/transaction.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Dispatch initial load event when entering the screen
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TransactionError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Color(0xFFDC2626)),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is TransactionLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HEADER ROW (Fixed text-squishing bug with Expanded layout)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Transactions",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Manage debit and credit records",
                                style: TextStyle(color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showAddTransactionDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00829B), // Matching transaction accent cyan
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Add Transaction", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 2. TOTAL SUMMARIES (Calculated dynamically via BLoC state getters)
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            title: "You Owe",
                            amount: "ETB ${state.totalYouOwe.toStringAsFixed(2)}",
                            countLabel: "${state.youOweCount} records",
                            amountColor: const Color(0xFFDC2626), // Soft Red
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            title: "They Owe",
                            amount: "ETB ${state.totalTheyOwe.toStringAsFixed(2)}",
                            countLabel: "${state.theyOweCount} records",
                            amountColor: const Color(0xFF16A34A), // Soft Green
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 3. SEARCH FILTER BLOCK
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search by person name...",
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. SCROLLABLE LOG LIST
                    if (state.transactions.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            "No transaction entries logged yet.",
                            style: TextStyle(color: Color(0xFF64748B)),
                          ),
                        ),
                      )
                    else
                      Builder(
                        builder: (context) {
                          final filteredTransactions = state.transactions
                              .where((t) => t.personName.toLowerCase().contains(_searchQuery.toLowerCase()))
                              .toList();
                              
                          if (filteredTransactions.isEmpty && _searchQuery.isNotEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text("No transactions match your search.", style: TextStyle(color: Color(0xFF64748B))),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredTransactions.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = filteredTransactions[index];
                              return _buildTransactionCard(context, item);
                            },
                          );
                        }
                      ),
                  ],
                ),
              );
            }

            return const Center(child: Text("Initializing..."));
          },
        ),
      ),
    );
  }

  // Summary Balance Card Sub-Builder
  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required String countLabel,
    required Color amountColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(color: amountColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(countLabel, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
        ],
      ),
    );
  }

  // Individual Transaction Record Item Builder
  Widget _buildTransactionCard(BuildContext context, TransactionEntity item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Settlement toggle status control checkmark 
          IconButton(
            onPressed: () {
              context.read<TransactionBloc>().add(ToggleTransactionStatusEvent(item.id));
            },
            icon: Icon(
              item.isPaid ? Icons.check_circle : Icons.radio_button_unchecked,
              color: item.isPaid ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          
          // Transaction Primary Label & Status Row
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.personName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                    decoration: item.isPaid ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description, 
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
                const SizedBox(height: 8),
                
                // Status Badges (Uses flexible padding to clean up the cutting-off layout bug)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildBadge(
                      text: item.isYouOwe ? "You Owe" : "They Owe",
                      bgColor: item.isYouOwe ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                      textColor: item.isYouOwe ? const Color(0xFF991B1B) : const Color(0xFF166534),
                    ),
                    _buildBadge(
                      text: item.isPaid ? "Paid" : "Pending",
                      bgColor: const Color(0xFFF1F5F9),
                      textColor: const Color(0xFF475569),
                    ),
                  ],
                )
              ],
            ),
          ),
          
          // Ledger Amounts & Administration Controls
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${item.isYouOwe ? '-' : '+'}${item.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: item.isYouOwe ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF3B82F6), size: 20),
                    onPressed: () {
                      _showEditTransactionDialog(context, item);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Transaction'),
                          content: const Text('Are you sure you want to delete this transaction?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<TransactionBloc>().add(DeleteTransactionEvent(item.id));
                                Navigator.pop(ctx);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                              child: const Text('Delete', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // Helper Widget for Elastic Content Padding Badges
  Widget _buildBadge({required String text, required Color bgColor, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    bool isYouOwe = true;
    bool isPaid = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
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
                  const Text('Add Transaction', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Person Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Amount', prefixText: 'ETB '),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Type:'),
                      DropdownButton<bool>(
                        value: isYouOwe,
                        items: const [
                          DropdownMenuItem(value: true, child: Text('You Owe')),
                          DropdownMenuItem(value: false, child: Text('They Owe')),
                        ],
                        onChanged: (val) {
                          if (val != null) setStateBottomSheet(() => isYouOwe = val);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status:'),
                      DropdownButton<bool>(
                        value: isPaid,
                        items: const [
                          DropdownMenuItem(value: false, child: Text('Pending')),
                          DropdownMenuItem(value: true, child: Text('Paid')),
                        ],
                        onChanged: (val) {
                          if (val != null) setStateBottomSheet(() => isPaid = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final amount = double.tryParse(amountController.text);
                        if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty && amount != null) {
                          final newTransaction = TransactionEntity(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            personName: nameController.text,
                            description: descriptionController.text,
                            amount: amount,
                            isYouOwe: isYouOwe,
                            isPaid: isPaid,
                            date: DateTime.now(),
                          );
                          context.read<TransactionBloc>().add(AddTransactionEvent(newTransaction));
                          Navigator.pop(ctx);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields correctly'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF00829B),
                      ),
                      child: const Text('Save Transaction', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditTransactionDialog(BuildContext context, TransactionEntity transaction) {
    final TextEditingController nameController = TextEditingController(text: transaction.personName);
    final TextEditingController descriptionController = TextEditingController(text: transaction.description);
    final TextEditingController amountController = TextEditingController(text: transaction.amount.toStringAsFixed(2));
    bool isYouOwe = transaction.isYouOwe;
    bool isPaid = transaction.isPaid;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
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
                  const Text('Edit Transaction', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Person Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Amount', prefixText: 'ETB '),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Type:'),
                      DropdownButton<bool>(
                        value: isYouOwe,
                        items: const [
                          DropdownMenuItem(value: true, child: Text('You Owe')),
                          DropdownMenuItem(value: false, child: Text('They Owe')),
                        ],
                        onChanged: (val) {
                          if (val != null) setStateBottomSheet(() => isYouOwe = val);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status:'),
                      DropdownButton<bool>(
                        value: isPaid,
                        items: const [
                          DropdownMenuItem(value: false, child: Text('Pending')),
                          DropdownMenuItem(value: true, child: Text('Paid')),
                        ],
                        onChanged: (val) {
                          if (val != null) setStateBottomSheet(() => isPaid = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final amount = double.tryParse(amountController.text);
                        if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty && amount != null) {
                          final updatedTransaction = TransactionEntity(
                            id: transaction.id,
                            personName: nameController.text,
                            description: descriptionController.text,
                            amount: amount,
                            isYouOwe: isYouOwe,
                            isPaid: isPaid,
                            date: transaction.date,
                          );
                          context.read<TransactionBloc>().add(EditTransactionEvent(updatedTransaction));
                          Navigator.pop(ctx);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields correctly'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF00829B),
                      ),
                      child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
