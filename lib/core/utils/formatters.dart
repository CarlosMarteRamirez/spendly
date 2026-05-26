import 'package:intl/intl.dart';

const _monthsEs = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

String formatShortDate(DateTime date) {
  return '${date.day} ${_monthsEs[date.month - 1]}';
}

String formatExpenseDate(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${formatShortDate(date)}, $hour:$minute';
}

String formatMoney(double amount, String currencyCode) {
  return NumberFormat.currency(
    locale: 'en_US',
    name: currencyCode,
    decimalDigits: 2,
  ).format(amount);
}

String formatMoneyCompact(double amount) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
    decimalDigits: 2,
  ).format(amount);
}
