import 'package:untitled/model/currency_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String apiUrl = 'https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_uJjsinmRvZPmOYYcxStmLTH8fCRKSNaHak6vPX8k&currencies=EUR%2CUSD%2CCAD%2CGBP%2CAUD&base_currency=EUR';

  Future<Map<String, double>> fetchRates() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final Map<String, dynamic> data = jsonData['data'];
      return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}