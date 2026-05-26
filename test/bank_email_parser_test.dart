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
}
