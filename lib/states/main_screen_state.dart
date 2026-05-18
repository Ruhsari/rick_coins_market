import 'package:flutter/material.dart';
import 'package:rick_coins_market_ruhsari/ui/cabinet_page.dart';
import 'package:rick_coins_market_ruhsari/ui/home_page.dart';
import 'package:rick_coins_market_ruhsari/ui/info_page.dart';
import 'package:rick_coins_market_ruhsari/ui/market_page.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _visual_pages = [
    HomePage(),
    MarketPage(),
    CabinetPage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _visual_pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Market"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Cabinet"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
        ],
      ),
    );
  }
}
