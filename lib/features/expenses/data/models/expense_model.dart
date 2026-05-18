import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.category,
    required super.date,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawDate = json['date'] as String?;
    return ExpenseModel(
      id: rawId is int ? rawId.toString() : rawId as String,
      title: (json['title'] ?? json['name']) as String? ?? 'Untitled Expense',
      amount: ((json['amount'] ?? json['price']) as num?)?.toDouble() ?? 0.0,
      category: (json['category'] as String?) ?? 'General',
      date: rawDate != null
          ? DateTime.parse(rawDate)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': amount,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }
}