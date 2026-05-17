import 'package:flutter/material.dart';
import 'features/dashboard/dashboard.dart'; // Import your new dashboard file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpenseBook',
      debugShowCheckedModeBanner: false, // Removes the red debug banner from the top corner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9333EA), // Sets your main elegant purple color as the seed
        ),
        useMaterial3: true,
      ),
      // Sets your custom dashboard as the opening landing page of the app
      home: const DashboardPage(), 
    );
  }
}