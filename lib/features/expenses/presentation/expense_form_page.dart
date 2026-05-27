import 'package:app_for_finance/core/utils/currency_labels.dart';
import 'package:app_for_finance/core/utils/expense_display.dart';
import 'package:app_for_finance/core/theme/app_colors.dart';
import 'package:app_for_finance/core/theme/app_spacing.dart';
import 'package:app_for_finance/core/utils/formatters.dart';
import 'package:app_for_finance/features/expenses/application/expenses_controller.dart';
import 'package:app_for_finance/features/expenses/domain/expense.dart';
import 'package:app_for_finance/features/expenses/domain/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseFormPage extends ConsumerStatefulWidget {
  const ExpenseFormPage({this.expense, super.key});

  final Expense? expense;

  @override
  ConsumerState<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends ConsumerState<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _usdRateController;
  late final TextEditingController _notesController;
  late DateTime _spentAt;
  late String _currencyCode;
  bool _loadingRate = false;

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _titleController = TextEditingController(text: expense?.title ?? '');
    _amountController = TextEditingController(
      text: expense != null ? expense.amount.toStringAsFixed(2) : '',
    );
    _usdRateController = TextEditingController(
      text:
          expense == null
              ? ''
              : expense.currencyCode == 'USD'
              ? '1.0000'
              : (expense.usdConversionRate?.toStringAsFixed(4) ?? ''),
    );
    _notesController = TextEditingController(text: expense?.notes ?? '');
    _spentAt = expense?.spentAt ?? DateTime.now();
    _currencyCode = expense?.currencyCode ?? availableCurrencies.first;
    if (_currencyCode == 'USD' && _usdRateController.text.isEmpty) {
      _usdRateController.text = '1.0000';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _usdRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit expense' : 'New expense'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Title (optional)',
                          prefixIcon: Icon(Icons.label_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.attach_money_rounded),
                        ),
                        validator: (value) {
                          final parsed = double.tryParse(value?.trim() ?? '');
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid amount greater than 0.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currency',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children:
                            availableCurrencies.map((code) {
                              final selected = _currencyCode == code;
                              return FilterChip(
                                label: Text(currencyChipLabel(code)),
                                selected: selected,
                                showCheckmark: false,
                                onSelected: (_) {
                                  setState(() {
                                    _currencyCode = code;
                                    if (_currencyCode == 'USD') {
                                      _usdRateController.text = '1.0000';
                                    } else if (_isEditing &&
                                        widget.expense?.currencyCode != code) {
                                      _usdRateController.clear();
                                    }
                                  });
                                },
                                selectedColor: AppColors.primary.withValues(
                                  alpha: 0.15,
                                ),
                                labelStyle: TextStyle(
                                  fontWeight:
                                      selected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                  color:
                                      selected
                                          ? AppColors.primaryDark
                                          : AppColors.textPrimary,
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _usdRateController,
                        readOnly: _currencyCode == 'USD',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,6}'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText:
                              _currencyCode == 'USD'
                                  ? 'USD conversion rate (fixed)'
                                  : 'USD conversion rate',
                          hintText:
                              _currencyCode == 'USD'
                                  ? '1.0000'
                                  : '1 USD = ? $_currencyCode',
                          prefixIcon: const Icon(
                            Icons.currency_exchange_rounded,
                          ),
                        ),
                        validator: (value) {
                          if (_currencyCode == 'USD') return null;
                          final parsed = double.tryParse(value?.trim() ?? '');
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid USD conversion rate.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed:
                              (_currencyCode == 'USD' || _loadingRate)
                                  ? null
                                  : _loadSuggestedRate,
                          icon:
                              _loadingRate
                                  ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(Icons.cloud_download_outlined),
                          label: const Text('Fetch historical USD rate'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  title: const Text('Date and time'),
                  subtitle: Text(formatExpenseDate(_spentAt)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: _pickDateTime,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('expense_form_save'),
                  onPressed: _submit,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(_isEditing ? 'Save changes' : 'Save expense'),
                ),
              ),
              if (_isEditing) ...[
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _deleteExpense,
                    icon: const Icon(Icons.delete_rounded),
                    label: const Text('Delete expense'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _spentAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_spentAt),
    );
    if (!mounted || pickedTime == null) return;
    setState(() {
      _spentAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final usdRate =
        _currencyCode == 'USD'
            ? 1.0
            : double.tryParse(_usdRateController.text.trim());
    final repository = ref.read(expenseRepositoryProvider);
    final title = _titleController.text.trim();
    final draft = ExpenseDraft(
      title: title.isEmpty ? kUntitledExpenseLabel : title,
      amount: double.parse(_amountController.text.trim()),
      currencyCode: _currencyCode,
      usdConversionRate: usdRate,
      spentAt: _spentAt,
      notes:
          _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
    );
    if (_isEditing) {
      await repository.update(widget.expense!.id, draft);
    } else {
      await repository.create(draft);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _loadSuggestedRate() async {
    setState(() => _loadingRate = true);
    final rate = await ref
        .read(usdExchangeRateServiceProvider)
        .getUsdToCurrencyRate(currencyCode: _currencyCode, date: _spentAt);
    if (!mounted) return;
    setState(() => _loadingRate = false);
    if (rate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not fetch exchange rate right now.'),
        ),
      );
      return;
    }
    setState(() => _usdRateController.text = rate.toStringAsFixed(4));
  }

  Future<void> _deleteExpense() async {
    final expense = widget.expense;
    if (expense == null) return;

    final shouldDelete = await showDialog<bool>(
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

    if (shouldDelete != true) return;

    await ref.read(expenseRepositoryProvider).delete(expense.id);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
