import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Exact hex color extraction from your design images
    const Color purpleAccent = Color(0xFF9333EA);
    const Color blueAccent = Color(0xFF2563EB);
    const Color greenAccent = Color(0xFF10B981);
    const Color redAccent = Color(0xFFEF4444);
    
    const Color bgCanvas = Color(0xFFF8FAFC); // Clean off-white background
    const Color textDark = Color(0xFF0F172A);  // Deep slate for headers
    const Color textMuted = Color(0xFF64748B); // Cool gray for subtexts

    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. App Header (Icon box + App Title block)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: purpleAccent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined, 
                      color: Colors.white, 
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ExpenseBook',
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
              const SizedBox(height: 28),

              // 2. Metrics Horizontal Scroll Cards Matrix
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildStandardMetricCard(
                      title: 'Total Expenses',
                      value: '\$2450.50',
                      subtext: 'This month',
                      icon: Icons.trending_up_rounded,
                      accentColor: blueAccent,
                    ),
                    const SizedBox(width: 12),
                    _buildProgressBarMetricCard(
                      title: 'Budget',
                      value: '\$5000.00',
                      usedPercentage: 0.49, // 49.0% used indicator
                      accentColor: purpleAccent,
                    ),
                    const SizedBox(width: 12),
                    _buildStandardMetricCard(
                      title: 'Remaining',
                      value: '\$2549.50',
                      subtext: 'Available to spend',
                      icon: Icons.add_rounded,
                      accentColor: greenAccent,
                    ),
                  ],
                ),
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
                      color: Colors.black.withOpacity(0.015),
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
                        // Navigation link to your expenses screen goes here
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      label: 'Add Transaction',
                      icon: Icons.add_rounded,
                      backgroundColor: blueAccent,
                      onPressed: () {
                        // Navigation link to your transactions screen goes here
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
                    onPressed: () {},
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

              // Recent Activity Feed List Items
              _buildActivityRowItem(
                title: 'Groceries',
                timestamp: 'Today',
                amount: '-\$85.40',
                amountColor: redAccent,
              ),
              _buildActivityRowItem(
                title: 'John',
                timestamp: 'Yesterday',
                amount: '+\$200.00',
                amountColor: greenAccent,
              ),
              _buildActivityRowItem(
                title: 'Coffee',
                timestamp: '2 days ago',
                amount: '-\$5.50',
                amountColor: redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Card Builder for Total Expenses & Remaining sections
  Widget _buildStandardMetricCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      width: 142,
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1), // FIXED: Cleared '0新建F1F5F9' typo
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 21, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtext, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.08),
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
    required String title,
    required String value,
    required double usedPercentage,
    required Color accentColor,
  }) {
    return Container(
      width: 142,
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 21, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
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
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label, 
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 4),
              Text(
                timestamp, 
                style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
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