import 'package:flutter/material.dart';
import 'package:prideconnect/screen/cartscreen.dart';
import 'package:prideconnect/screen/chatbot.dart';
import 'package:prideconnect/screen/events.dart';
import '../utils/contstants.dart';
import '../screen/allworkshop.dart';
import '../screen/courses.dart';
import '../screen/explorescreen.dart';
import '../screen/homescreen.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  // List of pages to display
  final List<Widget> _pages = [
    HomeScreen(), // Home screen as the default page
    Events(),
    ChatBot(),
    AllWorkshopPage(),
    ExplorePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the selected page
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Constants.PrideAPPCOLOUR, // Background color
        selectedItemColor: Colors.tealAccent.withOpacity(0.9), // Selected icon color
        unselectedItemColor: Colors.grey, // Unselected icon color
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cell_tower),
            label: 'Lumi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Career Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Explore',
          ),
        ],
      ),
    );
  }
}