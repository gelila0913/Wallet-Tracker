import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import your architecture dependencies
import '../expenses/presentation/bloc/expense_bloc.dart';
import '../expenses/presentation/bloc/expense_state.dart';
import '../expenses/presentation/pages/expenses_pages.dart';
import '../transaction/presentation/pages/transactions_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double _zoomFactor = 1.0;
  final ValueNotifier<double> _budgetNotifier = ValueNotifier<double>(100.00);

  @override
  void dispose() {
    _budgetNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color purpleAccent = Color(0xFF9333EA);
    const Color blueAccent = Color(0xFF2563EB);
    const Color greenAccent = Color(0xFF10B981);
    const Color redAccent = Color(0xFFEF4444);
    
    const Color bgCanvas = Color(0xFFF8FAFC); 
    const Color textDark = Color(0xFF0F172A);  
    const Color textMuted = Color(0xFF64748B); 

    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. App Header
              Row(
                children: [
                  Container(
                    
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Walet Tracker',
                        style: TextStyle(
                          fontSize: 26, 
                          fontWeight: FontWeight.bold, 
                          color: textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Smart expense tracking',
                        style: TextStyle(fontSize: 14, color: textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Dashboard zoom',
                    style: TextStyle(fontSize: 14 * _zoomFactor, color: textMuted),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.zoom_out, size: 20),
                    color: _zoomFactor > 0.8 ? textDark : textMuted.withValues(alpha: 128),
                    onPressed: _zoomFactor > 0.8
                        ? () => setState(() => _zoomFactor = (_zoomFactor - 0.1).clamp(0.8, 1.4))
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_in, size: 20),
                    color: _zoomFactor < 1.4 ? textDark : textMuted.withValues(alpha: 128),
                    onPressed: _zoomFactor < 1.4
                        ? () => setState(() => _zoomFactor = (_zoomFactor + 0.1).clamp(0.8, 1.4))
                        : null,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${(_zoomFactor * 100).round()}%',
                    style: TextStyle(fontSize: 13 * _zoomFactor, color: textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2. Metrics Horizontal Scroll Matrix (Made Dynamic)
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  double totalExpenses = 0.0;

                  if (state is ExpenseLoaded) {
                    totalExpenses = state.expenses.fold(0.0, (sum, item) => sum + item.amount);
                  }

                  return ValueListenableBuilder<double>(
                    valueListenable: _budgetNotifier,
                    builder: (context, budget, _) {
                      final double remaining = budget - totalExpenses;
                      final double usedPercentage = budget > 0 ? (totalExpenses / budget).clamp(0.0, 1.0) : 0.0;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildStandardMetricCard(
                              context: context,
                              title: 'Total Expenses',
                              value: '\$${totalExpenses.toStringAsFixed(2)}',
                              subtext: 'This month',
                              icon: Icons.trending_up_rounded,
                              accentColor: blueAccent,
                              scale: _zoomFactor,
                            ),
                            const SizedBox(width: 12),
                            _buildProgressBarMetricCard(
                              context: context,
                              title: 'Budget',
                              value: '\$${budget.toStringAsFixed(2)}',
                              usedPercentage: usedPercentage,
                              accentColor: purpleAccent,
                              scale: _zoomFactor,
                            ),
                            const SizedBox(width: 12),
                            _buildStandardMetricCard(
                              context: context,
                              title: 'Remaining',
                              value: '\$${remaining.toStringAsFixed(2)}',
                              subtext: 'Available to spend',
                              icon: Icons.add_rounded,
                              accentColor: greenAccent,
                              scale: _zoomFactor,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),

              // 3. Quick Actions Panel Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.015),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 19, 
                        fontWeight: FontWeight.bold, 
                        color: textDark,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildActionButton(
                      label: 'Add Expense',
                      icon: Icons.add_rounded,
                      backgroundColor: purpleAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ExpensesPage(budgetNotifier: _budgetNotifier)),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      label: 'Add Transaction',
                      icon: Icons.add_rounded,
                      backgroundColor: blueAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TransactionsPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 4. Recent Activity Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 19, 
                      fontWeight: FontWeight.bold, 
                      color: textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ExpensesPage(budgetNotifier: _budgetNotifier)),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'View all ',
                          style: TextStyle(
                            color: purpleAccent, 
                            fontWeight: FontWeight.w600, 
                            fontSize: 15,
                          ),
                        ),
                        Icon(Icons.arrow_forward_rounded, size: 16, color: purpleAccent),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Recent Activity Feed List Items (Made Dynamic)
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is ExpenseLoaded) {
                    if (state.expenses.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('No recent activities.', style: TextStyle(color: textMuted)),
                      );
                    }

                    // Display up to 3 elements for clean dashboard presentation previewing
                    final previewList = state.expenses.take(3).toList();

                    return Column(
                      children: previewList.map((expense) {
                        return _buildActivityRowItem(
                          title: expense.title,
                          timestamp: "${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}-${expense.date.day.toString().padLeft(2, '0')}",
                          amount: '-\$${expense.amount.toStringAsFixed(2)}',
                          amountColor: redAccent,
                        );
                      }).toList(),
                    );
                  }
                  
                  if (state is ExpenseError) {
                    return Text('Error updating stream: ${state.message}', style: const TextStyle(color: redAccent));
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

  // Helper Card Builder for Total Expenses & Remaining sections (Removed broken fixed heights)
  Widget _buildStandardMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color accentColor,
    double scale = 1.0,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4 * scale,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: const Color(0xFF64748B), fontSize: 13 * scale, fontWeight: FontWeight.w500)),
          SizedBox(height: 6 * scale),
          Text(
            value,
            style: TextStyle(color: const Color(0xFF0F172A), fontSize: 21 * scale, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            maxLines: 1,
          ),
          SizedBox(height: 16 * scale),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subtext, style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 11 * scale)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Card Builder for the Budget Card featuring a progress bar
  Widget _buildProgressBarMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required double usedPercentage,
    required Color accentColor,
    double scale = 1.0,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4 * scale,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: const Color(0xFF64748B), fontSize: 13 * scale, fontWeight: FontWeight.w500)),
          SizedBox(height: 6 * scale),
          Text(
            value,
            style: TextStyle(color: const Color(0xFF0F172A), fontSize: 21 * scale, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            maxLines: 1,
          ),
          SizedBox(height: 20 * scale),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usedPercentage,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(usedPercentage * 100).toStringAsFixed(1)}% used', 
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Custom Full-Width Elevated Action Buttons
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
    double scale = 1.0,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52 * scale,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20 * scale),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 16 * scale, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // Transaction feed list records mapping rows
  Widget _buildActivityRowItem({
    required String title,
    required String timestamp,
    required String amount,
    required Color amountColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF8FAFC), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp, 
                  style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amountColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}