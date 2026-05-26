class Expense {
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.currencyCode,
    required this.spentAt,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  final int id;
  final String title;
  final double amount;
  final String currencyCode;
  final String? notes;
  final DateTime spentAt;
  final DateTime createdAt;
  final DateTime updatedAt;
}
