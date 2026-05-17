class TransactionEntity {
  final String id;
  final String personName;
  final String description;
  final double amount;
  final bool isYouOwe; // true if 'You Owe', false if 'They Owe'
  final bool isPaid;   // true if 'Paid', false if 'Pending'
  final DateTime date;

  TransactionEntity({
    required this.id,
    required this.personName,
    required this.description,
    required this.amount,
    required this.isYouOwe,
    required this.isPaid,
    required this.date,
  });
}
