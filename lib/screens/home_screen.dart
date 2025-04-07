import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/currency_service.dart';

class CurrencyExchangeScreen extends StatefulWidget {
  @override
  CurrencyExchangeScreenState createState() => CurrencyExchangeScreenState();
}

class CurrencyExchangeScreenState extends State<CurrencyExchangeScreen> {
  final TextEditingController _amountController = TextEditingController();
  final CurrencyConverter currencyConverter = CurrencyConverter();
  double exchangedAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Exchange')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Enter amount'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: Text('Switch Currency'),
            ),
            Text('Converted Amount: $exchangedAmount'),
          ],
        ),
      ),
    );
  }

  void _convertCurrency() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null) {
      // Call the business logic to perform conversion
      setState(() {
        exchangedAmount = currencyConverter.convertCurrency(amount);
      });
    }
  }
}