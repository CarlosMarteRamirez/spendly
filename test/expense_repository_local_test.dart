import 'package:app_for_finance/features/expenses/data/expense_repository_local.dart';
import 'package:app_for_finance/features/expenses/data/local/app_database.dart';
import 'package:app_for_finance/features/expenses/domain/expense_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ExpenseRepositoryLocal repository;

  setUp(() {
    db = AppDatabase(executor: NativeDatabase.memory());
    repository = ExpenseRepositoryLocal(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('insert, update, delete and query expenses', () async {
    final baseDate = DateTime(2026, 5, 26, 10, 30);
    final id = await repository.create(
      ExpenseDraft(
        title: 'Internet Claro',
        amount: 42.5,
        currencyCode: 'USD',
        spentAt: baseDate,
      ),
    );

    var rows = await repository.watchAll().first;
    expect(rows.length, 1);
    expect(rows.first.id, id);
    expect(rows.first.title, 'Internet Claro');

    await repository.update(
      id,
      ExpenseDraft(
        title: 'Internet Casa',
        amount: 50,
        currencyCode: 'USD',
        spentAt: baseDate.add(const Duration(hours: 1)),
      ),
    );
    rows = await repository.watchAll().first;
    expect(rows.first.title, 'Internet Casa');
    expect(rows.first.amount, 50);

    await repository.delete(id);
    rows = await repository.watchAll().first;
    expect(rows, isEmpty);
  });

  test('email import deduplicates by message id', () async {
    const messageId = 'gmail_msg_123';
    final draft = ExpenseDraft(
      title: 'Bank · May 26',
      amount: 99.99,
      currencyCode: 'DOP',
      spentAt: DateTime(2026, 5, 26),
      source: 'email',
      externalId: messageId,
    );

    final first = await repository.createFromEmailIfNew(draft, messageId);
    final second = await repository.createFromEmailIfNew(draft, messageId);

    expect(first, isNotNull);
    expect(second, isNull);
    expect(await repository.isEmailImported(messageId), isTrue);

    final rows = await repository.watchAll().first;
    expect(rows.length, 1);
    expect(rows.first.currencyCode, 'DOP');
    expect(rows.first.isFromEmail, isTrue);
  });
}
