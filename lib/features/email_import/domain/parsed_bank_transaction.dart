class ParsedBankTransaction {
  const ParsedBankTransaction({
    required this.amount,
    required this.currencyCode,
    required this.spentAt,
    required this.title,
    this.merchant,
    this.messageId,
  });

  final double amount;
  final String currencyCode;
  final DateTime spentAt;
  final String title;
  final String? merchant;
  final String? messageId;
}
