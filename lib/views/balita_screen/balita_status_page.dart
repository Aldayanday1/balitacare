import 'package:aplikasibalita/controllers/balita_controller.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:flutter/material.dart';

class BalitaStatusPage extends StatelessWidget {
  final String status; // Status balita (Sehat, Gizi Kurang, dll.)
  final BalitaController _balitaController = BalitaController();

  BalitaStatusPage({required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balita Status: $status'),
      ),
      body: FutureBuilder<List<Balita>>(
        future: _balitaController.getBalitaByStatus(status),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final balitas = snapshot.data!;
            return ListView.builder(
              itemCount: balitas.length,
              itemBuilder: (context, index) {
                final balita = balitas[index];
                return ListTile(
                  title: Text(balita.nama),
                  // subtitle: Text('NIK: ${balita.nik}'),
                );
              },
            );
          } else {
            return Center(child: Text('Tidak ada data'));
          }
        },
      ),
    );
  }
}
