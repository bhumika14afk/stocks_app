import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_app/pages/watchlist.dart';
import 'package:stocks_app/services/api_services.dart';
import 'package:stocks_app/services/model_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<StockData> stockDataList = [];
  List<StockData> filteredStockDataList = [];

  @override
  void initState() {
    super.initState();
    final urls = [
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=IBM&outputsize=full',
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=TSCO.LON&outputsize=full',
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=SHOP.TRT&outputsize=full',
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=GPV.TRV&outputsize=full',
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=DAI.DEX&outputsize=full',
    ];

    const apiKey = 'GA5AYEWFF288PV59';

    final stockDataFutures = urls.map((url) => fetchStockData(url, apiKey));
    Future.wait(stockDataFutures).then((data) {
      setState(() {
        stockDataList = data.expand((element) => element).toList();
        filteredStockDataList = stockDataList;
      });
    });
  }

  void filterStocks(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredStockDataList = stockDataList
            .where((stock) =>
                stock.symbol!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredStockDataList = stockDataList;
      }
    });
  }

  void addToWatchlist(StockData stock) {
    final watchlistProvider =
        Provider.of<WatchlistProvider>(context, listen: false);
    watchlistProvider.addToWatchlist(stock);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trade Brains"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              onChanged: filterStocks,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                    },
                    icon: const Icon(Icons.close)),
                suffixIcon: IconButton(
                    onPressed: () {
                      filterStocks;
                      FocusScope.of(context).unfocus();
                    },
                    icon: const Icon(Icons.search)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStockDataList.length,
              itemBuilder: (context, index) {
                final stockData = filteredStockDataList[index];
                return ListTile(
                  title: Text('${stockData.symbol}'),
                  subtitle: Text('Latest Price: ${stockData.latestPrice}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      addToWatchlist(stockData);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
