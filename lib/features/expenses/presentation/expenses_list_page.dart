import 'package:app_for_finance/core/l10n/app_localizations.dart';
import 'package:app_for_finance/core/theme/app_colors.dart';
import 'package:app_for_finance/core/theme/app_spacing.dart';
import 'package:app_for_finance/features/expenses/application/expenses_controller.dart';
import 'package:app_for_finance/features/expenses/domain/expense.dart';
import 'package:app_for_finance/features/expenses/presentation/expense_form_page.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/empty_expenses.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/expense_tile.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/filter_section.dart';
import 'package:app_for_finance/features/email_import/presentation/email_import_page.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/scroll_bottom_fade.dart';
import 'package:app_for_finance/features/expenses/presentation/widgets/summary_hero.dart';
import 'package:app_for_finance/features/expenses/presentation/total_breakdown_page.dart';
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
        title: Text(context.l10n.myExpenses),
        actions: [
          IconButton(
            tooltip: context.l10n.bankEmailImport,
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
        label: Text(context.l10n.newExpense),
      ),
      body: ScrollWithBottomFade(
        child: SafeArea(
          bottom: false,
          child: filtered.when(
              data: (expenses) {
                if (expenses.isEmpty) {
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SummaryHero(
                        summary: summary,
                        onTotalTap: () => _navigateToTotalBreakdown(context),
                      ),
                      FilterSection(filters: filters),
                      const EmptyExpenses(),
                      const SizedBox(height: kScrollBottomInsetWithFab),
                    ],
                  );
                }
                return CustomScrollView(
                  slivers: [
                SliverToBoxAdapter(
                  child: SummaryHero(
                    summary: summary,
                    onTotalTap: () => _navigateToTotalBreakdown(context),
                  ),
                ),
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
                      context.l10n.transactions,
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
                    kScrollBottomInsetWithFab,
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
      ),
    );
  }

  Future<void> _openForm(BuildContext context, {Expense? expense}) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExpenseFormPage(expense: expense)),
    );
  }

  void _navigateToTotalBreakdown(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TotalBreakdownPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(context.l10n.deleteExpense),
            content: Text(context.l10n.deleteConfirmationContent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(60, 35),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(60, 35),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                child: Text(context.l10n.delete),
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
            content: Text(context.l10n.expenseDeleted(expense.title)),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }
}
