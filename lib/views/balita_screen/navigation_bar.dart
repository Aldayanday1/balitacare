import 'package:aplikasibalita/views/balita_screen/add_balita_pages/add_balita_screen.dart';
import 'package:aplikasibalita/views/balita_screen/all_balita_screen.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int selectedIndex;

  const CustomBottomNavigation({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AddBalitaScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllBalitaScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.add, size: 30, color: Colors.white), // Tombol '+' di tengah
        Icon(Icons.download, size: 30, color: Colors.white),
      ],
      index: widget.selectedIndex,
      height: 60,
      color: Color.fromARGB(255, 132, 158, 165), // Warna latar belakang navbar
      buttonBackgroundColor:
          Color.fromARGB(255, 153, 184, 192), // Warna latar belakang tombol '+'
      backgroundColor: Colors.white, // Warna latar belakang navbar
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 300),
      onTap: (index) => _onItemTapped(index),
    );
  }
}
