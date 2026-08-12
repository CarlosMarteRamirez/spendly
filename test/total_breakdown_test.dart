import 'package:app_for_finance/app/app.dart';
import 'package:app_for_finance/features/expenses/application/expenses_controller.dart';
import 'package:app_for_finance/features/expenses/domain/expense.dart';
import 'package:app_for_finance/features/expenses/domain/total_breakdown.dart';
import 'package:app_for_finance/features/expenses/presentation/total_breakdown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TotalBreakdownSummary Unit Tests', () {
    test('calculates correct breakdown grouped by year and month', () {
      final now = DateTime(2026, 8, 15);
      final expenses = [
        Expense(
          id: 1,
          title: 'Grocery',
          amount: 100.0,
          currencyCode: 'USD',
          spentAt: DateTime(2026, 8, 10),
          createdAt: now,
          updatedAt: now,
        ),
        Expense(
          id: 2,
          title: 'Restaurant',
          amount: 50.0,
          currencyCode: 'USD',
          spentAt: DateTime(2026, 8, 12),
          createdAt: now,
          updatedAt: now,
        ),
        Expense(
          id: 3,
          title: 'Flights',
          amount: 300.0,
          currencyCode: 'USD',
          spentAt: DateTime(2026, 7, 20),
          createdAt: now,
          updatedAt: now,
        ),
        Expense(
          id: 4,
          title: 'Laptop',
          amount: 1000.0,
          currencyCode: 'USD',
          spentAt: DateTime(2025, 12, 25),
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final summary = TotalBreakdownSummary.fromExpenses(expenses);

      expect(summary.grandTotal, equals(1450.0));
      expect(summary.totalItems, equals(4));
      expect(summary.yearlyBreakdowns.length, equals(2)); // 2026 and 2025

      final year2026 = summary.yearlyBreakdowns.firstWhere((y) => y.year == 2026);
      expect(year2026.yearTotal, equals(450.0));
      expect(year2026.itemCount, equals(3));
      expect(year2026.months.length, equals(2)); // August and July

      final august2026 = year2026.months.firstWhere((m) => m.month == 8);
      expect(august2026.totalAmount, equals(150.0));
      expect(august2026.itemCount, equals(2));
      expect(august2026.monthName, equals('August'));

      final july2026 = year2026.months.firstWhere((m) => m.month == 7);
      expect(july2026.totalAmount, equals(300.0));
      expect(july2026.itemCount, equals(1));
      expect(july2026.monthName, equals('July'));

      final year2025 = summary.yearlyBreakdowns.firstWhere((y) => y.year == 2025);
      expect(year2025.yearTotal, equals(1000.0));
      expect(year2025.itemCount, equals(1));
    });

    test('returns empty breakdown when expenses list is empty', () {
      final summary = TotalBreakdownSummary.fromExpenses([]);
      expect(summary.grandTotal, equals(0.0));
      expect(summary.totalItems, equals(0));
      expect(summary.yearlyBreakdowns, isEmpty);
    });
  });

  group('TotalBreakdownPage Widget Tests', () {
    testWidgets('renders empty state when no expenses', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            totalBreakdownProvider.overrideWithValue(
              AsyncData(TotalBreakdownSummary.fromExpenses([])),
            ),
          ],
          child: const MaterialApp(
            home: TotalBreakdownPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Total breakdown'), findsOneWidget);
      expect(find.text('No expenses recorded'), findsOneWidget);
    });

    testWidgets('renders breakdown summary cards and month tiles', (WidgetTester tester) async {
      final expenses = [
        Expense(
          id: 1,
          title: 'Supermarket',
          amount: 200.0,
          currencyCode: 'USD',
          spentAt: DateTime(2026, 8, 5),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            totalBreakdownProvider.overrideWithValue(
              AsyncData(TotalBreakdownSummary.fromExpenses(expenses)),
            ),
          ],
          child: const MaterialApp(
            home: TotalBreakdownPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Total breakdown'), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('August'), findsOneWidget);

      // Expand month tile by tapping it
      await tester.tap(find.text('August'));
      await tester.pumpAndSettle();

      expect(find.text('Supermarket'), findsOneWidget);
    });

    testWidgets('tapping Total pill in main app opens TotalBreakdownPage', (WidgetTester tester) async {
      final now = DateTime.now();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            expensesProvider.overrideWith((ref) => Stream.value([
              Expense(
                id: 1,
                title: 'Test Expense',
                amount: 100.0,
                currencyCode: 'USD',
                spentAt: now,
                createdAt: now,
                updatedAt: now,
              ),
            ])),
          ],
          child: const ExpensesApp(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Find Total stat pill and tap it
      final totalPillFinder = find.text('Total');
      expect(totalPillFinder, findsOneWidget);

      await tester.tap(totalPillFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Total breakdown'), findsOneWidget);
    });
  });
}
