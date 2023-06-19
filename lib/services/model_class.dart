class StockData {
  final String? symbol;
  final double? latestPrice;

  StockData({required this.symbol, required this.latestPrice});

  factory StockData.fromJson(Map<String, dynamic> json) {
    final latestDate = json['Meta Data']['3. Last Refreshed'];
    final latestPrice =
        double.parse(json['Time Series (Daily)'][latestDate]['4. close']);
    final symbol = json['Meta Data']['2. Symbol'];

    return StockData(symbol: symbol, latestPrice: latestPrice);
  }
}
