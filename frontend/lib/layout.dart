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
  bool _resetProfile = false;

  void _onResetHomeComplete() {
    setState(() {
      _resetHome = false; // reset the flag after handled
    });
  }

  void _onResetProfileComplete() {
    setState(() {
      _resetProfile = false; // reset the flag after handled
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      if(index == 0 && _currentIndex == 0) {
        _resetHome = true;
      }
      if(index == 3 && _currentIndex == 3) {
        _resetProfile = true;
      }

      _currentIndex = index;
    });
  }

List<Widget> get screens => [
  HomeScreen(resetToMain: _resetHome, onResetComplete: _onResetHomeComplete),
  const NotificationScreen(),
  const GiftScreen(),
  ProfileScreen(resetToMain: _resetProfile, onResetComplete: _onResetProfileComplete),
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
