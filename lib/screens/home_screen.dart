import 'package:flutter/material.dart';
import 'package:untitled/services/currency_service.dart';
import 'package:untitled/model/currency_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _currencyService = CurrencyService();

  Map<String, double> _rates = {};
  List<String> _currencies = [];

  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  CurrencyConversion? _conversion;

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    try {
      final rates = await _currencyService.fetchRates();
      setState(() {
        _rates = rates;
        _currencies = rates.keys.toList();
        if (!_currencies.contains(_fromCurrency)) _fromCurrency = _currencies.first;
        if (!_currencies.contains(_toCurrency)) _toCurrency = _currencies[1];
      });
    } catch (e) {
      print('Error fetching rates: $e');
    }
  }

  void _convertCurrency() {
    final amount = double.tryParse(_controller.text);
    if (amount == null || !_rates.containsKey(_fromCurrency) || !_rates.containsKey(_toCurrency)) return;

    final fromRate = _rates[_fromCurrency]!;
    final toRate = _rates[_toCurrency]!;
    final converted = amount * (toRate / fromRate);

    setState(() {
      _conversion = CurrencyConversion(
        fromCurrency: _fromCurrency,
        toCurrency: _toCurrency,
        inputAmount: amount,
        convertedAmount: converted,
      );
    });
  }

  void _switchCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _convertCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _rates.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _fromCurrency,
                    isExpanded: true,
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(value: currency, child: Text(currency));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _fromCurrency = value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: _toCurrency,
                    isExpanded: true,
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(value: currency, child: Text(currency));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _toCurrency = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                onPressed: _switchCurrencies,
                icon: const Icon(Icons.swap_vert),
                label: const Text('Switch Currencies'),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount in $_fromCurrency',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => _convertCurrency(),
            ),
            const SizedBox(height: 20),
            if (_conversion != null)
              Text(
                '${_conversion!.inputAmount.toStringAsFixed(2)} ${_conversion!.fromCurrency} = '
                    '${_conversion!.convertedAmount.toStringAsFixed(2)} ${_conversion!.toCurrency}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}