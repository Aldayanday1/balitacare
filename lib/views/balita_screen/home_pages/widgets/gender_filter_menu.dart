import 'package:flutter/material.dart';

class GenderFilterMenu extends StatelessWidget {
  final Function(String) onSelected; // Callback saat menu dipilih
  final double filterScale; // Skala animasi
  final Duration animationDuration; // Durasi animasi

  const GenderFilterMenu({
    Key? key,
    required this.onSelected,
    required this.filterScale,
    required this.animationDuration,
    // this.animationDuration = const Duration(milliseconds: 150),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'Semua',
          child: Row(
            children: [
              Icon(Icons.all_inclusive, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Semua',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Laki-laki',
          child: Row(
            children: [
              Icon(Icons.male, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Laki-laki',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Perempuan',
          child: Row(
            children: [
              Icon(Icons.female, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Perempuan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
      offset: Offset(-48.5, -2.6), // Geser sedikit ke kanan
      child: AnimatedScale(
        scale: filterScale, // Skala animasi
        duration: animationDuration, // Durasi animasi
        curve: Curves.easeInOut, // Kurva animasi
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 132, 158, 165),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.tune, // Ikon dropdown
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
