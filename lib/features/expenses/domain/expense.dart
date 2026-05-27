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
    this.usdConversionRate,
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
  final double? usdConversionRate;

  bool get isFromEmail => source == 'email';

  double get amountInUsd {
    if (currencyCode == 'USD') return amount;
    final rate = usdConversionRate;
    if (rate == null || rate <= 0) return amount;
    return amount / rate;
  }
}
