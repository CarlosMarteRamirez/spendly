import 'package:app_for_finance/app/app.dart';
import 'package:app_for_finance/features/expenses/application/expenses_controller.dart';
import 'package:app_for_finance/features/expenses/presentation/expense_form_page.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('app smoke test renders expenses screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ExpensesApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Mis gastos'), findsOneWidget);
    expect(find.text('Nuevo'), findsOneWidget);
    expect(find.text('Movimientos'), findsOneWidget);
    expect(find.text('Buscar por titulo'), findsOneWidget);
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

    await tester.tap(find.byKey(const Key('expense_form_save')));
    await tester.pump();

    expect(find.text('El titulo es obligatorio.'), findsOneWidget);
    expect(find.text('Ingresa un monto valido mayor a 0.'), findsOneWidget);
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
    expect(find.text('Desde'), findsNothing);
    expect(find.textContaining('may'), findsWidgets);
  });
}
