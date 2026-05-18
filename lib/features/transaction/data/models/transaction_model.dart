import '../../domain/entities/transaction.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.personName,
    required super.description,
    required super.amount,
    required super.isYouOwe,
    required super.isPaid,
    required super.date,
  });

  // Convert JSON map from database/API to TransactionModel
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      personName: json['personName'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      isYouOwe: json['isYouOwe'] as bool,
      isPaid: json['isPaid'] as bool,
      date: DateTime.parse(json['date'] as String),
    );
  }

  // Convert TransactionModel instance back to a JSON map for saving
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personName': personName,
      'description': description,
      'amount': amount,
      'isYouOwe': isYouOwe,
      'isPaid': isPaid,
      'date': date.toIso8601String(),
    };
  }
}