import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'widgets/crypto_card.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency;
  List<Widget> allCryptoCards;

  @override
  void initState() {
    super.initState();
    selectedCurrency = 'USD';
    allCryptoCards = emptyCryptoCards(selectedCurrency);
    this.updateUI();
  }

  List<DropdownMenuItem<String>> populateMenu() {
    List<DropdownMenuItem<String>> menuItems = [];

    for (String ticker in currenciesList)
      menuItems.add(DropdownMenuItem(child: Text(ticker), value: ticker));

    return menuItems;
  }

  List<Widget> cupertinoMenu() {
    List<Widget> menu = [];

    for (String currency in currenciesList) menu.add(Text(currency));
    return menu;
  }

  DropdownButton<String> getAndroidDropdown() {
    return DropdownButton<String>(
        value: selectedCurrency,
        items: populateMenu(),
        onChanged: (value) async {
          selectedCurrency = value;
          var cards = await cryptoCards(selectedCurrency);
          setState(() {
            allCryptoCards = cards;
          });
        });
  }

  CupertinoPicker getiOSPicker() {
    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) async {
          print(currenciesList[selectedIndex]);

          selectedCurrency = currenciesList[selectedIndex];
          var cards = await cryptoCards(selectedCurrency);

          setState(() {
            allCryptoCards = cards;
          });
        },
        children: cupertinoMenu());
  }

  List<Widget> emptyCryptoCards(String fCurrency) {
    List<Widget> cards = [];
    for (String cryptoCurrency in cryptoList) {
      String rate = '?';
      cards.add(CryptoCard(
        cryptoCurrency: cryptoCurrency,
        fiatCurrency: fCurrency,
        rate: rate,
      ));
    }
    return cards;
  }

  Future<List<Widget>> cryptoCards(String fCurrency) async {
    List<Widget> cards = [];

    for (String cryptoCurrency in cryptoList) {
      // Retrieve Actual rate from the API
      String rate = await CoinData().getCoinRate(cryptoCurrency, fCurrency);

      Widget card = CryptoCard(
        cryptoCurrency: cryptoCurrency,
        fiatCurrency: fCurrency,
        rate: rate,
      );

      cards.add(card);
    }
    return cards;
  }

  void updateUI() async {
    var pulledRateCards = await cryptoCards(selectedCurrency);
    setState(() {
      allCryptoCards = pulledRateCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: allCryptoCards,
          ),
          Expanded(
            child: SizedBox(),
          ),
          Expanded(
            child: Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? getiOSPicker() : getAndroidDropdown(),
            ),
          )
        ],
      ),
    );
  }
}
