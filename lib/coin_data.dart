import 'services/network.dart';

const String coinApiBaseUrl = 'https://rest.coinapi.io';
const String getExchangeRateApiPath = '/v1/exchangerate';
const apiKey = 'CHANGE-ME';

const List<String> currenciesList = [
  'USD',
  'CAD',
  'AUD',
  'BRL',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinData(
      String cryptoCurrency, String fiatCurrency) async {
    String url =
        '$coinApiBaseUrl$getExchangeRateApiPath/$cryptoCurrency/$fiatCurrency?apiKey=$apiKey';
    return await NetworkHelper(url).getData();
  }

  Future<String> getCoinRate(String cryptoCurrency, String fiatCurrency) async {
    var jsonResponse = await getCoinData(cryptoCurrency, fiatCurrency);
    print(jsonResponse);
    double retrievedRate = jsonResponse['rate'];
    return retrievedRate.toStringAsFixed(2);
  }
}
