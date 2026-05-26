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
}

@DriftDatabase(tables: [ExpensesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<ExpensesTableData>> watchExpenses() {
    final query = select(expensesTable)..orderBy([
      (t) => OrderingTerm.desc(t.spentAt),
      (t) => OrderingTerm.desc(t.id),
    ]);
    return query.watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'expenses.sqlite'));
    return NativeDatabase(file);
  });
}
