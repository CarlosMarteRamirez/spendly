import 'package:app_for_finance/core/utils/expense_display.dart';
import 'package:app_for_finance/features/email_import/domain/email_body_normalizer.dart';
import 'package:app_for_finance/features/email_import/domain/parsed_bank_transaction.dart';

/// Extracts amount, date, and a reasonable title from bank notification emails.
///
/// Supports both Dominican-Republic banks (Spanish, RD$/DOP) and US banks
/// (English, USD) such as Bank of America, Chase, Citibank, U.S. Bank,
/// Capital One, and Banco Santa Cruz.
class BankEmailParser {
  const BankEmailParser({this.defaultCurrency = 'DOP'});

  final String defaultCurrency;

  static const _genericSubjects = {
    // Spanish
    'notificacion',
    'notificación',
    'alerta',
    'transaccion',
    'transacción',
    'compra',
    'cargo',
    'debito',
    'débito',
    'aviso',
    // English
    'alert',
    'notification',
    'transaction',
    'purchase',
    'charge',
    'debit',
    'fraud',
    'security',
    'account',
    'statement',
  };

  ParsedBankTransaction? parse({
    required String body,
    String? subject,
    String? messageId,
  }) {
    final normalizedBody = normalizeEmailBody(body);
    final normalizedSubject = subject != null ? normalizeEmailBody(subject) : null;
    final text = '${normalizedSubject ?? ''}\n$normalizedBody';

    final amount = _extractAmount(text);
    if (amount == null || amount <= 0) {
      return null;
    }

    final currency = _extractCurrency(text) ?? defaultCurrency;
    final spentAt = _extractDate(text) ?? DateTime.now();
    final merchant = _extractMerchant(text, normalizedSubject);
    final title = _buildTitle(merchant, normalizedSubject, spentAt);

    return ParsedBankTransaction(
      amount: amount,
      currencyCode: currency,
      spentAt: spentAt,
      title: title,
      merchant: merchant,
      messageId: messageId,
    );
  }

  double? _extractAmount(String text) {
    // ── Dominican / Qik-style: labeled "Monto" ──────────────────────────
    final montoMatch = RegExp(
      r'Monto\s+RD\$\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    ).firstMatch(text);
    if (montoMatch != null) {
      final value = _parseNumber(montoMatch.group(1)!);
      if (value != null && value > 0) {
        return value;
      }
    }

    // Qik / DR: "transacción de RD$ 519.00 en ..."
    final txnMatch = RegExp(
      r'transacci[oó]n de\s+RD\$\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    ).firstMatch(text);
    if (txnMatch != null) {
      final value = _parseNumber(txnMatch.group(1)!);
      if (value != null && value > 0) {
        return value;
      }
    }

    // ── US banks: labeled amount fields ──────────────────────────────────
    // "Amount: $123.45", "Amount $123.45", "Total: $50.00"
    final labeledUsd = RegExp(
      r'(?:amount|total|charge|transaction amount)[:\s]*\$\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    ).firstMatch(text);
    if (labeledUsd != null) {
      final value = _parseNumber(labeledUsd.group(1)!);
      if (value != null && value > 0) {
        return value;
      }
    }

    // Chase / BofA: "A charge/transaction of $123.45"
    final chargeOf = RegExp(
      r'(?:charge|transaction|purchase|payment)\s+of\s+\$\s*([\d,]+(?:\.\d{2})?)',
      caseSensitive: false,
    ).firstMatch(text);
    if (chargeOf != null) {
      final value = _parseNumber(chargeOf.group(1)!);
      if (value != null && value > 0) {
        return value;
      }
    }

    // Capital One: "A $123.45 transaction" or "$123.45 charge"
    final dollarBefore = RegExp(
      r'\$\s*([\d,]+(?:\.\d{2})?)\s+(?:transaction|charge|purchase|payment|debit)',
      caseSensitive: false,
    ).firstMatch(text);
    if (dollarBefore != null) {
      final value = _parseNumber(dollarBefore.group(1)!);
      if (value != null && value > 0) {
        return value;
      }
    }

    // ── Generic patterns (DR banks) ─────────────────────────────────────
    final patterns = [
      RegExp(r'RD\$\s*([\d,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(
        r'(?:monto|importe|total|amount|valor)[:\s]*(?:RD\$|RD|DOP|\$)?\s*([\d,]+(?:\.\d{2})?)',
        caseSensitive: false,
      ),
      RegExp(r'(?:RD|DOP)\s*([\d,]+(?:\.\d{2})?)', caseSensitive: false),
      RegExp(
        r'\$\s*([\d,]+(?:\.\d{2})?)(?:\s*(?:DOP|RD\$|RD|USD|pesos))?',
        caseSensitive: false,
      ),
      RegExp(r'([\d,]+\.\d{2})\s*(?:DOP|RD\$|pesos|USD)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      for (final match in pattern.allMatches(text)) {
        final value = _parseNumber(match.group(1)!);
        if (value == null || value <= 0) continue;
        // Skip balance lines when using generic scan.
        final start = match.start;
        final windowStart = start > 40 ? start - 40 : 0;
        final window = text.substring(windowStart, start).toLowerCase();
        if (window.contains('balance') || window.contains('available') || window.contains('credit limit')) {
          continue;
        }
        return value;
      }
    }
    return null;
  }

  String? _extractCurrency(String text) {
    if (RegExp(r'RD\$|DOP|pesos?\s+dominic', caseSensitive: false).hasMatch(text)) {
      return 'DOP';
    }
    if (RegExp(r'\bUSD\b|US\$', caseSensitive: false).hasMatch(text)) {
      return 'USD';
    }
    if (RegExp(r'\bEUR\b', caseSensitive: false).hasMatch(text)) {
      return 'EUR';
    }
    if (RegExp(r'\bMXN\b', caseSensitive: false).hasMatch(text)) {
      return 'MXN';
    }
    // US banks with bare $ but no RD$ context → USD
    if (RegExp(r'\$\s*[\d,]+(?:\.\d{2})?').hasMatch(text)) {
      return 'USD';
    }
    return null;
  }

  DateTime? _extractDate(String text) {
    final patterns = [
      // Qik: 05-25-2026 08:00 PM (AST)
      RegExp(
        r'(\d{1,2})-(\d{1,2})-(\d{4})\s+(\d{1,2}):(\d{2})\s*(AM|PM)',
        caseSensitive: false,
      ),
      // US: "on July 25, 2026" or "on Jul 25, 2026"
      RegExp(
        r'(?:on|date[:\s]*)\s*(\w+)\s+(\d{1,2}),?\s+(\d{4})',
        caseSensitive: false,
      ),
      RegExp(
        r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})(?:\s+(\d{1,2}):(\d{2}))?',
      ),
      RegExp(
        r'(\d{4})-(\d{2})-(\d{2})(?:[T\s](\d{2}):(\d{2}))?',
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match == null) continue;

      try {
        // MM-dd-yyyy hh:mm AM/PM
        if (match.groupCount >= 6 && match.group(6) != null) {
          final month = int.parse(match.group(1)!);
          final day = int.parse(match.group(2)!);
          final year = int.parse(match.group(3)!);
          var hour = int.parse(match.group(4)!);
          final minute = int.parse(match.group(5)!);
          final amPm = match.group(6)!.toUpperCase();
          if (amPm == 'PM' && hour < 12) hour += 12;
          if (amPm == 'AM' && hour == 12) hour = 0;
          return DateTime(year, month, day, hour, minute);
        }

        // "on July 25, 2026" — named month
        if (match.groupCount >= 3 && _monthFromName(match.group(1)!) != null) {
          final month = _monthFromName(match.group(1)!)!;
          final day = int.parse(match.group(2)!);
          final year = int.parse(match.group(3)!);
          return DateTime(year, month, day, 12, 0);
        }

        if (match.groupCount >= 3 && (match.group(3)?.length ?? 0) == 4) {
          final day = int.parse(match.group(1)!);
          final month = int.parse(match.group(2)!);
          final year = int.parse(match.group(3)!);
          final hour = int.tryParse(match.group(4) ?? '') ?? 12;
          final minute = int.tryParse(match.group(5) ?? '') ?? 0;
          return DateTime(year, month, day, hour, minute);
        }
        if (match.group(1)!.length == 4) {
          final year = int.parse(match.group(1)!);
          final month = int.parse(match.group(2)!);
          final day = int.parse(match.group(3)!);
          final hour = int.tryParse(match.group(4) ?? '') ?? 12;
          final minute = int.tryParse(match.group(5) ?? '') ?? 0;
          return DateTime(year, month, day, hour, minute);
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  /// Maps English month names (and 3-letter abbreviations) to their number.
  static int? _monthFromName(String name) {
    const months = {
      'january': 1, 'jan': 1,
      'february': 2, 'feb': 2,
      'march': 3, 'mar': 3,
      'april': 4, 'apr': 4,
      'may': 5,
      'june': 6, 'jun': 6,
      'july': 7, 'jul': 7,
      'august': 8, 'aug': 8,
      'september': 9, 'sep': 9, 'sept': 9,
      'october': 10, 'oct': 10,
      'november': 11, 'nov': 11,
      'december': 12, 'dec': 12,
    };
    return months[name.toLowerCase()];
  }

  String? _extractMerchant(String text, String? subject) {
    // Qik table: Localidad … PedidosYa*Market
    final localidad = RegExp(
      r'Localidad\s+([A-Za-z0-9*][A-Za-z0-9*\s.\-]{2,60}?)(?=\s+Fecha y hora|\s+Monto|\n)',
      caseSensitive: false,
    ).firstMatch(text);
    if (localidad != null) {
      final cleaned = _cleanLabel(localidad.group(1)!);
      if (cleaned.length >= 3 && !_isWeakMerchant(cleaned)) {
        return cleaned;
      }
    }

    // Qik sentence: transacción de RD$ … en PedidosYa*Market con tu
    final qikTxn = RegExp(
      r'transacci[oó]n de\s+RD\$\s*[\d,.]+\s+en\s+([^\n]+?)\s+con tu',
      caseSensitive: false,
    ).firstMatch(text);
    if (qikTxn != null) {
      final cleaned = _cleanLabel(qikTxn.group(1)!);
      if (cleaned.length >= 3 && !_isWeakMerchant(cleaned)) {
        return cleaned;
      }
    }

    // US banks: "at MERCHANT_NAME on …" or "at MERCHANT_NAME."
    final atMerchant = RegExp(
      r'(?:made\s+)?at\s+([A-Za-z0-9][^\n]{2,60}?)(?:\s+on\s+|\s+was\s+|\s*\.)',
      caseSensitive: false,
    ).firstMatch(text);
    if (atMerchant != null) {
      final cleaned = _cleanLabel(atMerchant.group(1)!);
      if (cleaned.length >= 3 && !_isWeakMerchant(cleaned)) {
        return cleaned;
      }
    }

    // US banks: "Merchant: SOME NAME" or "Description: SOME NAME"
    final merchantLabel = RegExp(
      r'(?:merchant|description|payee)[:\s]+([A-Za-z0-9][^\n]{2,80})',
      caseSensitive: false,
    ).firstMatch(text);
    if (merchantLabel != null) {
      final cleaned = _cleanLabel(merchantLabel.group(1)!);
      if (cleaned.length >= 3 && !_isWeakMerchant(cleaned)) {
        return cleaned;
      }
    }

    final patterns = [
      RegExp(
        r'(?:en|at|comercio|establecimiento|merchant|descripci[oó]n|lugar)[:\s]+([^\n\r]{3,80})',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:compra|purchase)\s+(?:en|at|en\s+)\s*([^\n\r]{3,80})',
        caseSensitive: false,
      ),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final cleaned = _cleanLabel(match.group(1)!);
        if (cleaned.length >= 3 && !_isWeakMerchant(cleaned)) {
          return cleaned;
        }
      }
    }

    if (subject != null) {
      final fromSubject = _merchantFromSubject(subject);
      if (fromSubject != null) {
        return fromSubject;
      }
    }
    return null;
  }

  String? _merchantFromSubject(String subject) {
    final cleaned = subject.trim();
    if (cleaned.isEmpty || _isGenericSubject(cleaned)) {
      return null;
    }
    final parts = cleaned.split(RegExp(r'\s*[-|•]\s*'));
    for (final part in parts) {
      final label = _cleanLabel(part);
      if (label.length >= 3 && !_isGenericSubject(label)) {
        return label;
      }
    }
    return null;
  }

  String _buildTitle(String? merchant, String? subject, DateTime spentAt) {
    if (merchant != null && merchant.trim().isNotEmpty) {
      return merchant;
    }
    if (subject != null) {
      final fromSubject = _cleanLabel(subject);
      if (fromSubject.isNotEmpty && !_isGenericSubject(fromSubject)) {
        return fromSubject.length > 60
            ? '${fromSubject.substring(0, 57)}...'
            : fromSubject;
      }
    }
    return importedExpenseFallbackTitle(spentAt);
  }

  bool _isWeakMerchant(String value) {
    final lower = value.toLowerCase();
    const weakPhrases = [
      // Spanish
      'su tarjeta',
      'su cuenta',
      'fecha',
      'estimado',
      'cliente',
      'tarjeta de',
      'con tu tarjeta',
      'balance',
      // English
      'your card',
      'your account',
      'credit card',
      'debit card',
      'ending in',
      'account ending',
      'card ending',
      'thank you',
      'dear customer',
      'has been',
    ];
    return weakPhrases.any((phrase) => lower.contains(phrase));
  }

  bool _isGenericSubject(String value) {
    final lower = value.toLowerCase();
    return _genericSubjects.any(
      (word) => lower == word || lower.startsWith('$word '),
    );
  }

  String _cleanLabel(String raw) {
    return raw.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  double? _parseNumber(String raw) {
    final normalized = raw.replaceAll(',', '');
    return double.tryParse(normalized);
  }
}
