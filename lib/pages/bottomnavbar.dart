import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocks_app/pages/homepage.dart';
import 'package:stocks_app/pages/watchlist.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: Colors.black,
      tabBar: CupertinoTabBar(
        height: 60,
        items: const [
          BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(
              label: 'Watchlist',
              icon: Icon(Icons.bookmark_add_outlined),
              activeIcon: Icon(Icons.bookmark_add)),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) => const HomePage());

          case 1:
          default:
            return CupertinoTabView(builder: (context) => const Watchlist());
        }
      },
    );
  }
}
