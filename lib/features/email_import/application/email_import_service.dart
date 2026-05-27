import 'package:app_for_finance/core/services/usd_exchange_rate_service.dart';
import 'package:app_for_finance/features/email_import/data/email_import_settings_store.dart';
import 'package:app_for_finance/features/email_import/data/gmail_service.dart';
import 'package:app_for_finance/features/email_import/domain/bank_email_parser.dart';
import 'package:app_for_finance/features/email_import/domain/parsed_bank_transaction.dart';
import 'package:app_for_finance/features/expenses/domain/expense_repository.dart';

class EmailImportResult {
  const EmailImportResult({
    required this.imported,
    required this.skipped,
    required this.failed,
  });

  final int imported;
  final int skipped;
  final int failed;

  int get total => imported + skipped + failed;
}

class EmailImportService {
  EmailImportService({
    required ExpenseRepository expenses,
    required EmailImportSettingsStore settingsStore,
    required UsdExchangeRateService exchangeRates,
    GmailService? gmail,
  }) : _expenses = expenses,
       _settingsStore = settingsStore,
       _exchangeRates = exchangeRates,
       _gmail = gmail ?? GmailService();

  final ExpenseRepository _expenses;
  final EmailImportSettingsStore _settingsStore;
  final UsdExchangeRateService _exchangeRates;
  final GmailService _gmail;

  Future<EmailImportResult> importFromGmail() async {
    final settings = await _settingsStore.load();
    final messages = await _gmail.fetchBankMessages(
      senderFilters: settings.bankSenderFilters,
    );
    return _importMessages(
      messages
          .map(
            (m) => _ParsedMessage(
              messageId: m.id,
              subject: m.subject,
              body: m.body,
            ),
          )
          .toList(),
      defaultCurrency: settings.defaultCurrency,
    );
  }

  Future<EmailImportResult> _importMessages(
    List<_ParsedMessage> messages, {
    required String defaultCurrency,
  }) async {
    final parser = BankEmailParser(defaultCurrency: defaultCurrency);
    final parsedList = <ParsedBankTransaction>[];
    var failed = 0;

    for (final message in messages) {
      final parsed = parser.parse(
        body: message.body,
        subject: message.subject,
        messageId: message.messageId,
      );
      if (parsed != null) {
        parsedList.add(parsed);
      } else {
        failed++;
      }
    }

    final persistResult = await _persistParsed(parsedList);
    await _settingsStore.setLastSyncAt(DateTime.now());
    await _settingsStore.setGmailConnected(await _gmail.isSignedIn);
    return EmailImportResult(
      imported: persistResult.imported,
      skipped: persistResult.skipped,
      failed: failed + persistResult.failed,
    );
  }

  Future<EmailImportResult> _persistParsed(
    List<ParsedBankTransaction> parsedList,
  ) async {
    var imported = 0;
    var skipped = 0;
    var failed = 0;

    for (final parsed in parsedList) {
      final messageId = parsed.messageId;
      if (messageId == null) {
        failed++;
        continue;
      }

      if (await _expenses.isEmailImported(messageId)) {
        skipped++;
        continue;
      }

      final id = await _expenses.createFromEmailIfNew(
        ExpenseDraft(
          title: parsed.title,
          amount: parsed.amount,
          currencyCode: parsed.currencyCode,
          usdConversionRate: await _exchangeRates.getUsdToCurrencyRate(
            currencyCode: parsed.currencyCode,
            date: parsed.spentAt,
          ),
          spentAt: parsed.spentAt,
          notes: 'Imported from bank email',
          source: 'email',
          externalId: messageId,
        ),
        messageId,
      );

      if (id != null) {
        imported++;
      } else {
        skipped++;
      }
    }

    return EmailImportResult(
      imported: imported,
      skipped: skipped,
      failed: failed,
    );
  }
}

class _ParsedMessage {
  const _ParsedMessage({
    required this.messageId,
    required this.subject,
    required this.body,
  });

  final String messageId;
  final String subject;
  final String body;
}
