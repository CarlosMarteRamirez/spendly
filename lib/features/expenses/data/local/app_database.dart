import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class ExpensesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get currencyCode => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get spentAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get source =>
      text().withDefault(const Constant('manual'))();
  TextColumn get externalId => text().nullable()();
  RealColumn get usdConversionRate => real().nullable()();
}

/// Single-row table for bank email import settings (id = 1).
class EmailImportSettingsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get bankSendersJson => text()();
  TextColumn get defaultCurrency =>
      text().withDefault(const Constant('DOP'))();
  BoolColumn get gmailConnected =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Tracks Gmail message IDs already imported (deduplication).
class ImportedEmailsTable extends Table {
  TextColumn get messageId => text()();
  IntColumn get expenseId => integer()();
  DateTimeColumn get importedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {messageId};
}

@DriftDatabase(tables: [
  ExpensesTable,
  EmailImportSettingsTable,
  ImportedEmailsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  static const emailImportSettingsRowId = 1;

  static const defaultBankSenderFilters = [
    // Dominican Republic banks
    'qik.do',
    'notificaciones@qik.do',
    'bhd.com.do',
    'popular.com.do',
    'banreservas.com',
    'scotiabank.com',
    'apap.com.do',
    'promerica.com.do',
    'bsc.com.do',
    // US banks
    'ealerts.bankofamerica.com',
    'onlinebanking@ealerts.bankofamerica.com',
    'chase.com',
    'alertsp.chase.com',
    'no.reply.alerts@chase.com',
    'no.reply@chase.com',
    'alerts@chase.com',
    'account.alerts@chase.com',
    'info3.citibank.com',
    'citicards@info3.citibank.com',
    'citi.com',
    'alerts@usbank.com',
    'notifications.usbank.com',
    'notification.capitalone.com',
    'capitalone.com',
  ];

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(expensesTable, expensesTable.source);
        await m.addColumn(expensesTable, expensesTable.externalId);
        await m.createTable(importedEmailsTable);
      }
      if (from < 3) {
        await m.createTable(emailImportSettingsTable);
        await into(emailImportSettingsTable).insert(
          EmailImportSettingsTableCompanion.insert(
            id: const Value(emailImportSettingsRowId),
            bankSendersJson: jsonEncode(defaultBankSenderFilters),
          ),
        );
      }
      if (from < 4) {
        await m.addColumn(expensesTable, expensesTable.usdConversionRate);
        await customStatement(
          "UPDATE expenses_table SET usd_conversion_rate = 1.0 WHERE currency_code = 'USD'",
        );
      }
      if (from < 5) {
        final existingSettings = await (select(emailImportSettingsTable)
              ..where((t) => t.id.equals(emailImportSettingsRowId)))
            .getSingleOrNull();
        if (existingSettings != null) {
          final decoded = (jsonDecode(existingSettings.bankSendersJson) as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
          for (final defaultSender in defaultBankSenderFilters) {
            if (!decoded.contains(defaultSender)) {
              decoded.add(defaultSender);
            }
          }
          await (update(emailImportSettingsTable)
                ..where((t) => t.id.equals(emailImportSettingsRowId)))
              .write(
            EmailImportSettingsTableCompanion(
              bankSendersJson: Value(jsonEncode(decoded)),
            ),
          );
        }
      }
    },
    beforeOpen: (details) async {
      if (details.wasCreated) {
        await into(emailImportSettingsTable).insert(
          EmailImportSettingsTableCompanion.insert(
            id: const Value(emailImportSettingsRowId),
            bankSendersJson: jsonEncode(defaultBankSenderFilters),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    },
  );

  Stream<List<ExpensesTableData>> watchExpenses() {
    final query = select(expensesTable)..orderBy([
      (t) => OrderingTerm.desc(t.spentAt),
      (t) => OrderingTerm.desc(t.id),
    ]);
    return query.watch();
  }

  Future<bool> isEmailImported(String messageId) async {
    final row =
        await (select(importedEmailsTable)
          ..where((t) => t.messageId.equals(messageId))).getSingleOrNull();
    return row != null;
  }

  Future<void> markEmailImported({
    required String messageId,
    required int expenseId,
  }) {
    return into(importedEmailsTable).insert(
      ImportedEmailsTableCompanion.insert(
        messageId: messageId,
        expenseId: expenseId,
        importedAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'expenses.sqlite'));
    return NativeDatabase(file);
  });
}
