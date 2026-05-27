import 'dart:convert';

import 'package:http/http.dart' as http;

class UsdExchangeRateService {
  const UsdExchangeRateService({http.Client? client}) : _client = client;

  final http.Client? _client;

  Future<double?> getUsdToCurrencyRate({
    required String currencyCode,
    required DateTime date,
  }) async {
    final normalizedCode = currencyCode.toUpperCase();
    if (normalizedCode == 'USD') return 1.0;

    final client = _client ?? http.Client();
    final closeClient = _client == null;
    try {
      final historicalRate = await _getHistoricalRateFromCurrencyApi(
        client: client,
        currencyCode: normalizedCode,
        date: date,
      );
      if (historicalRate != null) return historicalRate;

      // Last fallback: use latest available rate so totals don't default to 1:1.
      return _getLatestRateFromCurrencyApi(
        client: client,
        currencyCode: normalizedCode,
      );
    } catch (_) {
      return null;
    } finally {
      if (closeClient) {
        client.close();
      }
    }
  }

  Future<double?> _getHistoricalRateFromCurrencyApi({
    required http.Client client,
    required String currencyCode,
    required DateTime date,
  }) async {
    final dateKey =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    final lowerCode = currencyCode.toLowerCase();
    final uri = Uri.parse(
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@$dateKey/v1/currencies/usd.json',
    );
    final response = await client.get(uri);
    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic>) return null;
    final usdRates = json['usd'];
    if (usdRates is! Map<String, dynamic>) return null;
    final rate = usdRates[lowerCode];
    if (rate is num && rate > 0) return rate.toDouble();
    return null;
  }

  Future<double?> _getLatestRateFromCurrencyApi({
    required http.Client client,
    required String currencyCode,
  }) async {
    final lowerCode = currencyCode.toLowerCase();
    final uri = Uri.parse(
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json',
    );
    final response = await client.get(uri);
    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic>) return null;
    final usdRates = json['usd'];
    if (usdRates is! Map<String, dynamic>) return null;
    final rate = usdRates[lowerCode];
    if (rate is num && rate > 0) return rate.toDouble();
    return null;
  }
}
