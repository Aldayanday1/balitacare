import 'package:aplikasibalita/controllers/perkembangan_controller.dart';
import 'package:aplikasibalita/database/database_helper.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:aplikasibalita/models/perkembangan.dart';

class BalitaController {
  final PerkembanganController _perkembanganController =
      PerkembanganController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> addBalita(Balita balita) async {
    return await _dbHelper
        .insertBalita(balita); // Mengembalikan ID yang baru dimasukkan
  }

  Future<List<Balita>> getAllBalita() async {
    return await _dbHelper.getAllBalita();
  }

  Future<Balita?> getBalitaById(int id) async {
    return await _dbHelper.getBalitaById(id);
  }

  Future<void> updateBalita(Balita balita) async {
    await _dbHelper.updateBalita(balita);
  }

  Future<void> deleteBalita(int id) async {
    await _dbHelper.deleteBalita(id);
  }

  Future<List<Balita>> getBalitaByGender(String gender) async {
    return await _dbHelper.getBalitaByGender(gender);
  }

  Future<List<Balita>> getFilteredBalitaWithPerkembangan(
      DateTime selectedMonth) async {
    return await _dbHelper.getFilteredBalitaWithPerkembangan(selectedMonth);
  }

// Fungsi untuk menghitung jumlah data balita berdasarkan status mereka (status card)
  Future<Map<String, int>> getStatusCounts() async {
    List<Balita> allBalita = await getAllBalita();
    Map<String, int> statusCounts = {
      "Sehat": 0,
      "Gizi Kurang": 0,
      "Stunting/Gizi Buruk": 0,
    };

    for (var balita in allBalita) {
      // Ambil perkembangan balita yang relevan
      List<Perkembangan> perkembanganList =
          await _perkembanganController.getPerkembanganByBalitaId(balita.id!);

      // Tentukan status berdasarkan perkembangan terakhir
      if (perkembanganList.isNotEmpty) {
        Perkembangan lastPerkembangan = perkembanganList.last;

        // Panggil determineStatus dari PerkembanganController
        String status = _perkembanganController.determineStatus(
            balita.jenisKelamin,
            lastPerkembangan.beratBadan,
            lastPerkembangan.tinggiBadan);

        // Tambahkan jumlah berdasarkan status
        if (statusCounts.containsKey(status)) {
          statusCounts[status] = (statusCounts[status]! + 1);
        }
      }
    }

    return statusCounts;
  }

// Fungsi untuk mengambil balita berdasarkan status (detail halaman balita dari card status)
  Future<List<Balita>> getBalitaByStatus(String status) async {
    // Ambil semua data balita
    final allBalita = await getAllBalita();

    List<Balita> filteredBalita = [];

    // Gunakan for-loop untuk memungkinkan penggunaan await
    for (var balita in allBalita) {
      final perkembangan =
          await _dbHelper.getPerkembanganByBalitaId(balita.id!);

      if (perkembangan.isNotEmpty) {
        final latestPerkembangan = perkembangan.last;
        String balitaStatus = _perkembanganController.determineStatus(
          balita.jenisKelamin,
          latestPerkembangan.beratBadan,
          latestPerkembangan.tinggiBadan,
        );

        if (balitaStatus == status) {
          filteredBalita.add(balita);
        }
      }
    }

    return filteredBalita;
  }

  // Fungsi pencarian berdasarkan nama atau NIK
  Future<List<Balita>> searchBalita(String query) async {
    return await _dbHelper.searchBalita(query);
  }

  // Fungsi untuk mendapatkan jumlah data balita 6 bulan terakhir
  Future<Map<String, int>> getBalitaCountLast6Months() async {
    final db = await _dbHelper.database;
    DateTime now = DateTime.now();

    // Dapatkan nama bulan dengan format singkatan
    List<String> monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    // Siapkan map untuk 6 bulan terakhir, inisialisasi dengan nilai nol
    Map<String, int> balitaCountLast6Months = {};
    for (int i = 5; i >= 0; i--) {
      DateTime date = DateTime(now.year, now.month - i, 1);
      String monthName = monthNames[date.month - 1];
      balitaCountLast6Months[monthName] = 0;
    }

    // Query untuk mendapatkan data balita dalam 6 bulan terakhir
    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT COUNT(id) as count, strftime('%m', createdAt) as month
    FROM balita
    WHERE createdAt >= ?
    GROUP BY strftime('%m', createdAt)
    ORDER BY month DESC
  ''', [now.subtract(Duration(days: 180)).toIso8601String()]);

    // Update map dengan data dari hasil query
    results.forEach((row) {
      int monthIndex = int.parse(row['month']) - 1;
      String monthName = monthNames[monthIndex];
      balitaCountLast6Months[monthName] = row['count'] ?? 0;
    });

    return balitaCountLast6Months;
  }
}
