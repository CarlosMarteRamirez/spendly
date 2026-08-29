import 'package:app_for_finance/features/email_import/domain/bank_email_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = BankEmailParser(defaultCurrency: 'DOP');

  test('parses RD\$ amount and merchant', () {
    const body = '''
    Estimado cliente,
    Se realizó una compra por RD\$1,250.50
    en SUPERMARKET NACIONAL SDQ
    Fecha: 15/05/2026 14:30
    ''';

    final result = parser.parse(body: body, subject: 'Alerta de compra');
    expect(result, isNotNull);
    expect(result!.amount, 1250.50);
    expect(result.currencyCode, 'DOP');
    expect(result.title.toLowerCase(), contains('supermarket'));
  });

  test('uses fallback title when email is generic', () {
    const body = 'Cargo por RD\$500.00 en su tarjeta. Fecha 10/05/2026';

    final result = parser.parse(body: body, subject: 'Notificación');
    expect(result, isNotNull);
    expect(result!.title, startsWith('Bank ·'));
  });

  test('returns null when no amount found', () {
    final result = parser.parse(
      body: 'Gracias por usar nuestros servicios.',
      subject: 'Newsletter',
    );
    expect(result, isNull);
  });

  test('parses Qik HTML email (PedidosYa, Monto, not balance)', () {
    const html = '''
    Se hizo una transacción de <b>RD\$ 519.00</b> en <strong>PedidosYa*Market</strong>
    con tu Tarjeta de Débito Qik
    <table>
    <tr><td>Localidad</td><td><strong>PedidosYa*Market</strong></td></tr>
    <tr><td>Fecha y hora</td><td><strong>05-25-2026 08:00 PM (AST)</strong></td></tr>
    <tr><td>Monto</td><td><b>RD\$ 519.00</b></td></tr>
    <tr><td>Balance Disponible</td><td><strong>RD\$ 59,275.92</strong></td></tr>
    </table>
    ''';

    final result = parser.parse(
      body: html,
      subject: 'Transacción con tu Tarjeta de Débito Qik',
    );

    expect(result, isNotNull);
    expect(result!.amount, 519.00);
    expect(result.currencyCode, 'DOP');
    expect(result.title, 'PedidosYa*Market');
    expect(result.spentAt.month, 5);
    expect(result.spentAt.day, 25);
    expect(result.spentAt.year, 2026);
    expect(result.spentAt.hour, 20);
  });

  test('parses Chase card transaction email (USD, merchant, amount, date)', () {
    const body = '''
    Chase Freedom Unlimited ending in 4321
    A charge of \$89.90 at AMAZON.COM was authorized on Aug 28, 2026.
    Merchant: AMAZON.COM
    Amount: \$89.90
    Date: Aug 28, 2026
    ''';

    final result = parser.parse(
      body: body,
      subject: 'Your \$89.90 transaction with AMAZON.COM',
    );

    expect(result, isNotNull);
    expect(result!.amount, 89.90);
    expect(result.currencyCode, 'USD');
    expect(result.title, 'AMAZON.COM');
    expect(result.spentAt.month, 8);
    expect(result.spentAt.day, 28);
    expect(result.spentAt.year, 2026);
  });

  test('parses Chase e-bill / statement (factura) email', () {
    const body = '''
    Your Chase Credit Card statement is now ready to view online.
    Statement balance: \$1,245.80
    Minimum payment due: \$35.00
    Payment due date: Sep 15, 2026
    ''';

    final result = parser.parse(
      body: body,
      subject: 'Your Chase credit card statement is ready',
    );

    expect(result, isNotNull);
    expect(result!.amount, 1245.80);
    expect(result.currencyCode, 'USD');
    expect(result.title, contains('Chase'));
    expect(result.spentAt.month, 9);
    expect(result.spentAt.day, 15);
    expect(result.spentAt.year, 2026);
  });
}
