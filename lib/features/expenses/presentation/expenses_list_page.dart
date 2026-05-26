import 'package:app_for_finance/core/theme/app_colors.dart';
import 'package:app_for_finance/core/theme/app_spacing.dart';
import 'package:app_for_finance/features/expenses/application/expenses_controller.dart';
import 'package:app_for_finance/features/expenses/domain/expense.dart';
import 'package:app_for_finance/features/expenses/presentation/expense_form_page.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/empty_expenses.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/expense_tile.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/filter_section.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/summary_hero.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesListPage extends ConsumerWidget {
  const ExpensesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredExpensesProvider);
    final summary = ref.watch(summaryProvider);
    final filters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis gastos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SummaryHero(summary: summary),
            FilterSection(filters: filters),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                'Movimientos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: filtered.when(
                data:
                    (expenses) =>
                        expenses.isEmpty
                            ? const EmptyExpenses()
                            : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.lg,
                                0,
                                AppSpacing.lg,
                                88,
                              ),
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                final expense = expenses[index];
                                return Dismissible(
                                  key: ValueKey(expense.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(
                                      right: AppSpacing.lg,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade400,
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusMd,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.delete_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  confirmDismiss:
                                      (_) => _confirmDelete(context),
                                  onDismissed: (_) async {
                                    await ref
                                        .read(expenseRepositoryProvider)
                                        .delete(expense.id);
                                  },
                                  child: ExpenseTile(
                                    expense: expense,
                                    onEdit:
                                        () => _openForm(
                                          context,
                                          expense: expense,
                                        ),
                                    onDelete: () async {
                                      if (await _confirmDelete(context) ??
                                          false) {
                                        await ref
                                            .read(expenseRepositoryProvider)
                                            .delete(expense.id);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {Expense? expense}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExpenseFormPage(expense: expense)),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Eliminar gasto'),
            content: const Text('Esta accion no se puede deshacer.'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}
