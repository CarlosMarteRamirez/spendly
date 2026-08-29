import 'dart:convert';

import 'package:app_for_finance/features/expenses/data/local/app_database.dart';
import 'package:drift/drift.dart';

class EmailImportSettings {
  const EmailImportSettings({
    required this.bankSenderFilters,
    required this.defaultCurrency,
    required this.gmailConnected,
    this.lastSyncAt,
  });

  final List<String> bankSenderFilters;
  final String defaultCurrency;
  final bool gmailConnected;
  final DateTime? lastSyncAt;
}

/// Persists email-import settings in Drift (same DB as expenses).
class EmailImportSettingsStore {
  EmailImportSettingsStore(this._db);

  final AppDatabase _db;

  Future<EmailImportSettings> load() async {
    await _ensureRow();
    final row =
        await (_db.select(_db.emailImportSettingsTable)..where(
          (t) => t.id.equals(AppDatabase.emailImportSettingsRowId),
        )).getSingle();

    return EmailImportSettings(
      bankSenderFilters: _decodeSenders(row.bankSendersJson),
      defaultCurrency: row.defaultCurrency,
      gmailConnected: row.gmailConnected,
      lastSyncAt: row.lastSyncAt,
    );
  }

  Future<void> saveSenders(List<String> senders) async {
    await _ensureRow();
    await (_db.update(_db.emailImportSettingsTable)
          ..where((t) => t.id.equals(AppDatabase.emailImportSettingsRowId)))
        .write(
      EmailImportSettingsTableCompanion(
        bankSendersJson: Value(jsonEncode(senders)),
      ),
    );
  }

  Future<void> saveDefaultCurrency(String code) async {
    await _ensureRow();
    await (_db.update(_db.emailImportSettingsTable)
          ..where((t) => t.id.equals(AppDatabase.emailImportSettingsRowId)))
        .write(EmailImportSettingsTableCompanion(defaultCurrency: Value(code)));
  }

  Future<void> setGmailConnected(bool value) async {
    await _ensureRow();
    await (_db.update(_db.emailImportSettingsTable)
          ..where((t) => t.id.equals(AppDatabase.emailImportSettingsRowId)))
        .write(EmailImportSettingsTableCompanion(gmailConnected: Value(value)));
  }

  Future<void> setLastSyncAt(DateTime time) async {
    await _ensureRow();
    await (_db.update(_db.emailImportSettingsTable)
          ..where((t) => t.id.equals(AppDatabase.emailImportSettingsRowId)))
        .write(EmailImportSettingsTableCompanion(lastSyncAt: Value(time)));
  }

  Future<void> _ensureRow() async {
    final existing =
        await (_db.select(_db.emailImportSettingsTable)..where(
          (t) => t.id.equals(AppDatabase.emailImportSettingsRowId),
        )).getSingleOrNull();
    if (existing != null) return;

    await _db.into(_db.emailImportSettingsTable).insert(
      EmailImportSettingsTableCompanion.insert(
        id: const Value(AppDatabase.emailImportSettingsRowId),
        bankSendersJson: jsonEncode(AppDatabase.defaultBankSenderFilters),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  List<String> _decodeSenders(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        final current = decoded.map((e) => e.toString()).toList();
        for (final defaultSender in AppDatabase.defaultBankSenderFilters) {
          if (!current.contains(defaultSender)) {
            current.add(defaultSender);
          }
        }
        return current;
      }
    } catch (_) {}
    return List<String>.from(AppDatabase.defaultBankSenderFilters);
  }
}
