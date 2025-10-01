import 'package:aplikasibalita/models/perkembangan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PerkembanganCard extends StatelessWidget {
  final Perkembangan perkembangan;
  final Function onEdit;
  final Function onDelete;

  const PerkembanganCard({
    Key? key,
    required this.perkembangan,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:
          Key(perkembangan.id.toString()), // Pastikan ID unik untuk setiap card
      direction:
          DismissDirection.horizontal, // Mengizinkan gesekan ke kiri dan kanan
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onEdit(); // Gesekan ke kanan untuk edit
        } else if (direction == DismissDirection.endToStart) {
          onDelete(); // Gesekan ke kiri untuk delete
        }
      },
      background: Container(
        color: Colors.green, // Warna untuk aksi gesekan ke kanan (Edit)
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.edit, color: Colors.white), // Ikon Edit
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red, // Warna untuk aksi gesekan ke kiri (Delete)
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.delete, color: Colors.white), // Ikon Delete
          ),
        ),
      ),
      child: Card(
        color: Colors.white, // Pastikan warna Card tetap putih
        elevation: 8, // Efek bayangan
        shadowColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Container(
          color: Colors
              .white, // Tambahkan untuk memastikan warna latar belakang tetap putih
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Tanggal Ukur
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        '${DateFormat('dd MMMM yyyy', 'id_ID').format(perkembangan.tanggalUkur)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 51, 109, 53),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    Divider(color: Colors.grey[300]),

                    // Detail Data Perkembangan
                    Text(
                      'Lingkar Kepala: ${perkembangan.lingkarKepala.toStringAsFixed(0)} cm',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Lingkar Lengan Atas: ${perkembangan.lingkarLenganAtas.toStringAsFixed(0)} cm',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Berat Badan: ${perkembangan.beratBadan.toStringAsFixed(0)} kg',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Tinggi Badan: ${perkembangan.tinggiBadan.toStringAsFixed(0)} cm',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Cara Ukur: ${perkembangan.caraUkur}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
