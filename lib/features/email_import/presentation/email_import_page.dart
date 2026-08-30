import 'package:app_for_finance/core/l10n/app_localizations.dart';
import 'package:app_for_finance/core/theme/app_colors.dart';
import 'package:app_for_finance/core/theme/app_spacing.dart';
import 'package:app_for_finance/features/email_import/application/email_import_controller.dart';
import 'package:app_for_finance/features/email_import/data/email_import_settings_store.dart';
import 'package:app_for_finance/features/expenses/data/local/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailImportPage extends ConsumerStatefulWidget {
  const EmailImportPage({super.key});

  @override
  ConsumerState<EmailImportPage> createState() => _EmailImportPageState();
}

class _EmailImportPageState extends ConsumerState<EmailImportPage> {
  final _sendersController = TextEditingController();
  bool _busy = false;
  String? _status;

  @override
  void dispose() {
    _sendersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(emailImportSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.bankEmailImportPageTitle)),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) {
          if (_sendersController.text.isEmpty) {
            _sendersController.text = settings.bankSenderFilters.join('\n');
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              _infoCard(context),
              const SizedBox(height: AppSpacing.md),
              _gmailCard(context, settings),
              const SizedBox(height: AppSpacing.md),
              _sendersCard(context),
              if (_status != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  _status!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.automaticExpenses,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.automaticExpensesDesc,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.bankEmailsInfoNote,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gmailCard(BuildContext context, EmailImportSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.gmail,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (settings.lastSyncAt != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.lastSync('${settings.lastSyncAt}'),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: _busy ? null : _syncGmail,
              icon: const Icon(Icons.mail_rounded),
              label: Text(_busy ? context.l10n.syncing : context.l10n.signInAndSyncGmail),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: _busy ? null : _signOutGmail,
              icon: const Icon(Icons.logout_rounded),
              label: Text(context.l10n.signOutGmail),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sendersCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.bankSenders,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.sendersHintLine,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _sendersController,
              maxLines: 5,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'notificaciones@qik.do\nno.reply.alerts@chase.com',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy ? null : _saveSenders,
                    child: Text(context.l10n.saveSenders),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton(
                  onPressed: _busy ? null : _resetDefaults,
                  child: Text(context.l10n.resetDefaults),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resetDefaults() {
    setState(() {
      _sendersController.text = AppDatabase.defaultBankSenderFilters.join('\n');
    });
  }

  Future<void> _setBusy(bool value) async {
    if (mounted) setState(() => _busy = value);
  }

  Future<void> _syncGmail() async {
    await _setBusy(true);
    setState(() => _status = null);
    try {
      final gmail = ref.read(gmailServiceProvider);
      await gmail.ensureSignedIn();
      await ref.read(emailImportSettingsStoreProvider).setGmailConnected(true);
      final result =
          await ref.read(emailImportServiceProvider).importFromGmail();
      ref.invalidate(emailImportSettingsProvider);
      setState(
        () =>
            _status = context.l10n.syncResult(
              imported: result.imported,
              skipped: result.skipped,
              failed: result.failed,
            ),
      );
    } catch (e) {
      setState(() => _status = context.l10n.syncFailed('$e'));
    } finally {
      await _setBusy(false);
    }
  }

  Future<void> _signOutGmail() async {
    await ref.read(gmailServiceProvider).signOut();
    await ref.read(emailImportSettingsStoreProvider).setGmailConnected(false);
    ref.invalidate(emailImportSettingsProvider);
    setState(() => _status = context.l10n.signOutGmail);
  }

  Future<void> _saveSenders() async {
    final lines =
        _sendersController.text
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty)
            .toList();
    await ref.read(emailImportSettingsStoreProvider).saveSenders(lines);
    ref.invalidate(emailImportSettingsProvider);
    if (mounted) {
      setState(() => _status = context.l10n.sendersSaved);
    }
  }
}
