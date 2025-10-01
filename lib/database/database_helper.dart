// lib/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/balita.dart';
import '../models/perkembangan.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'balita.db');
    return await openDatabase(
      path,
      version: 1, // Tentukan versi database di sini
      onCreate: _createDB,
      // onUpgrade: _upgradeDB, // Tambahkan onUpgrade
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE balita(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nik TEXT,
        nama TEXT,
        tanggalLahir TEXT,
        jenisKelamin TEXT,
        namaOrangTua TEXT,
        beratBadanLahir REAL,
        tinggiBadanLahir REAL,
        createdAt TEXT,  -- Kolom createdAt
        updatedAt TEXT  -- Kolom updatedAt
      )
    ''');

    await db.execute('''
      CREATE TABLE perkembangan(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        balitaId INTEGER,
        tanggalUkur TEXT,
        lingkarKepala REAL,
        caraUkur TEXT,
        lingkarLenganAtas REAL,
        beratBadan REAL,
        tinggiBadan REAL,
        createdAt TEXT,  -- Kolom createdAt
        updatedAt TEXT,  -- Kolom updatedAt
        FOREIGN KEY (balitaId) REFERENCES balita(id) ON DELETE CASCADE
      )
    ''');
  }

  // // Meng-upgrade skema database saat versi database berubah
  // Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 3) {
  //     // Menambahkan kolom createdAt ke tabel balita jika upgrade dari versi 1 ke 2
  //     await db.execute('''
  //       ALTER TABLE balita ADD COLUMN createdAt TEXT;
  //     ''');

  //     // Menambahkan kolom createdAt dan updatedAt ke tabel perkembangan
  //     await db.execute('''
  //       ALTER TABLE perkembangan ADD COLUMN createdAt TEXT;
  //     ''');

  //     await db.execute('''
  //       ALTER TABLE perkembangan ADD COLUMN updatedAt TEXT;
  //     ''');
  //   }
  // }

  // CRUD for Balita

  Future<int> insertBalita(Balita balita) async {
    final db = await database;
    final Map<String, dynamic> data = balita.toMap();
    data['createdAt'] = DateTime.now().toIso8601String(); // Set createdAt
    data['updatedAt'] = DateTime.now().toIso8601String(); // Set createdAt
    return await db.insert('balita', data); // Gunakan data yang sudah diubah
  }

  Future<List<Balita>> getAllBalita() async {
    final db = await database;
    print(
        "Executing query to get all Balita sorted by createdAt and updatedAt");

    final List<Map<String, dynamic>> maps = await db.query(
      'balita',
      orderBy:
          'updatedAt DESC, createdAt DESC', // Urutkan berdasarkan updatedAt, lalu createdAt
    );

    print("Query result: $maps"); // Debug: print the result of the query

    return List.generate(maps.length, (i) {
      return Balita.fromMap(maps[i]);
    });
  }

  Future<Balita?> getBalitaById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'balita',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Balita.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBalita(Balita balita) async {
    final db = await database;

    // Ambil data yang ada sebelumnya untuk mempertahankan createdAt
    final existingBalita = await db.query(
      'balita',
      where: 'id = ?',
      whereArgs: [balita.id],
    );

    if (existingBalita.isNotEmpty) {
      // Pertahankan nilai createdAt dari data yang ada
      final createdAt = existingBalita.first['createdAt'];

      final Map<String, dynamic> data = balita.toMap();
      data['createdAt'] = createdAt; // Pertahankan createdAt
      data['updatedAt'] =
          DateTime.now().toIso8601String(); // Set updatedAt ke waktu sekarang

      return await db.update(
        'balita',
        data,
        where: 'id = ?',
        whereArgs: [balita.id],
      );
    } else {
      throw Exception('Balita tidak ditemukan');
    }
  }

  Future<int> deleteBalita(int id) async {
    final db = await database;
    return await db.delete(
      'balita',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Balita>> getBalitaByGender(String gender) async {
    final db = await database; // Koneksi ke database
    final List<Map<String, dynamic>> maps = await db.query(
      'balita',
      where: 'jenisKelamin = ?', // Query berdasarkan jenis kelamin
      whereArgs: [gender],
    );

    // Konversi hasil query menjadi daftar objek Balita
    return List.generate(maps.length, (i) {
      return Balita.fromMap(maps[i]);
    });
  }

  // fungsi untuk mendapatkan data balita yang telah difilter berdasarkan tanggalUkur perkembangan.
  Future<List<Balita>> getFilteredBalitaWithPerkembangan(
      DateTime selectedMonth) async {
    final db = await database;

    // Query Balita, urutkan berdasarkan createdAt DESC
    final List<Map<String, dynamic>> balitaRows = await db.query(
      'Balita',
    );

    // Hasilkan daftar balita dengan perkembangan
    final List<Balita> balitaList = [];
    for (var row in balitaRows) {
      final balita = Balita(
        id: row['id'] as int?,
        nik: row['nik'] as String?,
        nama: row['nama'] as String,
        tanggalLahir: DateTime.parse(row['tanggalLahir'] as String),
        jenisKelamin: row['jenisKelamin'] as String,
        namaOrangTua: row['namaOrangTua'] as String,
        beratBadanLahir: row['beratBadanLahir'] as double,
        tinggiBadanLahir: row['tinggiBadanLahir'] as double,
        perkembangan: [],
      );

      // Query perkembangan berdasarkan tanggal ukur, urutkan berdasarkan createdAt DESC
      final perkembanganRows = await db.query(
        'Perkembangan',
        where: 'balitaId = ? AND strftime(\'%Y-%m\', tanggalUkur) = ?',
        whereArgs: [
          row['id'],
          '${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}'
        ],
        orderBy: 'tanggalUkur DESC', // Urutkan berdasarkan updatedAt DESC
      );

      for (var perkembanganRow in perkembanganRows) {
        final perkembangan = Perkembangan(
          balitaId: row['id'] as int,
          tanggalUkur: DateTime.parse(perkembanganRow['tanggalUkur'] as String),
          lingkarKepala: perkembanganRow['lingkarKepala'] as double,
          caraUkur: perkembanganRow['caraUkur'] as String,
          lingkarLenganAtas: perkembanganRow['lingkarLenganAtas'] as double,
          beratBadan: perkembanganRow['beratBadan'] as double,
          tinggiBadan: perkembanganRow['tinggiBadan'] as double,
        );

        balita.perkembangan.add(perkembangan);
      }

      if (balita.perkembangan.isNotEmpty) {
        balitaList.add(balita);
      }
    }

    return balitaList;
  }

  // CRUD for Perkembangan

  // Insert Perkembangan (sudah ada)
  Future<int> insertPerkembangan(Perkembangan perkembangan) async {
    final db = await database;
    final Map<String, dynamic> data = perkembangan.toMap();
    data['createdAt'] = DateTime.now().toIso8601String(); // Set createdAt
    data['updatedAt'] = DateTime.now().toIso8601String(); // Set updatedAt
    return await db.insert('perkembangan', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get Perkembangan by Balita ID (sudah ada)
  Future<List<Perkembangan>> getPerkembanganByBalitaId(int balitaId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'perkembangan',
      where: 'balitaId = ?',
      whereArgs: [balitaId],
      orderBy:
          'tanggalUkur DESC', // Urutkan berdasarkan updatedAt, lalu createdAt
    );
    return List.generate(maps.length, (i) {
      return Perkembangan.fromMap(maps[i]);
    });
  }

  // Update Perkembangan
  Future<int> updatePerkembangan(Perkembangan perkembangan) async {
    final db = await database;

    // Ambil data yang ada sebelumnya untuk mempertahankan createdAt
    final existingPerkembangan = await db.query(
      'perkembangan',
      where: 'id = ?',
      whereArgs: [perkembangan.id],
    );

    if (existingPerkembangan.isNotEmpty) {
      // Pertahankan nilai createdAt dari data yang ada
      final createdAt = existingPerkembangan.first['createdAt'];

      final Map<String, dynamic> data = perkembangan.toMap();
      data['createdAt'] = createdAt; // Pertahankan createdAt
      data['updatedAt'] =
          DateTime.now().toIso8601String(); // Set updatedAt ke waktu sekarang

      return await db.update(
        'perkembangan',
        data,
        where: 'id = ?',
        whereArgs: [perkembangan.id],
      );
    } else {
      throw Exception('Perkembangan tidak ditemukan');
    }
  }

  // Delete Perkembangan
  Future<int> deletePerkembangan(int id) async {
    final db = await database;
    return await db.delete(
      'perkembangan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fungsi untuk mencari balita berdasarkan nama atau NIK
  Future<List<Balita>> searchBalita(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'balita',
      where: 'nama LIKE ? OR nik LIKE ?', // Menggunakan LIKE untuk pencarian
      whereArgs: [
        '%$query%',
        '%$query%'
      ], // Mencari kata kunci dalam nama atau NIK
    );

    return List.generate(maps.length, (i) {
      return Balita.fromMap(maps[i]);
    });
  }

  // Fungsi untuk Menghitung Data Balita per Bulan
  // Future<Map<String, int>> getBalitaPerMonth() async {
  //   final db = await database;

  //   // Query untuk mengambil jumlah balita berdasarkan bulan
  //   final List<Map<String, dynamic>> result = await db.rawQuery('''
  //   SELECT strftime('%Y-%m', createdAt) AS bulan, COUNT(id) AS jumlah
  //   FROM balita
  //   GROUP BY strftime('%Y-%m', createdAt)
  //   ORDER BY bulan ASC
  // ''');

  //   // Mengubah hasil query menjadi Map dengan key adalah bulan dan value adalah jumlah
  //   Map<String, int> dataPerBulan = {};
  //   for (var row in result) {
  //     dataPerBulan[row['bulan']] = row['jumlah'];
  //   }

  //   return dataPerBulan;
  // }
}
