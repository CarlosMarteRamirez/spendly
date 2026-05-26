import 'package:app_for_finance/features/expenses/domain/expense.dart';

class ExpenseDraft {
  const ExpenseDraft({
    required this.title,
    required this.amount,
    required this.currencyCode,
    required this.spentAt,
    this.notes,
  });

  final String title;
  final double amount;
  final String currencyCode;
  final DateTime spentAt;
  final String? notes;
}

abstract class ExpenseRepository {
  Stream<List<Expense>> watchAll();
  Future<int> create(ExpenseDraft draft);
  Future<void> update(int id, ExpenseDraft draft);
  Future<void> delete(int id);
}
