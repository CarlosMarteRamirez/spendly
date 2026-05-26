import 'package:app_for_finance/core/theme/app_colors.dart';
import 'package:app_for_finance/core/theme/app_spacing.dart';
import 'package:app_for_finance/core/utils/formatters.dart';
import 'package:app_for_finance/features/expenses/application/expenses_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterSection extends ConsumerWidget {
  const FilterSection({required this.filters, super.key});

  final ExpenseFilters filters;

  bool get _hasActiveFilters =>
      filters.searchQuery.isNotEmpty ||
      filters.currencyCode != null ||
      filters.from != null ||
      filters.to != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
              ),
              hintText: 'Search by title',
            ),
            onChanged:
                (value) => ref
                    .read(filtersProvider.notifier)
                    .update((s) => s.copyWith(searchQuery: value.trim())),
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CurrencyChip(
                  label: 'All',
                  selected: filters.currencyCode == null,
                  onTap:
                      () => ref
                          .read(filtersProvider.notifier)
                          .update((s) => s.copyWith(clearCurrency: true)),
                ),
                ...availableCurrencies.map(
                  (code) => Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: _CurrencyChip(
                      label: code,
                      selected: filters.currencyCode == code,
                      onTap:
                          () => ref
                              .read(filtersProvider.notifier)
                              .update((s) => s.copyWith(currencyCode: code)),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _DateChip(
                  icon: Icons.calendar_today_rounded,
                  label:
                      filters.from == null
                          ? 'From'
                          : formatShortDate(filters.from!),
                  selected: filters.from != null,
                  onTap: () => _pickDate(context, ref, isFrom: true),
                ),
                const SizedBox(width: AppSpacing.sm),
                _DateChip(
                  icon: Icons.event_rounded,
                  label:
                      filters.to == null
                          ? 'To'
                          : formatShortDate(filters.to!),
                  selected: filters.to != null,
                  onTap: () => _pickDate(context, ref, isFrom: false),
                ),
                if (_hasActiveFilters) ...[
                  const SizedBox(width: AppSpacing.sm),
                  ActionChip(
                    avatar: const Icon(Icons.filter_alt_off, size: 18),
                    label: const Text('Clear'),
                    onPressed:
                        () =>
                            ref.read(filtersProvider.notifier).state =
                                const ExpenseFilters(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    WidgetRef ref, {
    required bool isFrom,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: (isFrom ? filters.from : filters.to) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    ref
        .read(filtersProvider.notifier)
        .update((s) => isFrom ? s.copyWith(from: date) : s.copyWith(to: date));
  }
}

class _CurrencyChip extends StatelessWidget {
  const _CurrencyChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: selected ? AppColors.primaryDark : AppColors.textPrimary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: Icon(
        icon,
        size: 16,
        color: selected ? AppColors.primaryDark : AppColors.textSecondary,
      ),
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: selected ? AppColors.primaryDark : AppColors.textPrimary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }
}
