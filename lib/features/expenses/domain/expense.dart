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
    this.source = 'manual',
    this.externalId,
  });

  final int id;
  final String title;
  final double amount;
  final String currencyCode;
  final String? notes;
  final DateTime spentAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String source;
  final String? externalId;

  bool get isFromEmail => source == 'email';
}
