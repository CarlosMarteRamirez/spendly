import 'package:app_for_finance/features/expenses/domain/expense.dart';

class MonthlyBreakdown {
  const MonthlyBreakdown({
    required this.year,
    required this.month,
    required this.totalAmount,
    required this.itemCount,
    required this.expenses,
    required this.percentageOfGrandTotal,
    required this.percentageOfYearTotal,
  });

  final int year;
  final int month;
  final double totalAmount;
  final int itemCount;
  final List<Expense> expenses;
  final double percentageOfGrandTotal;
  final double percentageOfYearTotal;

  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }
}

class YearlyBreakdown {
  const YearlyBreakdown({
    required this.year,
    required this.yearTotal,
    required this.itemCount,
    required this.months,
    required this.percentageOfGrandTotal,
  });

  final int year;
  final double yearTotal;
  final int itemCount;
  final List<MonthlyBreakdown> months;
  final double percentageOfGrandTotal;
}

class TotalBreakdownSummary {
  const TotalBreakdownSummary({
    required this.grandTotal,
    required this.totalItems,
    required this.yearlyBreakdowns,
    required this.maxMonthAmount,
  });

  final double grandTotal;
  final int totalItems;
  final List<YearlyBreakdown> yearlyBreakdowns;
  final double maxMonthAmount;

  factory TotalBreakdownSummary.fromExpenses(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return const TotalBreakdownSummary(
        grandTotal: 0,
        totalItems: 0,
        yearlyBreakdowns: [],
        maxMonthAmount: 0,
      );
    }

    var grandTotal = 0.0;
    for (final exp in expenses) {
      grandTotal += exp.amountInUsd;
    }

    // Group expenses by year and month
    final map = <int, Map<int, List<Expense>>>{};
    for (final exp in expenses) {
      final y = exp.spentAt.year;
      final m = exp.spentAt.month;
      map.putIfAbsent(y, () => {}).putIfAbsent(m, () => []).add(exp);
    }

    final sortedYears = map.keys.toList()..sort((a, b) => b.compareTo(a));
    var globalMaxMonth = 0.0;

    final yearlyBreakdowns = <YearlyBreakdown>[];

    for (final year in sortedYears) {
      final monthMap = map[year]!;
      final sortedMonths = monthMap.keys.toList()..sort((a, b) => b.compareTo(a));

      var yearTotal = 0.0;
      var yearItemCount = 0;

      // First pass to calculate year total
      for (final m in sortedMonths) {
        final exps = monthMap[m]!;
        for (final e in exps) {
          yearTotal += e.amountInUsd;
          yearItemCount++;
        }
      }

      final monthBreakdowns = <MonthlyBreakdown>[];
      for (final m in sortedMonths) {
        final exps = monthMap[m]!;
        var monthTotal = 0.0;
        for (final e in exps) {
          monthTotal += e.amountInUsd;
        }

        if (monthTotal > globalMaxMonth) {
          globalMaxMonth = monthTotal;
        }

        final pctGrand = grandTotal > 0 ? (monthTotal / grandTotal) : 0.0;
        final pctYear = yearTotal > 0 ? (monthTotal / yearTotal) : 0.0;

        monthBreakdowns.add(
          MonthlyBreakdown(
            year: year,
            month: m,
            totalAmount: monthTotal,
            itemCount: exps.length,
            expenses: List.unmodifiable(exps),
            percentageOfGrandTotal: pctGrand,
            percentageOfYearTotal: pctYear,
          ),
        );
      }

      final pctGrandYear = grandTotal > 0 ? (yearTotal / grandTotal) : 0.0;

      yearlyBreakdowns.add(
        YearlyBreakdown(
          year: year,
          yearTotal: yearTotal,
          itemCount: yearItemCount,
          months: List.unmodifiable(monthBreakdowns),
          percentageOfGrandTotal: pctGrandYear,
        ),
      );
    }

    return TotalBreakdownSummary(
      grandTotal: grandTotal,
      totalItems: expenses.length,
      yearlyBreakdowns: List.unmodifiable(yearlyBreakdowns),
      maxMonthAmount: globalMaxMonth,
    );
  }
}
