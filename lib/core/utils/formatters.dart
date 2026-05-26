import 'package:intl/intl.dart';

const _monthsEn = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatShortDate(DateTime date) {
  return '${_monthsEn[date.month - 1]} ${date.day}';
}

String formatExpenseDate(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${formatShortDate(date)}, $hour:$minute';
}

String formatMoney(double amount, String currencyCode) {
  if (currencyCode == 'DOP') {
    final formatted = NumberFormat('#,##0.00', 'en_US').format(amount);
    return 'RD\$$formatted';
  }
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
