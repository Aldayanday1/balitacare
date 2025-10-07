import 'dart:typed_data';

import 'package:aplikasibalita/main.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:excel/excel.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Fungsi untuk mengekspor data ke Excel (Compatible dengan Excel v4.0+)
Future<String?> exportToExcelWithSAF(List<Balita> balitaList) async {
  var excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];

  // Definisi warna untuk Excel v4 (ExcelColor)
  ExcelColor whiteColor = ExcelColor.fromHexString('#FFFFFF');
  ExcelColor blackColor = ExcelColor.fromHexString('#000000');
  ExcelColor headerBgColor = ExcelColor.fromHexString('#156082');
  ExcelColor subHeaderBgColor = ExcelColor.fromHexString('#C0E6F5');

  // Gaya untuk header kelompok
  CellStyle headerGroupStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Arial),
    fontSize: 10,
    fontColorHex: whiteColor,
    backgroundColorHex: headerBgColor,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    leftBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: whiteColor),
    rightBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: whiteColor),
  );

  // Gaya untuk header utama
  CellStyle headerStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Arial),
    fontSize: 10,
    backgroundColorHex: subHeaderBgColor,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    bottomBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: blackColor),
    leftBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: blackColor),
    rightBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: blackColor),
    topBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: blackColor),
  );

  // Gaya untuk isi data
  CellStyle dataStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Calibri),
    fontSize: 10,
    horizontalAlign: HorizontalAlign.Center,
    verticalAlign: VerticalAlign.Center,
    bottomBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: blackColor),
    leftBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: blackColor),
    rightBorder:
        Border(borderStyle: BorderStyle.Thin, borderColorHex: blackColor),
  );

  // Menambahkan header kelompok dengan CellValue.value (Excel v4)
  sheet.appendRow([
    TextCellValue('Data Balita'),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue('Data Perkembangan'),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue(''),
    TextCellValue('')
  ]);

  // Menggabungkan sel untuk header kelompok
  sheet.merge(CellIndex.indexByString("A1"),
      CellIndex.indexByString("G1")); // Data Balita
  sheet.merge(CellIndex.indexByString("H1"),
      CellIndex.indexByString("M1")); // Data Perkembangan

  // Terapkan gaya untuk header kelompok
  for (int col = 0; col < 13; col++) {
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
        .cellStyle = headerGroupStyle;
  }

  // Menambahkan header utama untuk masing-masing kolom
  List<CellValue> headers = [
    TextCellValue('NIK'),
    TextCellValue('Nama'),
    TextCellValue('Tanggal Lahir'),
    TextCellValue('Jenis Kelamin'),
    TextCellValue('Nama Orang Tua'),
    TextCellValue('Berat Badan Lahir'),
    TextCellValue('Tinggi Badan Lahir'),
    TextCellValue('Tanggal Ukur'),
    TextCellValue('Lingkar Kepala'),
    TextCellValue('Cara Ukur'),
    TextCellValue('Lingkar Lengan Atas'),
    TextCellValue('Berat Badan'),
    TextCellValue('Tinggi Badan'),
  ];
  sheet.appendRow(headers);

  // Terapkan gaya untuk header utama
  for (int col = 0; col < headers.length; col++) {
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1))
        .cellStyle = headerStyle;
  }

  // Memperlebar kolom (v3.0+ menggunakan setColumnWidth)
  sheet.setColumnWidth(10, 20); // Menyesuaikan lebar kolom
  sheet.setColumnWidth(4, 18);
  sheet.setColumnWidth(5, 18);
  sheet.setColumnWidth(6, 18);

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
        TextCellValue(balita.nik?.isNotEmpty == true ? balita.nik! : '-'),
        TextCellValue(balita.nama),
        TextCellValue(formattedTanggalLahir),
        TextCellValue(balita.jenisKelamin),
        TextCellValue(balita.namaOrangTua),
        DoubleCellValue(balita.beratBadanLahir),
        DoubleCellValue(balita.tinggiBadanLahir),
        TextCellValue(formattedTanggalUkur),
        DoubleCellValue(perkembangan.lingkarKepala),
        TextCellValue(perkembangan.caraUkur),
        DoubleCellValue(perkembangan.lingkarLenganAtas),
        DoubleCellValue(perkembangan.beratBadan),
        DoubleCellValue(perkembangan.tinggiBadan),
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
      data: fileBytes,
      localOnly: true,
    );

    // Meminta pengguna untuk memilih lokasi penyimpanan file
    final filePath = await FlutterFileDialog.saveFile(params: params);

    if (filePath == null) {
      print("Penyimpanan file dibatalkan.");
      return null;
    }

    // Menampilkan notifikasi jika file berhasil disimpan
    await showDownloadSuccessNotification(fileName, filePath);

    return filePath;
  } catch (e) {
    print('Terjadi kesalahan saat menyimpan file Excel: $e');
    rethrow;
  }
}

Future<void> showDownloadSuccessNotification(
    String fileName, String filePath) async {
  String fileNameOnly = fileName.split('/').last.split(':').last;

  print("Menampilkan notifikasi untuk file: $fileNameOnly");

  final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'download_channel_id',
    'Unduhan Berhasil',
    priority: Priority.high,
    ticker: 'Unduhan Selesai',
    icon: 'balitacareplus',
    autoCancel: true,
    vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
  );

  final NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  try {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Unduhan Selesai',
      'File "$fileNameOnly" telah berhasil disimpan.',
      notificationDetails,
      payload: filePath,
    );
  } catch (e) {
    print("Error menampilkan notifikasi: $e");
  }
}
