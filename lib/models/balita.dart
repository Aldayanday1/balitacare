import 'package:aplikasibalita/models/perkembangan.dart';

class Balita {
  final int? id;
  final String? nik; // Boleh null
  final String nama;
  final DateTime tanggalLahir;
  final String jenisKelamin;
  final String namaOrangTua;
  final double beratBadanLahir;
  final double tinggiBadanLahir;
  final DateTime? createdAt; // Tambahkan createdAt
  final DateTime? updatedAt; // Tambahkan updatedAt
  final List<Perkembangan> perkembangan; 

  Balita({
    this.id,
    this.nik, // Dapat null
    required this.nama,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.namaOrangTua,
    required this.beratBadanLahir,
    required this.tinggiBadanLahir,
    this.createdAt, // Tambahkan createdAt
    this.updatedAt, // Tambahkan updatedAt
    this.perkembangan = const [], // Default kosong
  });

  // Mapping data ke database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nik': nik,
      'nama': nama,
      'tanggalLahir': tanggalLahir.toIso8601String(),
      'jenisKelamin': jenisKelamin,
      'namaOrangTua': namaOrangTua,
      'beratBadanLahir': beratBadanLahir,
      'tinggiBadanLahir': tinggiBadanLahir,
      'createdAt': createdAt?.toIso8601String(), // Tambahkan createdAt
      'updatedAt': updatedAt?.toIso8601String(), // Tambahkan updatedAt
    };
  }

  // Mapping data dari database
  factory Balita.fromMap(Map<String, dynamic> map) {
    return Balita(
      id: map['id'],
      nik: map['nik'],
      nama: map['nama'],
      tanggalLahir: DateTime.parse(map['tanggalLahir']),
      jenisKelamin: map['jenisKelamin'],
      namaOrangTua: map['namaOrangTua'],
      beratBadanLahir: map['beratBadanLahir'],
      tinggiBadanLahir: map['tinggiBadanLahir'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null, // Handle null
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null, // Handle null
    );
  }
}
