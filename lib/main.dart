import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_cryptocurrency/ui/component.dart';
import 'package:wallet_cryptocurrency/ui/screen/favourite.dart';
import 'package:wallet_cryptocurrency/ui/screen/home.dart';

import 'helpers/fproviders.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => FavouritesBloc(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet Cryptocurrency',
      home: MainApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum TabItem { home, favorite, notification, setting }

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TabItem _currentItem = TabItem.home;
  final List<TabItem> _bottomTabs = [
    TabItem.home,
    TabItem.favorite,
    TabItem.notification,
    TabItem.setting
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: SafeArea(
          child: appBar(
              left: Icon(Icons.notes, color: Colors.black54),
              title: 'My Wallet',
              right: Icon(Icons.account_balance_wallet, color: Colors.black54)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: _buildScreen(),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: _bottomTabs
          .map((tabItem) => _bottomNavigationBarItem(_icon(tabItem), tabItem))
          .toList(),
      onTap: _onSelectTab,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      IconData icon, TabItem tabItem) {
    final Color color =
        _currentItem == tabItem ? Colors.black54 : Colors.black26;

    return BottomNavigationBarItem(icon: Icon(icon, color: color), label: '');
  }

  void _onSelectTab(int index) {
    TabItem selectedTabItem = _bottomTabs[index];

    setState(() {
      _currentItem = selectedTabItem;
    });
  }

  IconData _icon(TabItem item) {
    switch (item) {
      case TabItem.home:
        return Icons.account_balance_wallet;
      case TabItem.favorite:
        return Icons.favorite;
      case TabItem.notification:
        return Icons.notifications;
      case TabItem.setting:
        return Icons.settings;
      default:
        throw 'Unknown $item';
    }
  }

  Widget _buildScreen() {
    switch (_currentItem) {
      case TabItem.home:
        return HomeScreen();
      case TabItem.favorite:
        return Favorite();
      case TabItem.notification:
      // return HomeScreen()
      case TabItem.setting:
      // return HomeScreen()
      default:
        return HomeScreen();
    }
  }
}
