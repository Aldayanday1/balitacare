import 'package:aplikasibalita/views/balita_screen/home_pages/home_screen.dart';
import 'package:aplikasibalita/views/splash_pages/splash_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';

// Inisialisasi plugin notifikasi lokal untuk aplikasi
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Fungsi untuk mengatur pengaturan  dan inisialisasi notifikasi lokal
void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

// Fungsi untuk membuka file yang dipilih
  Future<void> openFile(String path) async {
    try {
      final result = await OpenFile.open(path);
      if (result.type != ResultType.done) {
        print("Gagal membuka file: ${result.message}");
      }
    } catch (e) {
      print("Error membuka file: $e");
    }
  }

// Fungsi untuk memilih dan membuka file menggunakan SAF (file_picker & open_file)
  Future<void> pickAndOpenFile(String initialPath) async {
    // Memilih file menggunakan SAF
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      initialDirectory:
          initialPath, // Menampilkan direktori awal (dari file path yang diterima)
      allowMultiple: false, // Hanya memilih satu file
    );

    if (result != null) {
      String filePath = result.files.single.path ?? '';

      // example : /data/user/0/com.example.aplikasibalita/cache/file_picker/balita_perkembangan_2024_12_07_103557.xlsx
      print("File yang dipilih: $filePath");

      // Buka file yang dipilih
      await openFile(filePath);
    } else {
      print("Tidak ada file yang dipilih");
    }
  }

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null && response.payload!.isNotEmpty) {
        print("Path file yang diterima: ${response.payload}");

        // Langsung buka file yang diterima dari payload
        String filePath = response.payload!;

        // Gunakan file_picker untuk membuka file SAF
        await pickAndOpenFile(filePath);
      }
    },
  );

  // Membuat saluran notifikasi
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'download_channel_id', // Channel ID
    'Unduhan Berhasil', // Nama channel
    description: 'Notifikasi untuk file yang telah diunduh',
    importance: Importance.high, // Pengaturan penting
    // priority: Priority.high, // Prioritas tinggi agar muncul di atas
    playSound: true, // Mengaktifkan suara
    enableVibration: true, // Mengaktifkan getaran
    showBadge: true, // Tampilkan badge
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Menginisialisasi binding (jembatan) antara framework Flutter dan platform native sebelum menjalankan aplikasi / menginisialisasi fiture spt notifikasi local
  initializeNotifications(); // Inisialisasi notifikasi
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistem Manajemen Balita',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Menetapkan font default untuk semua widget
      ),
      // Menambahkan dukungan lokal untuk MonthYearPicker
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate, // Tambahkan ini
      ],
      supportedLocales: const [
        Locale('en', ''), // Locale Bahasa Inggris
        Locale('id', ''), // Locale Bahasa Indonesia
      ],
      home: SplashScreenPage(),
      locale: Locale('id'), // Memaksa penggunaan bahasa Indonesia
    );
  }
}
