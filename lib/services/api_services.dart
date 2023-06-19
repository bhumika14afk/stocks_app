import 'dart:convert';

import 'package:stocks_app/services/model_class.dart';
import 'package:http/http.dart' as http;

Future<List<StockData>> fetchStockData(String url, String apiKey) async {
  final response = await http.get(Uri.parse('$url&apikey=$apiKey'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final stockData = StockData.fromJson(jsonData);

    return [stockData];
  } else {
    throw Exception('Failed to fetch stock data');
  }
}
