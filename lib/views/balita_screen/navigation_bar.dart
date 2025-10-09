import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.add, size: 30, color: Colors.white), // Tombol '+' di tengah
        Icon(Icons.download, size: 30, color: Colors.white),
      ],
      index: selectedIndex,
      height: 60,
      color: Color.fromARGB(255, 132, 158, 165), // Warna latar belakang navbar
      buttonBackgroundColor:
          Color.fromARGB(255, 153, 184, 192), // Warna latar belakang tombol '+'
      backgroundColor: Colors.white, // Warna latar belakang navbar
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 300),
      onTap: onItemTapped,
    );
  }
}
