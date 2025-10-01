import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  double _opacityLogo = 0.0;
  double _opacityText = 0.0;

  @override
  void initState() {
    super.initState();

    // Animasi logo dan teks
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _opacityLogo = 1.0;
      });
    });

    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _opacityText = 1.0;
      });
    });

    // Animasi untuk menghilangkan logo dan teks setelah beberapa detik
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _opacityLogo = 0.0;
        _opacityText = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Splash screen content
          AnimatedSplashScreen(
            duration: 1500, // Durasi splash screen
            splash: Center(
              child: OverflowBox(
                maxWidth:
                    MediaQuery.of(context).size.width * 0.38, // Ukuran gambar
                maxHeight: MediaQuery.of(context).size.height * 0.38,
                child: Image.asset(
                  'assets/photos/app_icon_splash.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            nextScreen: HomeScreen(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white,
          ),

          // Animasi teks
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: AnimatedOpacity(
                opacity: _opacityText,
                duration: Duration(milliseconds: 1000),
                child: Text(
                  '© 2025 Aldi TI UMY 21 & Team. All rights reserved.',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.031,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
