import 'package:app_for_finance/features/expenses/data/local/app_database.dart';
import 'package:app_for_finance/features/expenses/domain/expense.dart';
import 'package:app_for_finance/features/expenses/domain/expense_repository.dart';
import 'package:drift/drift.dart';

class ExpenseRepositoryLocal implements ExpenseRepository {
  ExpenseRepositoryLocal(this._db);

  final AppDatabase _db;

  @override
  Future<int> create(ExpenseDraft draft) {
    final now = DateTime.now();
    return _db
        .into(_db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(
            title: draft.title,
            amount: draft.amount,
            currencyCode: draft.currencyCode,
            notes: Value(draft.notes),
            spentAt: draft.spentAt,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  @override
  Future<void> delete(int id) {
    return (_db.delete(_db.expensesTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> update(int id, ExpenseDraft draft) {
    return (_db.update(_db.expensesTable)..where((t) => t.id.equals(id))).write(
      ExpensesTableCompanion(
        title: Value(draft.title),
        amount: Value(draft.amount),
        currencyCode: Value(draft.currencyCode),
        notes: Value(draft.notes),
        spentAt: Value(draft.spentAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Stream<List<Expense>> watchAll() {
    return _db.watchExpenses().map(
      (rows) => rows
          .map(
            (row) => Expense(
              id: row.id,
              title: row.title,
              amount: row.amount,
              currencyCode: row.currencyCode,
              notes: row.notes,
              spentAt: row.spentAt,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
            ),
          )
          .toList(growable: false),
    );
  }
}
