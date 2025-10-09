import 'package:aplikasibalita/views/balita_screen/add_balita_pages/add_balita_screen.dart';
import 'package:aplikasibalita/views/balita_screen/all_balita_screen.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/home_screen.dart';
import 'package:aplikasibalita/views/balita_screen/navigation_bar.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({Key? key, this.initialIndex = 0})
      : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedIndex;
  late PageController _pageController;

  // List halaman yang akan ditampilkan
  final List<Widget> _screens = [
    HomeScreen(),
    AddBalitaScreen(),
    AllBalitaScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavBarTapped,
      ),
    );
  }
}
