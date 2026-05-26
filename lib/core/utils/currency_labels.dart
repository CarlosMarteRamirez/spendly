/// ISO currency code shown in the UI (e.g. DOP → RD$).
String currencyChipLabel(String code) {
  switch (code) {
    case 'DOP':
      return r'RD$';
    default:
      return code;
  }
}
