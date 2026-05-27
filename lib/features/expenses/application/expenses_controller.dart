import 'package:app_for_finance/core/services/usd_exchange_rate_service.dart';
import 'package:app_for_finance/features/expenses/data/expense_repository_local.dart';
import 'package:app_for_finance/features/expenses/data/local/app_database.dart';
import 'package:app_for_finance/features/expenses/domain/expense.dart';
import 'package:app_for_finance/features/expenses/domain/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const availableCurrencies = ['USD', 'EUR', 'MXN', 'DOP'];

/// Default currency for bank email imports (Dominican peso).
const defaultImportCurrency = 'DOP';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryLocal(ref.watch(appDatabaseProvider));
});

final usdExchangeRateServiceProvider = Provider<UsdExchangeRateService>((ref) {
  return const UsdExchangeRateService();
});

final filtersProvider = StateProvider<ExpenseFilters>((ref) {
  return const ExpenseFilters();
});

final expensesProvider = StreamProvider<List<Expense>>((ref) {
  return ref.watch(expenseRepositoryProvider).watchAll();
});

final filteredExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final expenses = ref.watch(expensesProvider);
  final filters = ref.watch(filtersProvider);
  return expenses.whenData((list) {
    return list
        .where((expense) {
          final query = filters.searchQuery.toLowerCase();
          final matchesQuery =
              filters.searchQuery.isEmpty ||
              expense.title.toLowerCase().contains(query) ||
              (expense.notes?.toLowerCase().contains(query) ?? false);
          final matchesCurrency =
              filters.currencyCode == null ||
              expense.currencyCode == filters.currencyCode;
          final matchesFrom =
              filters.from == null ||
              !expense.spentAt.isBefore(_normalizeDate(filters.from!));
          final matchesTo =
              filters.to == null ||
              !expense.spentAt.isAfter(_dayEnd(filters.to!));
          return matchesQuery && matchesCurrency && matchesFrom && matchesTo;
        })
        .toList(growable: false);
  });
});

final summaryProvider = Provider<AsyncValue<ExpenseSummary>>((ref) {
  final expenses = ref.watch(filteredExpensesProvider);
  return expenses.whenData((list) => ExpenseSummary.fromList(list));
});

class ExpenseFilters {
  const ExpenseFilters({
    this.searchQuery = '',
    this.currencyCode,
    this.from,
    this.to,
  });

  final String searchQuery;
  final String? currencyCode;
  final DateTime? from;
  final DateTime? to;

  ExpenseFilters copyWith({
    String? searchQuery,
    String? currencyCode,
    bool clearCurrency = false,
    DateTime? from,
    bool clearFrom = false,
    DateTime? to,
    bool clearTo = false,
  }) {
    return ExpenseFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      currencyCode: clearCurrency ? null : (currencyCode ?? this.currencyCode),
      from: clearFrom ? null : (from ?? this.from),
      to: clearTo ? null : (to ?? this.to),
    );
  }
}

class ExpenseSummary {
  const ExpenseSummary({
    required this.todayTotal,
    required this.monthTotal,
    required this.grandTotal,
    required this.itemCount,
  });

  final double todayTotal;
  final double monthTotal;
  final double grandTotal;
  final int itemCount;

  factory ExpenseSummary.fromList(List<Expense> expenses) {
    final now = DateTime.now();
    final today = _normalizeDate(now);
    final monthStart = DateTime(now.year, now.month, 1);

    var todayTotal = 0.0;
    var monthTotal = 0.0;
    var grandTotal = 0.0;
    for (final expense in expenses) {
      final usdAmount = expense.amountInUsd;
      grandTotal += usdAmount;
      final spentDate = _normalizeDate(expense.spentAt);
      if (spentDate == today) {
        todayTotal += usdAmount;
      }
      if (!spentDate.isBefore(monthStart)) {
        monthTotal += usdAmount;
      }
    }

    return ExpenseSummary(
      todayTotal: todayTotal,
      monthTotal: monthTotal,
      grandTotal: grandTotal,
      itemCount: expenses.length,
    );
  }
}

DateTime _normalizeDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

DateTime _dayEnd(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);
}
