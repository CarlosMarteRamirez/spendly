import 'package:app_for_finance/features/email_import/application/email_import_service.dart';
import 'package:app_for_finance/features/email_import/data/email_import_settings_store.dart';
import 'package:app_for_finance/features/email_import/data/gmail_service.dart';
import 'package:app_for_finance/features/expenses/application/expenses_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailImportSettingsStoreProvider = Provider<EmailImportSettingsStore>((
  ref,
) {
  return EmailImportSettingsStore(ref.watch(appDatabaseProvider));
});

final gmailServiceProvider = Provider<GmailService>((ref) => GmailService());

final emailImportServiceProvider = Provider<EmailImportService>((ref) {
  return EmailImportService(
    expenses: ref.watch(expenseRepositoryProvider),
    settingsStore: ref.watch(emailImportSettingsStoreProvider),
    exchangeRates: ref.watch(usdExchangeRateServiceProvider),
    gmail: ref.watch(gmailServiceProvider),
  );
});

final emailImportSettingsProvider = FutureProvider<EmailImportSettings>((
  ref,
) async {
  return ref.watch(emailImportSettingsStoreProvider).load();
});
