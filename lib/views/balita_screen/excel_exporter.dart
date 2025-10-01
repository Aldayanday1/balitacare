import 'dart:typed_data';

import 'package:aplikasibalita/main.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:excel/excel.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';

// Fungsi untuk mengekspor data ke Excel
Future<String?> exportToExcelWithSAF(List<Balita> balitaList) async {
  var excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];

  // Definisi gaya sel
  // Gaya untuk header kelompok
  CellStyle headerGroupStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Arial),
    fontSize: 10,
    fontColorHex: '#FFFFFF',
    // bold: true,
    backgroundColorHex: "#156082",
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    // borderStyle: BorderStyle.Thick, // Garis tebal
    // borderColor: '#000000', // Hitam
    leftBorder: Border(
        borderStyle: BorderStyle.Thin,
        borderColorHex: '#FFFFFF'), // Warna border kiri putih
    rightBorder: Border(
        borderStyle: BorderStyle.Thin,
        borderColorHex: '#FFFFFF'), // Warna border kanan putih
  );

  // Gaya untuk header utama
  CellStyle headerStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Arial),
    fontSize: 10,
    // bold: true,
    backgroundColorHex: "#C0E6F5",
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    // borderStyle: BorderStyle.Thick, // Garis tebal bawah header
    // borderColor: '#000000',
    bottomBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
    leftBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
    rightBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
    topBorder: Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
  );

  // Gaya untuk isi data
  CellStyle dataStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Calibri),
    fontSize: 10,
    horizontalAlign: HorizontalAlign.Center, // Tengah
    verticalAlign: VerticalAlign.Center,
    // borderStyle: BorderStyle.Thin, // Garis tipis
    // borderColor: '#BFBFBF', // Abu-abu
    bottomBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
    leftBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
    rightBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
  );

  // Menambahkan header kelompok
  sheet.appendRow([
    'Data Balita',
    '',
    '',
    '',
    '',
    '',
    '',
    'Data Perkembangan',
    '',
    '',
    '',
    '',
    ''
  ]);

  // Menggabungkan sel untuk header kelompok
  sheet.merge(CellIndex.indexByString("A1"),
      CellIndex.indexByString("G1")); // Data Balita
  sheet.merge(CellIndex.indexByString("H1"),
      CellIndex.indexByString("M1")); // Data Perkembangan

  // Terapkan gaya untuk header kelompok
  for (int col = 0; col < 13; col++) {
    if (col <= 6) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .cellStyle = headerGroupStyle;
    } else {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .cellStyle = headerGroupStyle;
    }
  }

  // Menambahkan header utama untuk masing-masing kolom
  List<String> headers = [
    'NIK',
    'Nama',
    'Tanggal Lahir',
    'Jenis Kelamin',
    'Nama Orang Tua',
    'Berat Badan Lahir',
    'Tinggi Badan Lahir',
    'Tanggal Ukur',
    'Lingkar Kepala',
    'Cara Ukur',
    'Lingkar Lengan Atas',
    'Berat Badan',
    'Tinggi Badan',
  ];
  sheet.appendRow(headers);

  // Terapkan gaya untuk header utama
  for (int col = 0; col < headers.length; col++) {
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1))
        .cellStyle = headerStyle;
  }

  // Memperlebar kolom (per index 0-seterusnya)
  sheet.setColWidth(10, 20); // Menyesuaikan lebar kolom
  sheet.setColWidth(4, 18);
  sheet.setColWidth(5, 18);
  sheet.setColWidth(6, 18);

  // Menambahkan data balita dan perkembangan
  int currentRow = 2;
  for (var balita in balitaList) {
    for (var perkembangan in balita.perkembangan) {
      // Format tanggal untuk balita.tanggalLahir dan perkembangan.tanggalUkur
      String formattedTanggalLahir =
          DateFormat('dd MMM yyyy').format(balita.tanggalLahir);
      String formattedTanggalUkur =
          DateFormat('dd MMM yyyy').format(perkembangan.tanggalUkur);

      sheet.appendRow([
        balita.nik?.isNotEmpty == true
            ? balita.nik
            : '-', // NIK default jika kosong
        balita.nama,
        formattedTanggalLahir, // Tanggal lahir yang diformat
        balita.jenisKelamin,
        balita.namaOrangTua,
        balita.beratBadanLahir,
        balita.tinggiBadanLahir,
        formattedTanggalUkur, // Tanggal ukur yang diformat
        perkembangan.lingkarKepala,
        perkembangan.caraUkur,
        perkembangan.lingkarLenganAtas,
        perkembangan.beratBadan,
        perkembangan.tinggiBadan,
      ]);

      // Terapkan gaya untuk isi data
      for (int col = 0; col < headers.length; col++) {
        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: col, rowIndex: currentRow))
            .cellStyle = dataStyle;
      }
      currentRow++;
    }
  }

  try {
    // Encode data ke byte array
    List<int>? fileBytesList = excel.encode();

    // Mengubah List<int> menjadi Uint8List
    Uint8List? fileBytes =
        fileBytesList != null ? Uint8List.fromList(fileBytesList) : null;

    // Validasi encoding berhasil
    if (fileBytes == null) {
      print('Gagal encode file Excel.');
      return null;
    }

    // Membuat nama file unik dengan timestamp
    String timestamp = DateFormat('yyyy_MM_dd_HHmmss').format(DateTime.now());
    String fileName = "balita_perkembangan_${timestamp}.xlsx";

    // Menyimpan file menggunakan SAF
    final params = SaveFileDialogParams(
      fileName: fileName,
      data: fileBytes, // Menyediakan byte array untuk file
      localOnly: true, // Pastikan file disimpan di perangkat lokal
    );

    // Meminta pengguna untuk memilih lokasi penyimpanan file
    final filePath = await FlutterFileDialog.saveFile(params: params);

    if (filePath == null) {
      print("Penyimpanan file dibatalkan.");
      return null;
    }

    // Menampilkan notifikasi jika file berhasil disimpan
    await showDownloadSuccessNotification(fileName, filePath);

    return filePath; // Mengembalikan path file yang disimpan
  } catch (e) {
    print('Terjadi kesalahan saat menyimpan file Excel: $e');
    rethrow;
  }
}

Future<void> showDownloadSuccessNotification(
    String fileName, String filePath) async {
  // Ambil hanya nama file dari full filePath, dan pastikan hanya nama file yang diambil
  String fileNameOnly = fileName
      .split('/')
      .last
      .split(':')
      .last; // Ambil nama file saja tanpa folder atau prefix

  // Menampilkan notifikasi dengan nama file yang lebih jelas dan konsisten
  print("Menampilkan notifikasi untuk file: $fileNameOnly");

  final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'download_channel_id',
    'Unduhan Berhasil',
    priority:
        Priority.high, // Prioritas tinggi untuk memastikan heads-up muncul
    ticker: 'Unduhan Selesai',
    icon: 'balitacareplus',
    autoCancel: true, // Otomatis menghapus notifikasi setelah di-click
    vibrationPattern:
        Int64List.fromList([0, 1000, 500, 1000]), // Getaran untuk notifikasi
  );

  final NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  try {
    // Menampilkan nama file yang konsisten
    await flutterLocalNotificationsPlugin.show(
      0,
      'Unduhan Selesai',
      'File "$fileNameOnly" telah berhasil disimpan.',
      notificationDetails,
      payload: filePath, // Kirim path sebagai payload jika perlu
    );
  } catch (e) {
    print("Error menampilkan notifikasi: $e");
  }
}
