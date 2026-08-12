import 'package:app_for_finance/app/app.dart';
import 'package:app_for_finance/features/expenses/application/expenses_controller.dart';
import 'package:app_for_finance/features/expenses/domain/expense.dart';
import 'package:app_for_finance/features/expenses/presentation/expense_form_page.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('app smoke test renders expenses screen', (
    WidgetTester tester,
  ) async {
    final now = DateTime.now();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expensesProvider.overrideWith((ref) => Stream.value([
            Expense(
              id: 1,
              title: 'Sample Expense',
              amount: 25.0,
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

    expect(find.text('My expenses'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Search by title'), findsOneWidget);
  });

  testWidgets('expense form validates required fields', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ExpenseFormPage()),
      ),
    );
    await tester.pump();

    final formState = tester.state<FormState>(find.byType(Form));
    expect(formState.validate(), isFalse);
    await tester.pump();

    expect(find.text('Enter a valid amount greater than 0.'), findsOneWidget);
  });

  testWidgets('filter section does not overflow on narrow screens', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: FilterSection(
              filters: ExpenseFilters(
                from: DateTime(2026, 5, 19),
                to: DateTime(2026, 5, 28),
                currencyCode: 'USD',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('From'), findsNothing);
    expect(find.textContaining('May'), findsWidgets);
  });
}
