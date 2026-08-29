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
      appBar: AppBar(title: const Text('Bank email import')),
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
              'Automatic expenses',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Spendly reads bank notification emails from Gmail and creates '
              'expenses automatically. Titles come from the merchant in the '
              'email, or "Bank · date" when unclear. Default currency: RD\$ (DOP).',
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Bank emails must arrive in the Gmail account you sign in with. '
              'To add a charge manually, use New on the home screen.',
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
              'Gmail',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (settings.lastSyncAt != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Last sync: ${settings.lastSyncAt}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: _busy ? null : _syncGmail,
              icon: const Icon(Icons.mail_rounded),
              label: Text(_busy ? 'Syncing…' : 'Sign in & sync Gmail'),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: _busy ? null : _signOutGmail,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign out of Gmail'),
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
              'Bank senders',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'One per line: email or domain (e.g. qik.do)',
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
                    child: const Text('Save senders'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton(
                  onPressed: _busy ? null : _resetDefaults,
                  child: const Text('Reset defaults'),
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
            _status =
                'Done: ${result.imported} imported, '
                '${result.skipped} skipped, ${result.failed} could not parse.',
      );
    } catch (e) {
      setState(() => _status = 'Gmail sync failed: $e');
    } finally {
      await _setBusy(false);
    }
  }

  Future<void> _signOutGmail() async {
    await ref.read(gmailServiceProvider).signOut();
    await ref.read(emailImportSettingsStoreProvider).setGmailConnected(false);
    ref.invalidate(emailImportSettingsProvider);
    setState(() => _status = 'Signed out of Gmail.');
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
    setState(() => _status = 'Bank senders saved.');
  }
}
