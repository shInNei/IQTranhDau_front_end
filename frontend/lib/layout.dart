import 'package:flutter/material.dart';

import 'home.dart';
import 'notification.dart';
import 'gift.dart';
import 'profile.dart';
import 'navbar.dart';


class MainPageLayout extends StatefulWidget {
  const MainPageLayout({super.key});

  @override
  State<MainPageLayout> createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  int _currentIndex = 0;
  bool _resetHome = false;

  void _onResetComplete() {
    setState(() {
      _resetHome = false; // reset the flag after handled
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      if(index == 0 && _currentIndex == 0) {
        _resetHome = true;
      }
      _currentIndex = index;
    });
  }

List<Widget> get screens => [
  HomeScreen(resetToMain: _resetHome, onResetComplete: _onResetComplete),
  const NotificationScreen(),
  const GiftScreen(),
  const ProfileScreen(),
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
