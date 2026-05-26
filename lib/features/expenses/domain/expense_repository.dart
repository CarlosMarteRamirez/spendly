import 'package:app_for_finance/features/expenses/domain/expense.dart';

class ExpenseDraft {
  const ExpenseDraft({
    required this.title,
    required this.amount,
    required this.currencyCode,
    required this.spentAt,
    this.notes,
    this.source = 'manual',
    this.externalId,
  });

  final String title;
  final double amount;
  final String currencyCode;
  final DateTime spentAt;
  final String? notes;
  final String source;
  final String? externalId;
}

abstract class ExpenseRepository {
  Stream<List<Expense>> watchAll();
  Future<int> create(ExpenseDraft draft);
  Future<void> update(int id, ExpenseDraft draft);
  Future<void> delete(int id);
  Future<bool> isEmailImported(String messageId);
  Future<int?> createFromEmailIfNew(ExpenseDraft draft, String messageId);
}
