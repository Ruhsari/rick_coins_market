// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../ui/cabinet_page.dart';
// import '../ui/home_page.dart';
// import '../ui/info_page.dart';
// import '../ui/market_page.dart';
//
// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     HomePage(),
//     MarketPage(),
//     CabinetPage(),
//     InfoPage(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         type: BottomNavigationBarType.fixed,
//         onTap: (index) => setState(() => _currentIndex = index),
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.store), label: "Market"),
//           BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Cabinet"),
//           BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../ui/cabinet_page.dart';
import '../ui/home_page.dart';
import '../ui/info_page.dart';
import '../ui/market_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MarketPage(),
    const CabinetPage(),
    const InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher( // Добавляем плавную анимацию переключения
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF00E5FF).withOpacity(0.3), // Неоновый голубой акцент
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: Color(0xFF0077B6)), label: "Home"),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.store, color: Color(0xFF0077B6)), label: "Market"),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder, color: Color(0xFF0077B6)), label: "Cabinet"),
          NavigationDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info, color: Color(0xFF0077B6)), label: "Info"),
        ],
      ),
    );
  }
}