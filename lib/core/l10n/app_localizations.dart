import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isSpanish => locale.languageCode.toLowerCase().startsWith('es');

  // ── Expenses List & Navigation ──
  String get myExpenses => isSpanish ? 'Mis gastos' : 'My expenses';
  String get bankEmailImport => isSpanish ? 'Importar correos' : 'Bank email import';
  String get newExpense => isSpanish ? 'Nuevo' : 'New';
  String get transactions => isSpanish ? 'Transacciones' : 'Transactions';
  String get deleteExpense => isSpanish ? 'Eliminar gasto' : 'Delete expense';
  String get deleteConfirmationContent => isSpanish ? 'Esta acción no se puede deshacer.' : 'This action cannot be undone.';
  String get cancel => isSpanish ? 'Cancelar' : 'Cancel';
  String get delete => isSpanish ? 'Eliminar' : 'Delete';
  String expenseDeleted(String title) => isSpanish ? '"$title" eliminado' : '"$title" deleted';

  // ── Summary Hero ──
  String get summary => isSpanish ? 'Resumen' : 'Summary';
  String get thisMonthUsd => isSpanish ? 'Este mes (USD)' : 'This month (USD)';
  String get today => isSpanish ? 'Hoy' : 'Today';
  String get total => isSpanish ? 'Total' : 'Total';
  String get items => isSpanish ? 'Gastos' : 'Items';

  // ── Filter Section ──
  String get searchByTitle => isSpanish ? 'Buscar por título' : 'Search by title';
  String get all => isSpanish ? 'Todos' : 'All';
  String get fromDate => isSpanish ? 'Desde' : 'From';
  String get toDate => isSpanish ? 'Hasta' : 'To';
  String get clearFilters => isSpanish ? 'Limpiar' : 'Clear';

  // ── Empty State ──
  String get noExpensesYet => isSpanish ? 'Sin gastos aún' : 'No expenses yet';
  String get addFirstExpenseHint => isSpanish ? 'Agrega tu primer gasto con el botón Nuevo' : 'Add your first expense with the New button';

  // ── Expense Form ──
  String get newExpenseTitle => isSpanish ? 'Nuevo gasto' : 'New expense';
  String get editExpenseTitle => isSpanish ? 'Editar gasto' : 'Edit expense';
  String get details => isSpanish ? 'Detalles' : 'Details';
  String get titleOptional => isSpanish ? 'Título (opcional)' : 'Title (optional)';
  String get amount => isSpanish ? 'Monto' : 'Amount';
  String get validAmountError => isSpanish ? 'Ingresa un monto válido mayor a 0.' : 'Enter a valid amount greater than 0.';
  String get currency => isSpanish ? 'Moneda' : 'Currency';
  String get usdConversionRate => isSpanish ? 'Tasa de cambio USD' : 'USD conversion rate';
  String get usdConversionRateFixed => isSpanish ? 'Tasa de cambio USD (fija)' : 'USD conversion rate (fixed)';
  String usdRateHint(String code) => '1 USD = ? $code';
  String get validUsdRateError => isSpanish ? 'Ingresa una tasa de cambio USD válida.' : 'Enter a valid USD conversion rate.';
  String get fetchHistoricalUsdRate => isSpanish ? 'Obtener tasa USD histórica' : 'Fetch historical USD rate';
  String get dateTimeLabel => isSpanish ? 'Fecha y hora' : 'Date and time';
  String get notesOptional => isSpanish ? 'Notas (opcional)' : 'Notes (optional)';
  String get saveExpense => isSpanish ? 'Guardar gasto' : 'Save expense';
  String get saveChanges => isSpanish ? 'Guardar cambios' : 'Save changes';
  String get fetchRateError => isSpanish ? 'No se pudo obtener la tasa de cambio en este momento.' : 'Could not fetch exchange rate right now.';
  String get untitledExpense => isSpanish ? 'Gasto' : 'Expense';

  // ── Total Breakdown ──
  String get totalBreakdown => isSpanish ? 'Desglose total' : 'Total breakdown';
  String get noExpensesRecorded => isSpanish ? 'No hay gastos registrados' : 'No expenses recorded';
  String get noExpensesRecordedSub => isSpanish ? 'Agrega gastos para ver su desglose por meses y años.' : 'Add expenses to the database to see their breakdown by months and years.';
  String errorLoadingBreakdown(String err) => isSpanish ? 'Error al cargar el desglose: $err' : 'Error loading breakdown: $err';
  String transactionCount(int count) => isSpanish ? '$count ${count == 1 ? 'transacción' : 'transacciones'}' : '$count ${count == 1 ? 'transaction' : 'transactions'}';
  String pctOfTotal(String pct) => isSpanish ? '$pct% del total' : '$pct% of total';
  String pctOfYear(String pct) => isSpanish ? '$pct% del año' : '$pct% of year';

  // ── Email Import Page ──
  String get bankEmailImportPageTitle => isSpanish ? 'Importar correos bancarios' : 'Bank email import';
  String get automaticExpenses => isSpanish ? 'Gastos automáticos' : 'Automatic expenses';
  String get automaticExpensesDesc => isSpanish
      ? 'Spendly lee los correos de notificación bancaria desde Gmail y crea los gastos automáticamente. Los títulos provienen del comercio en el correo, o "Banco · fecha" cuando no está claro. Moneda predeterminada: RD\$ (DOP).'
      : 'Spendly reads bank notification emails from Gmail and creates expenses automatically. Titles come from the merchant in the email, or "Bank · date" when unclear. Default currency: RD\$ (DOP).';
  String get bankEmailsInfoNote => isSpanish
      ? 'Los correos bancarios deben llegar a la cuenta de Gmail con la que inicies sesión. Para agregar un gasto manualmente, usa Nuevo en la pantalla principal.'
      : 'Bank emails must arrive in the Gmail account you sign in with. To add a charge manually, use New on the home screen.';
  String get gmail => isSpanish ? 'Gmail' : 'Gmail';
  String lastSync(String time) => isSpanish ? 'Última sincronización: $time' : 'Last sync: $time';
  String get signInAndSyncGmail => isSpanish ? 'Iniciar sesión y sincronizar Gmail' : 'Sign in & sync Gmail';
  String get syncing => isSpanish ? 'Sincronizando…' : 'Syncing…';
  String get signOutGmail => isSpanish ? 'Cerrar sesión de Gmail' : 'Sign out of Gmail';
  String get bankSenders => isSpanish ? 'Emisores bancarios' : 'Bank senders';
  String get sendersHintLine => isSpanish ? 'Uno por línea: correo o dominio (ej. qik.do)' : 'One per line: email or domain (e.g. qik.do)';
  String get saveSenders => isSpanish ? 'Guardar emisores' : 'Save senders';
  String get resetDefaults => isSpanish ? 'Restablecer predeterminados' : 'Reset defaults';
  String get sendersSaved => isSpanish ? 'Emisores guardados.' : 'Senders saved.';
  String syncResult({required int imported, required int skipped, required int failed}) => isSpanish
      ? 'Listo: $imported importados, $skipped omitidos, $failed no se pudieron procesar.'
      : 'Done: $imported imported, $skipped skipped, $failed could not parse.';
  String syncFailed(String err) => isSpanish ? 'Falló la sincronización con Gmail: $err' : 'Gmail sync failed: $err';

  // ── Month Names ──
  String monthName(int month) {
    const en = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    const es = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    if (month >= 1 && month <= 12) {
      return isSpanish ? es[month - 1] : en[month - 1];
    }
    return '';
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode.toLowerCase());
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
