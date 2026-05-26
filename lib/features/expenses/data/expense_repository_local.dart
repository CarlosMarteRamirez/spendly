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
            source: Value(draft.source),
            externalId: Value(draft.externalId),
          ),
        );
  }

  @override
  Future<int?> createFromEmailIfNew(ExpenseDraft draft, String messageId) async {
    if (await _db.isEmailImported(messageId)) {
      return null;
    }
    final expenseId = await create(
      ExpenseDraft(
        title: draft.title,
        amount: draft.amount,
        currencyCode: draft.currencyCode,
        spentAt: draft.spentAt,
        notes: draft.notes,
        source: 'email',
        externalId: messageId,
      ),
    );
    await _db.markEmailImported(messageId: messageId, expenseId: expenseId);
    return expenseId;
  }

  @override
  Future<bool> isEmailImported(String messageId) {
    return _db.isEmailImported(messageId);
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
        source: Value(draft.source),
        externalId: Value(draft.externalId),
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
              source: row.source,
              externalId: row.externalId,
            ),
          )
          .toList(growable: false),
    );
  }
}
