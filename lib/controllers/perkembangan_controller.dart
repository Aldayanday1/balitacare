import 'package:aplikasibalita/database/database_helper.dart';
import 'package:aplikasibalita/models/perkembangan.dart';

class PerkembanganController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Add Perkembangan 
  Future<void> addPerkembangan(Perkembangan perkembangan) async {
    await _dbHelper.insertPerkembangan(perkembangan);
  }

  // Get Perkembangan by Balita ID 
  Future<List<Perkembangan>> getPerkembanganByBalitaId(int balitaId) async {
    return await _dbHelper.getPerkembanganByBalitaId(balitaId);
  }

  // Update Perkembangan
  Future<void> updatePerkembangan(Perkembangan perkembangan) async {
    await _dbHelper.updatePerkembangan(perkembangan);
  }

  // Delete Perkembangan
  Future<void> deletePerkembangan(int id) async {
    await _dbHelper.deletePerkembangan(id);
  }

  // Menentukan status berdasarkan pengukuran
  String determineStatus(
      String jenisKelamin, double beratBadan, double tinggiBadan) {
    if (jenisKelamin == "Laki-laki") {
      if (beratBadan < 7.5 || tinggiBadan < 71) {
        return "Stunting/Gizi Buruk"; // Red
      } else if ((beratBadan >= 7.5 && beratBadan < 9.0) ||
          (tinggiBadan >= 71 && tinggiBadan < 75)) {
        return "Gizi Kurang"; // Yellow
      } else {
        return "Sehat"; // Green
      }
    } else if (jenisKelamin == "Perempuan") {
      if (beratBadan < 7.0 || tinggiBadan < 69) {
        return "Stunting/Gizi Buruk"; // Red
      } else if ((beratBadan >= 7.0 && beratBadan < 8.5) ||
          (tinggiBadan >= 69 && tinggiBadan < 73)) {
        return "Gizi Kurang"; // Yellow
      } else {
        return "Sehat"; // Green
      }
    } else {
      return "Jenis Kelamin tidak valid";
    }
  }
}
