import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_app/pages/bottomnavbar.dart';
import 'package:stocks_app/pages/watchlist.dart';
import 'package:stocks_app/services/sqlite.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => WatchlistProvider()),
    Provider(create: (_) => DatabaseHelper()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const NavBar(),
    );
  }
}
