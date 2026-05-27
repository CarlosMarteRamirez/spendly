// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExpensesTableTable extends ExpensesTable
    with TableInfo<$ExpensesTableTable, ExpensesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spentAtMeta = const VerificationMeta(
    'spentAt',
  );
  @override
  late final GeneratedColumn<DateTime> spentAt = GeneratedColumn<DateTime>(
    'spent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usdConversionRateMeta = const VerificationMeta(
    'usdConversionRate',
  );
  @override
  late final GeneratedColumn<double> usdConversionRate =
      GeneratedColumn<double>(
        'usd_conversion_rate',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amount,
    currencyCode,
    notes,
    spentAt,
    createdAt,
    updatedAt,
    source,
    externalId,
    usdConversionRate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpensesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('spent_at')) {
      context.handle(
        _spentAtMeta,
        spentAt.isAcceptableOrUnknown(data['spent_at']!, _spentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_spentAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('usd_conversion_rate')) {
      context.handle(
        _usdConversionRateMeta,
        usdConversionRate.isAcceptableOrUnknown(
          data['usd_conversion_rate']!,
          _usdConversionRateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpensesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpensesTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      amount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}amount'],
          )!,
      currencyCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}currency_code'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      spentAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}spent_at'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      source:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source'],
          )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      usdConversionRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}usd_conversion_rate'],
      ),
    );
  }

  @override
  $ExpensesTableTable createAlias(String alias) {
    return $ExpensesTableTable(attachedDatabase, alias);
  }
}

class ExpensesTableData extends DataClass
    implements Insertable<ExpensesTableData> {
  final int id;
  final String title;
  final double amount;
  final String currencyCode;
  final String? notes;
  final DateTime spentAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String source;
  final String? externalId;
  final double? usdConversionRate;
  const ExpensesTableData({
    required this.id,
    required this.title,
    required this.amount,
    required this.currencyCode,
    this.notes,
    required this.spentAt,
    required this.createdAt,
    required this.updatedAt,
    required this.source,
    this.externalId,
    this.usdConversionRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['spent_at'] = Variable<DateTime>(spentAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || usdConversionRate != null) {
      map['usd_conversion_rate'] = Variable<double>(usdConversionRate);
    }
    return map;
  }

  ExpensesTableCompanion toCompanion(bool nullToAbsent) {
    return ExpensesTableCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      currencyCode: Value(currencyCode),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      spentAt: Value(spentAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      source: Value(source),
      externalId:
          externalId == null && nullToAbsent
              ? const Value.absent()
              : Value(externalId),
      usdConversionRate:
          usdConversionRate == null && nullToAbsent
              ? const Value.absent()
              : Value(usdConversionRate),
    );
  }

  factory ExpensesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpensesTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      notes: serializer.fromJson<String?>(json['notes']),
      spentAt: serializer.fromJson<DateTime>(json['spentAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      source: serializer.fromJson<String>(json['source']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      usdConversionRate: serializer.fromJson<double?>(
        json['usdConversionRate'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'notes': serializer.toJson<String?>(notes),
      'spentAt': serializer.toJson<DateTime>(spentAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'source': serializer.toJson<String>(source),
      'externalId': serializer.toJson<String?>(externalId),
      'usdConversionRate': serializer.toJson<double?>(usdConversionRate),
    };
  }

  ExpensesTableData copyWith({
    int? id,
    String? title,
    double? amount,
    String? currencyCode,
    Value<String?> notes = const Value.absent(),
    DateTime? spentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? source,
    Value<String?> externalId = const Value.absent(),
    Value<double?> usdConversionRate = const Value.absent(),
  }) => ExpensesTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    currencyCode: currencyCode ?? this.currencyCode,
    notes: notes.present ? notes.value : this.notes,
    spentAt: spentAt ?? this.spentAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    source: source ?? this.source,
    externalId: externalId.present ? externalId.value : this.externalId,
    usdConversionRate:
        usdConversionRate.present
            ? usdConversionRate.value
            : this.usdConversionRate,
  );
  ExpensesTableData copyWithCompanion(ExpensesTableCompanion data) {
    return ExpensesTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      currencyCode:
          data.currencyCode.present
              ? data.currencyCode.value
              : this.currencyCode,
      notes: data.notes.present ? data.notes.value : this.notes,
      spentAt: data.spentAt.present ? data.spentAt.value : this.spentAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      source: data.source.present ? data.source.value : this.source,
      externalId:
          data.externalId.present ? data.externalId.value : this.externalId,
      usdConversionRate:
          data.usdConversionRate.present
              ? data.usdConversionRate.value
              : this.usdConversionRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('notes: $notes, ')
          ..write('spentAt: $spentAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('usdConversionRate: $usdConversionRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amount,
    currencyCode,
    notes,
    spentAt,
    createdAt,
    updatedAt,
    source,
    externalId,
    usdConversionRate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpensesTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.currencyCode == this.currencyCode &&
          other.notes == this.notes &&
          other.spentAt == this.spentAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.source == this.source &&
          other.externalId == this.externalId &&
          other.usdConversionRate == this.usdConversionRate);
}

class ExpensesTableCompanion extends UpdateCompanion<ExpensesTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> currencyCode;
  final Value<String?> notes;
  final Value<DateTime> spentAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> source;
  final Value<String?> externalId;
  final Value<double?> usdConversionRate;
  const ExpensesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.notes = const Value.absent(),
    this.spentAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.usdConversionRate = const Value.absent(),
  });
  ExpensesTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required double amount,
    required String currencyCode,
    this.notes = const Value.absent(),
    required DateTime spentAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.usdConversionRate = const Value.absent(),
  }) : title = Value(title),
       amount = Value(amount),
       currencyCode = Value(currencyCode),
       spentAt = Value(spentAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ExpensesTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? currencyCode,
    Expression<String>? notes,
    Expression<DateTime>? spentAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? source,
    Expression<String>? externalId,
    Expression<double>? usdConversionRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (notes != null) 'notes': notes,
      if (spentAt != null) 'spent_at': spentAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (source != null) 'source': source,
      if (externalId != null) 'external_id': externalId,
      if (usdConversionRate != null) 'usd_conversion_rate': usdConversionRate,
    });
  }

  ExpensesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<double>? amount,
    Value<String>? currencyCode,
    Value<String?>? notes,
    Value<DateTime>? spentAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? source,
    Value<String?>? externalId,
    Value<double?>? usdConversionRate,
  }) {
    return ExpensesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      notes: notes ?? this.notes,
      spentAt: spentAt ?? this.spentAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      usdConversionRate: usdConversionRate ?? this.usdConversionRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (spentAt.present) {
      map['spent_at'] = Variable<DateTime>(spentAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (usdConversionRate.present) {
      map['usd_conversion_rate'] = Variable<double>(usdConversionRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('notes: $notes, ')
          ..write('spentAt: $spentAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('usdConversionRate: $usdConversionRate')
          ..write(')'))
        .toString();
  }
}

class $EmailImportSettingsTableTable extends EmailImportSettingsTable
    with
        TableInfo<
          $EmailImportSettingsTableTable,
          EmailImportSettingsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailImportSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bankSendersJsonMeta = const VerificationMeta(
    'bankSendersJson',
  );
  @override
  late final GeneratedColumn<String> bankSendersJson = GeneratedColumn<String>(
    'bank_senders_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultCurrencyMeta = const VerificationMeta(
    'defaultCurrency',
  );
  @override
  late final GeneratedColumn<String> defaultCurrency = GeneratedColumn<String>(
    'default_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('DOP'),
  );
  static const VerificationMeta _gmailConnectedMeta = const VerificationMeta(
    'gmailConnected',
  );
  @override
  late final GeneratedColumn<bool> gmailConnected = GeneratedColumn<bool>(
    'gmail_connected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("gmail_connected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bankSendersJson,
    defaultCurrency,
    gmailConnected,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_import_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmailImportSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bank_senders_json')) {
      context.handle(
        _bankSendersJsonMeta,
        bankSendersJson.isAcceptableOrUnknown(
          data['bank_senders_json']!,
          _bankSendersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bankSendersJsonMeta);
    }
    if (data.containsKey('default_currency')) {
      context.handle(
        _defaultCurrencyMeta,
        defaultCurrency.isAcceptableOrUnknown(
          data['default_currency']!,
          _defaultCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('gmail_connected')) {
      context.handle(
        _gmailConnectedMeta,
        gmailConnected.isAcceptableOrUnknown(
          data['gmail_connected']!,
          _gmailConnectedMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailImportSettingsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailImportSettingsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      bankSendersJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}bank_senders_json'],
          )!,
      defaultCurrency:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}default_currency'],
          )!,
      gmailConnected:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}gmail_connected'],
          )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $EmailImportSettingsTableTable createAlias(String alias) {
    return $EmailImportSettingsTableTable(attachedDatabase, alias);
  }
}

class EmailImportSettingsTableData extends DataClass
    implements Insertable<EmailImportSettingsTableData> {
  final int id;
  final String bankSendersJson;
  final String defaultCurrency;
  final bool gmailConnected;
  final DateTime? lastSyncAt;
  const EmailImportSettingsTableData({
    required this.id,
    required this.bankSendersJson,
    required this.defaultCurrency,
    required this.gmailConnected,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bank_senders_json'] = Variable<String>(bankSendersJson);
    map['default_currency'] = Variable<String>(defaultCurrency);
    map['gmail_connected'] = Variable<bool>(gmailConnected);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  EmailImportSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return EmailImportSettingsTableCompanion(
      id: Value(id),
      bankSendersJson: Value(bankSendersJson),
      defaultCurrency: Value(defaultCurrency),
      gmailConnected: Value(gmailConnected),
      lastSyncAt:
          lastSyncAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastSyncAt),
    );
  }

  factory EmailImportSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailImportSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      bankSendersJson: serializer.fromJson<String>(json['bankSendersJson']),
      defaultCurrency: serializer.fromJson<String>(json['defaultCurrency']),
      gmailConnected: serializer.fromJson<bool>(json['gmailConnected']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankSendersJson': serializer.toJson<String>(bankSendersJson),
      'defaultCurrency': serializer.toJson<String>(defaultCurrency),
      'gmailConnected': serializer.toJson<bool>(gmailConnected),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  EmailImportSettingsTableData copyWith({
    int? id,
    String? bankSendersJson,
    String? defaultCurrency,
    bool? gmailConnected,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => EmailImportSettingsTableData(
    id: id ?? this.id,
    bankSendersJson: bankSendersJson ?? this.bankSendersJson,
    defaultCurrency: defaultCurrency ?? this.defaultCurrency,
    gmailConnected: gmailConnected ?? this.gmailConnected,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  EmailImportSettingsTableData copyWithCompanion(
    EmailImportSettingsTableCompanion data,
  ) {
    return EmailImportSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      bankSendersJson:
          data.bankSendersJson.present
              ? data.bankSendersJson.value
              : this.bankSendersJson,
      defaultCurrency:
          data.defaultCurrency.present
              ? data.defaultCurrency.value
              : this.defaultCurrency,
      gmailConnected:
          data.gmailConnected.present
              ? data.gmailConnected.value
              : this.gmailConnected,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailImportSettingsTableData(')
          ..write('id: $id, ')
          ..write('bankSendersJson: $bankSendersJson, ')
          ..write('defaultCurrency: $defaultCurrency, ')
          ..write('gmailConnected: $gmailConnected, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bankSendersJson,
    defaultCurrency,
    gmailConnected,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailImportSettingsTableData &&
          other.id == this.id &&
          other.bankSendersJson == this.bankSendersJson &&
          other.defaultCurrency == this.defaultCurrency &&
          other.gmailConnected == this.gmailConnected &&
          other.lastSyncAt == this.lastSyncAt);
}

class EmailImportSettingsTableCompanion
    extends UpdateCompanion<EmailImportSettingsTableData> {
  final Value<int> id;
  final Value<String> bankSendersJson;
  final Value<String> defaultCurrency;
  final Value<bool> gmailConnected;
  final Value<DateTime?> lastSyncAt;
  const EmailImportSettingsTableCompanion({
    this.id = const Value.absent(),
    this.bankSendersJson = const Value.absent(),
    this.defaultCurrency = const Value.absent(),
    this.gmailConnected = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  EmailImportSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String bankSendersJson,
    this.defaultCurrency = const Value.absent(),
    this.gmailConnected = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  }) : bankSendersJson = Value(bankSendersJson);
  static Insertable<EmailImportSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? bankSendersJson,
    Expression<String>? defaultCurrency,
    Expression<bool>? gmailConnected,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankSendersJson != null) 'bank_senders_json': bankSendersJson,
      if (defaultCurrency != null) 'default_currency': defaultCurrency,
      if (gmailConnected != null) 'gmail_connected': gmailConnected,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  EmailImportSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? bankSendersJson,
    Value<String>? defaultCurrency,
    Value<bool>? gmailConnected,
    Value<DateTime?>? lastSyncAt,
  }) {
    return EmailImportSettingsTableCompanion(
      id: id ?? this.id,
      bankSendersJson: bankSendersJson ?? this.bankSendersJson,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      gmailConnected: gmailConnected ?? this.gmailConnected,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankSendersJson.present) {
      map['bank_senders_json'] = Variable<String>(bankSendersJson.value);
    }
    if (defaultCurrency.present) {
      map['default_currency'] = Variable<String>(defaultCurrency.value);
    }
    if (gmailConnected.present) {
      map['gmail_connected'] = Variable<bool>(gmailConnected.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailImportSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('bankSendersJson: $bankSendersJson, ')
          ..write('defaultCurrency: $defaultCurrency, ')
          ..write('gmailConnected: $gmailConnected, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $ImportedEmailsTableTable extends ImportedEmailsTable
    with TableInfo<$ImportedEmailsTableTable, ImportedEmailsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportedEmailsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<int> expenseId = GeneratedColumn<int>(
    'expense_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [messageId, expenseId, importedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'imported_emails_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportedEmailsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_expenseIdMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId};
  @override
  ImportedEmailsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportedEmailsTableData(
      messageId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}message_id'],
          )!,
      expenseId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}expense_id'],
          )!,
      importedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}imported_at'],
          )!,
    );
  }

  @override
  $ImportedEmailsTableTable createAlias(String alias) {
    return $ImportedEmailsTableTable(attachedDatabase, alias);
  }
}

class ImportedEmailsTableData extends DataClass
    implements Insertable<ImportedEmailsTableData> {
  final String messageId;
  final int expenseId;
  final DateTime importedAt;
  const ImportedEmailsTableData({
    required this.messageId,
    required this.expenseId,
    required this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<String>(messageId);
    map['expense_id'] = Variable<int>(expenseId);
    map['imported_at'] = Variable<DateTime>(importedAt);
    return map;
  }

  ImportedEmailsTableCompanion toCompanion(bool nullToAbsent) {
    return ImportedEmailsTableCompanion(
      messageId: Value(messageId),
      expenseId: Value(expenseId),
      importedAt: Value(importedAt),
    );
  }

  factory ImportedEmailsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportedEmailsTableData(
      messageId: serializer.fromJson<String>(json['messageId']),
      expenseId: serializer.fromJson<int>(json['expenseId']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'expenseId': serializer.toJson<int>(expenseId),
      'importedAt': serializer.toJson<DateTime>(importedAt),
    };
  }

  ImportedEmailsTableData copyWith({
    String? messageId,
    int? expenseId,
    DateTime? importedAt,
  }) => ImportedEmailsTableData(
    messageId: messageId ?? this.messageId,
    expenseId: expenseId ?? this.expenseId,
    importedAt: importedAt ?? this.importedAt,
  );
  ImportedEmailsTableData copyWithCompanion(ImportedEmailsTableCompanion data) {
    return ImportedEmailsTableData(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      importedAt:
          data.importedAt.present ? data.importedAt.value : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportedEmailsTableData(')
          ..write('messageId: $messageId, ')
          ..write('expenseId: $expenseId, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(messageId, expenseId, importedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportedEmailsTableData &&
          other.messageId == this.messageId &&
          other.expenseId == this.expenseId &&
          other.importedAt == this.importedAt);
}

class ImportedEmailsTableCompanion
    extends UpdateCompanion<ImportedEmailsTableData> {
  final Value<String> messageId;
  final Value<int> expenseId;
  final Value<DateTime> importedAt;
  final Value<int> rowid;
  const ImportedEmailsTableCompanion({
    this.messageId = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportedEmailsTableCompanion.insert({
    required String messageId,
    required int expenseId,
    required DateTime importedAt,
    this.rowid = const Value.absent(),
  }) : messageId = Value(messageId),
       expenseId = Value(expenseId),
       importedAt = Value(importedAt);
  static Insertable<ImportedEmailsTableData> custom({
    Expression<String>? messageId,
    Expression<int>? expenseId,
    Expression<DateTime>? importedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (expenseId != null) 'expense_id': expenseId,
      if (importedAt != null) 'imported_at': importedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportedEmailsTableCompanion copyWith({
    Value<String>? messageId,
    Value<int>? expenseId,
    Value<DateTime>? importedAt,
    Value<int>? rowid,
  }) {
    return ImportedEmailsTableCompanion(
      messageId: messageId ?? this.messageId,
      expenseId: expenseId ?? this.expenseId,
      importedAt: importedAt ?? this.importedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportedEmailsTableCompanion(')
          ..write('messageId: $messageId, ')
          ..write('expenseId: $expenseId, ')
          ..write('importedAt: $importedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExpensesTableTable expensesTable = $ExpensesTableTable(this);
  late final $EmailImportSettingsTableTable emailImportSettingsTable =
      $EmailImportSettingsTableTable(this);
  late final $ImportedEmailsTableTable importedEmailsTable =
      $ImportedEmailsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    expensesTable,
    emailImportSettingsTable,
    importedEmailsTable,
  ];
}

typedef $$ExpensesTableTableCreateCompanionBuilder =
    ExpensesTableCompanion Function({
      Value<int> id,
      required String title,
      required double amount,
      required String currencyCode,
      Value<String?> notes,
      required DateTime spentAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String> source,
      Value<String?> externalId,
      Value<double?> usdConversionRate,
    });
typedef $$ExpensesTableTableUpdateCompanionBuilder =
    ExpensesTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<double> amount,
      Value<String> currencyCode,
      Value<String?> notes,
      Value<DateTime> spentAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> source,
      Value<String?> externalId,
      Value<double?> usdConversionRate,
    });

class $$ExpensesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usdConversionRate => $composableBuilder(
    column: $table.usdConversionRate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usdConversionRate => $composableBuilder(
    column: $table.usdConversionRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get spentAt =>
      $composableBuilder(column: $table.spentAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get usdConversionRate => $composableBuilder(
    column: $table.usdConversionRate,
    builder: (column) => column,
  );
}

class $$ExpensesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTableTable,
          ExpensesTableData,
          $$ExpensesTableTableFilterComposer,
          $$ExpensesTableTableOrderingComposer,
          $$ExpensesTableTableAnnotationComposer,
          $$ExpensesTableTableCreateCompanionBuilder,
          $$ExpensesTableTableUpdateCompanionBuilder,
          (
            ExpensesTableData,
            BaseReferences<
              _$AppDatabase,
              $ExpensesTableTable,
              ExpensesTableData
            >,
          ),
          ExpensesTableData,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableTableManager(_$AppDatabase db, $ExpensesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExpensesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ExpensesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ExpensesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> spentAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<double?> usdConversionRate = const Value.absent(),
              }) => ExpensesTableCompanion(
                id: id,
                title: title,
                amount: amount,
                currencyCode: currencyCode,
                notes: notes,
                spentAt: spentAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                source: source,
                externalId: externalId,
                usdConversionRate: usdConversionRate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required double amount,
                required String currencyCode,
                Value<String?> notes = const Value.absent(),
                required DateTime spentAt,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<double?> usdConversionRate = const Value.absent(),
              }) => ExpensesTableCompanion.insert(
                id: id,
                title: title,
                amount: amount,
                currencyCode: currencyCode,
                notes: notes,
                spentAt: spentAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                source: source,
                externalId: externalId,
                usdConversionRate: usdConversionRate,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTableTable,
      ExpensesTableData,
      $$ExpensesTableTableFilterComposer,
      $$ExpensesTableTableOrderingComposer,
      $$ExpensesTableTableAnnotationComposer,
      $$ExpensesTableTableCreateCompanionBuilder,
      $$ExpensesTableTableUpdateCompanionBuilder,
      (
        ExpensesTableData,
        BaseReferences<_$AppDatabase, $ExpensesTableTable, ExpensesTableData>,
      ),
      ExpensesTableData,
      PrefetchHooks Function()
    >;
typedef $$EmailImportSettingsTableTableCreateCompanionBuilder =
    EmailImportSettingsTableCompanion Function({
      Value<int> id,
      required String bankSendersJson,
      Value<String> defaultCurrency,
      Value<bool> gmailConnected,
      Value<DateTime?> lastSyncAt,
    });
typedef $$EmailImportSettingsTableTableUpdateCompanionBuilder =
    EmailImportSettingsTableCompanion Function({
      Value<int> id,
      Value<String> bankSendersJson,
      Value<String> defaultCurrency,
      Value<bool> gmailConnected,
      Value<DateTime?> lastSyncAt,
    });

class $$EmailImportSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmailImportSettingsTableTable> {
  $$EmailImportSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankSendersJson => $composableBuilder(
    column: $table.bankSendersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultCurrency => $composableBuilder(
    column: $table.defaultCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get gmailConnected => $composableBuilder(
    column: $table.gmailConnected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmailImportSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailImportSettingsTableTable> {
  $$EmailImportSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankSendersJson => $composableBuilder(
    column: $table.bankSendersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultCurrency => $composableBuilder(
    column: $table.defaultCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get gmailConnected => $composableBuilder(
    column: $table.gmailConnected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmailImportSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailImportSettingsTableTable> {
  $$EmailImportSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankSendersJson => $composableBuilder(
    column: $table.bankSendersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultCurrency => $composableBuilder(
    column: $table.defaultCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get gmailConnected => $composableBuilder(
    column: $table.gmailConnected,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$EmailImportSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailImportSettingsTableTable,
          EmailImportSettingsTableData,
          $$EmailImportSettingsTableTableFilterComposer,
          $$EmailImportSettingsTableTableOrderingComposer,
          $$EmailImportSettingsTableTableAnnotationComposer,
          $$EmailImportSettingsTableTableCreateCompanionBuilder,
          $$EmailImportSettingsTableTableUpdateCompanionBuilder,
          (
            EmailImportSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $EmailImportSettingsTableTable,
              EmailImportSettingsTableData
            >,
          ),
          EmailImportSettingsTableData,
          PrefetchHooks Function()
        > {
  $$EmailImportSettingsTableTableTableManager(
    _$AppDatabase db,
    $EmailImportSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EmailImportSettingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$EmailImportSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$EmailImportSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> bankSendersJson = const Value.absent(),
                Value<String> defaultCurrency = const Value.absent(),
                Value<bool> gmailConnected = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => EmailImportSettingsTableCompanion(
                id: id,
                bankSendersJson: bankSendersJson,
                defaultCurrency: defaultCurrency,
                gmailConnected: gmailConnected,
                lastSyncAt: lastSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String bankSendersJson,
                Value<String> defaultCurrency = const Value.absent(),
                Value<bool> gmailConnected = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => EmailImportSettingsTableCompanion.insert(
                id: id,
                bankSendersJson: bankSendersJson,
                defaultCurrency: defaultCurrency,
                gmailConnected: gmailConnected,
                lastSyncAt: lastSyncAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmailImportSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailImportSettingsTableTable,
      EmailImportSettingsTableData,
      $$EmailImportSettingsTableTableFilterComposer,
      $$EmailImportSettingsTableTableOrderingComposer,
      $$EmailImportSettingsTableTableAnnotationComposer,
      $$EmailImportSettingsTableTableCreateCompanionBuilder,
      $$EmailImportSettingsTableTableUpdateCompanionBuilder,
      (
        EmailImportSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $EmailImportSettingsTableTable,
          EmailImportSettingsTableData
        >,
      ),
      EmailImportSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$ImportedEmailsTableTableCreateCompanionBuilder =
    ImportedEmailsTableCompanion Function({
      required String messageId,
      required int expenseId,
      required DateTime importedAt,
      Value<int> rowid,
    });
typedef $$ImportedEmailsTableTableUpdateCompanionBuilder =
    ImportedEmailsTableCompanion Function({
      Value<String> messageId,
      Value<int> expenseId,
      Value<DateTime> importedAt,
      Value<int> rowid,
    });

class $$ImportedEmailsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ImportedEmailsTableTable> {
  $$ImportedEmailsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expenseId => $composableBuilder(
    column: $table.expenseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImportedEmailsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportedEmailsTableTable> {
  $$ImportedEmailsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expenseId => $composableBuilder(
    column: $table.expenseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportedEmailsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportedEmailsTableTable> {
  $$ImportedEmailsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<int> get expenseId =>
      $composableBuilder(column: $table.expenseId, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );
}

class $$ImportedEmailsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportedEmailsTableTable,
          ImportedEmailsTableData,
          $$ImportedEmailsTableTableFilterComposer,
          $$ImportedEmailsTableTableOrderingComposer,
          $$ImportedEmailsTableTableAnnotationComposer,
          $$ImportedEmailsTableTableCreateCompanionBuilder,
          $$ImportedEmailsTableTableUpdateCompanionBuilder,
          (
            ImportedEmailsTableData,
            BaseReferences<
              _$AppDatabase,
              $ImportedEmailsTableTable,
              ImportedEmailsTableData
            >,
          ),
          ImportedEmailsTableData,
          PrefetchHooks Function()
        > {
  $$ImportedEmailsTableTableTableManager(
    _$AppDatabase db,
    $ImportedEmailsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ImportedEmailsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ImportedEmailsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ImportedEmailsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> messageId = const Value.absent(),
                Value<int> expenseId = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportedEmailsTableCompanion(
                messageId: messageId,
                expenseId: expenseId,
                importedAt: importedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String messageId,
                required int expenseId,
                required DateTime importedAt,
                Value<int> rowid = const Value.absent(),
              }) => ImportedEmailsTableCompanion.insert(
                messageId: messageId,
                expenseId: expenseId,
                importedAt: importedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImportedEmailsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportedEmailsTableTable,
      ImportedEmailsTableData,
      $$ImportedEmailsTableTableFilterComposer,
      $$ImportedEmailsTableTableOrderingComposer,
      $$ImportedEmailsTableTableAnnotationComposer,
      $$ImportedEmailsTableTableCreateCompanionBuilder,
      $$ImportedEmailsTableTableUpdateCompanionBuilder,
      (
        ImportedEmailsTableData,
        BaseReferences<
          _$AppDatabase,
          $ImportedEmailsTableTable,
          ImportedEmailsTableData
        >,
      ),
      ImportedEmailsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExpensesTableTableTableManager get expensesTable =>
      $$ExpensesTableTableTableManager(_db, _db.expensesTable);
  $$EmailImportSettingsTableTableTableManager get emailImportSettingsTable =>
      $$EmailImportSettingsTableTableTableManager(
        _db,
        _db.emailImportSettingsTable,
      );
  $$ImportedEmailsTableTableTableManager get importedEmailsTable =>
      $$ImportedEmailsTableTableTableManager(_db, _db.importedEmailsTable);
}
