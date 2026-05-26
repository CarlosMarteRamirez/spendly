import 'package:app_for_finance/core/theme/app_theme.dart';
import 'package:app_for_finance/features/expenses/presentation/expenses_list_page.dart';
import 'package:flutter/material.dart';

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gastos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ExpensesListPage(),
    );
  }
}
