import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utilities/Styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Metrics(),
    Feed(),
    Challenges(),
    Profile()
  ];

  /*
    Should probably have each screen be a subclass of some extension of StatefulWidget that has a title
    field instead of having this separate list and separate variables in each class
  */
  static const List<String> _widgetOptionTitles = <String>[
    "Home",
    "Metrics",
    "Feed",
    "Challenges",
    "Profile"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        backgroundColor: trifitColor[900],
        title: Text(_widgetOptionTitles.elementAt(_selectedIndex)),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 32),
            activeIcon: Icon(Icons.home, size: 32),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart, size: 32),
            label: 'Metrics',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.at, size: 32),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined, size: 32),
            activeIcon: Icon(Icons.star, size: 32),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 32),
            activeIcon: Icon(Icons.person, size: 32),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: trifitColor[900],
        onTap: _onItemTapped,
      ),
    );
  }
}
