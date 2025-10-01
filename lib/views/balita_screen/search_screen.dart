import 'package:flutter/material.dart';

class MyAppp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // Container pertama di bagian atas, full separuh layar, warna merah
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.5,
              child: Container(
                color: Color.fromARGB(255, 255, 166, 159),
              ),
            ),
            // Container kedua di bagian bawah, full separuh layar, warna biru
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            // Container ketiga di tengah dengan card dan shadow estetik
            Align(
              alignment: Alignment.center,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: Colors.black54,
                child: Container(
                  width: 350,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // child: Center(
                  //   child: Text(
                  //     'Card Tengah',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black87,
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
