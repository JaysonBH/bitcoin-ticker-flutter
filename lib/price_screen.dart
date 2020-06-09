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
  var rateData;
  double rate = 0.0;

  List<DropdownMenuItem<String>> populateMenu() {
    List<DropdownMenuItem<String>> menuItems = [];

    for (String ticker in currenciesList)
      menuItems.add(DropdownMenuItem(child: Text(ticker), value: ticker));

    return menuItems;
  }

  DropdownButton<String> getAndroidDropdown() {
    return DropdownButton<String>(
        value: selectedCurrency,
        items: populateMenu(),
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            allCryptoCards = cryptoCards(selectedCurrency);
          });
        });
  }

  List<Widget> cupertinoMenu() {
    List<Widget> menu = [];

    for (String currency in currenciesList) menu.add(Text(currency));
    return menu;
  }

  CupertinoPicker getiOSPicker() {
    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          print(currenciesList[selectedIndex]);
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            allCryptoCards = cryptoCards(selectedCurrency);
          });
        },
        children: cupertinoMenu());
  }

  List<Widget> emptyCryptoCards(String fCurrency) {
    List<Widget> cards = [];
    for (String cryptoCurrency in cryptoList) {
      double rate = 0.0;
      cards.add(CryptoCard(
        cryptoCurrency: cryptoCurrency,
        fiatCurrency: fCurrency,
        rate: rate,
      ));
    }
    return cards;
  }

  List<Widget> cryptoCards(String fCurrency) {
    List<Widget> cards = [];
    for (String cryptoCurrency in cryptoList) {
      //TODO Retrieve Actual rate from the API
      double rate = 0.0;
      cards.add(CryptoCard(
        cryptoCurrency: cryptoCurrency,
        fiatCurrency: fCurrency,
        rate: rate,
      ));
    }
    return cards;
  }

  @override
  void initState() {
    super.initState();
    //rateData = CoinData().getCoinRate('BTC', 'USD');
    //print(rateData);
    selectedCurrency = 'USD';
    allCryptoCards = emptyCryptoCards(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
