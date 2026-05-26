import 'package:app_for_finance/core/utils/formatters.dart';
import 'package:app_for_finance/features/expenses/domain/expense.dart';

const kUntitledExpenseLabel = 'Expense';

/// Title shown in lists; handles empty or generic import titles.
String expenseDisplayTitle(Expense expense) {
  final trimmed = expense.title.trim();
  if (trimmed.isEmpty) {
    return kUntitledExpenseLabel;
  }
  return trimmed;
}

/// Fallback title when importing from email without a clear merchant.
String importedExpenseFallbackTitle(DateTime spentAt) {
  return 'Bank · ${formatShortDate(spentAt)}';
}
