import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_app/services/model_class.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({Key? key}) : super(key: key);

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  @override
  Widget build(BuildContext context) {
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final watchlist = watchlistProvider.watchlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchlist"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: watchlist.length,
        itemBuilder: (context, index) {
          final stockData = watchlist[index];
          return ListTile(
            title: Text('${stockData.symbol}'),
            subtitle: Text('Latest Price: ${stockData.latestPrice}'),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                watchlistProvider.removeFromWatchlist(stockData);
              },
            ),
          );
        },
      ),
    );
  }
}

class WatchlistProvider with ChangeNotifier {
  final List<StockData> _watchlist = [];

  List<StockData> get watchlist => _watchlist;

  void addToWatchlist(StockData stock) {
    if (!_watchlist.contains(stock)) {
      _watchlist.add(stock);
      notifyListeners();
    }
  }

  void removeFromWatchlist(StockData stock) {
    _watchlist.remove(stock);
    notifyListeners();
  }
}
