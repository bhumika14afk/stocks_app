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
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=TATACHEM.BSE&outputsize=full',
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=TATACOMM.BSE&outputsize=full',
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=TATAELXSI.BSE&outputsize=full',
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=TATAPOWER.BSE&outputsize=full',
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=TATACOFFEE.BSE&outputsize=full',
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
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final watchlist = watchlistProvider.watchlist;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Trade Brains"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTapOutside: ((event) {
                FocusScope.of(context).unfocus();
              }),
              textInputAction: TextInputAction.search,
              onChanged: filterStocks,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                    },
                    icon: const Icon(Icons.close)),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                        onPressed: () {
                          filterStocks;
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        )),
                  ),
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStockDataList.length,
              itemBuilder: (context, index) {
                final stockData = filteredStockDataList[index];
                final isInWatchlist = watchlist.contains(stockData);
                return ListTile(
                  title: Text('${stockData.symbol}'),
                  subtitle: Text('Latest Price: ${stockData.latestPrice} INR'),
                  trailing: isInWatchlist
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            watchlistProvider.removeFromWatchlist(stockData);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Removed from Watchlist',
                                ),
                              ),
                            );
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            addToWatchlist(stockData);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Added to Watchlist',
                                ),
                              ),
                            );
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
