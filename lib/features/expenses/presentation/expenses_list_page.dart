import 'package:app_for_finance/core/theme/app_colors.dart';
import 'package:app_for_finance/core/theme/app_spacing.dart';
import 'package:app_for_finance/features/expenses/application/expenses_controller.dart';
import 'package:app_for_finance/features/expenses/domain/expense.dart';
import 'package:app_for_finance/features/expenses/presentation/expense_form_page.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/empty_expenses.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/expense_tile.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/filter_section.dart';
import 'package:app_for_finance/features/email_import/presentation/email_import_page.dart';
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
      appBar: AppBar(
        title: const Text('My expenses'),
        actions: [
          IconButton(
            tooltip: 'Bank email import',
            icon: const Icon(Icons.mark_email_read_outlined),
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EmailImportPage()),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New'),
      ),
      body: SafeArea(
        child: filtered.when(
          data: (expenses) {
            if (expenses.isEmpty) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  SummaryHero(summary: summary),
                  FilterSection(filters: filters),
                  const EmptyExpenses(),
                  const SizedBox(height: 88),
                ],
              );
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SummaryHero(summary: summary)),
                SliverToBoxAdapter(child: FilterSection(filters: filters)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    child: Text(
                      'Transactions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    88,
                  ),
                  sliver: SliverList.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Dismissible(
                        key: ValueKey(expense.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: AppSpacing.lg),
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
                        confirmDismiss: (_) => _confirmDelete(context),
                        onDismissed: (_) async {
                          await _deleteExpense(context, ref, expense);
                        },
                        child: ExpenseTile(
                          expense: expense,
                          onEdit: () => _openForm(context, expense: expense),
                          onDelete: () async {
                            if (await _confirmDelete(context) ?? false) {
                              if (!context.mounted) return;
                              await _deleteExpense(context, ref, expense);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
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
            title: const Text('Delete expense'),
            content: const Text('This action cannot be undone.'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(60, 35),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(60, 35),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteExpense(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    await ref.read(expenseRepositoryProvider).delete(expense.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('"${expense.title}" deleted'),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }
}
