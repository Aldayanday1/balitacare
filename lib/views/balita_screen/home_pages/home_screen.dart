import 'package:aplikasibalita/controllers/balita_controller.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:aplikasibalita/views/balita_screen/balita_status_page.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/widgets/balita_bar_chart.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/widgets/balita_card.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/widgets/faq_dialog.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/widgets/gender_filter_menu.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/widgets/status_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'dart:async';

import 'package:quickalert/widgets/quickalert_dialog.dart';

class HomeScreen extends StatefulWidget {
  final String? notificationMessage; // Tambahkan parameter untuk notifikasi

  const HomeScreen({super.key, this.notificationMessage});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BalitaController _balitaController = BalitaController();
  late Future<List<Balita>> _balitaList;

  late String
      _currentDateTime; // Variabel untuk menyimpan tanggal dan waktu saat ini

  late Future<Map<String, int>> _statusCountsFuture;

  final TextEditingController _searchController = TextEditingController();

  // ignore: unused_field
  String _searchQuery = "";

  late Future<Map<String, int>> _balitaCountPerMonthFuture;

  // Variabel untuk mengatur visibilitas ikon pada grafik
  bool _isVisible = false;

  // Variabel untuk efek animasi FAQ Icon
  double _faqScale = 1.0;

  // Variabel untuk efek animasi Bar Chart Icon
  double _barChartScale = 1.0;

  // Variabel untuk efek animasi Filter Jenis Kelamin
  double _filterScale = 1.0;

  // Variabel untuk menyimpan jenis kelamin yang dipilih
  String? _selectedGender = 'Semua'; // Default memilih 'Semua'

  @override
  void initState() {
    super.initState();

    // Menampilkan notifikasi jika ada pesan
    if (widget.notificationMessage != null) {
      Future.microtask(() {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Berhasil',
          text: widget.notificationMessage!, // Pesan notifikasi
          confirmBtnText: 'Oke',
          confirmBtnColor: Colors.white, // Tombol konfirmasi berwarna hijau
          confirmBtnTextStyle: TextStyle(
              color: Color.fromARGB(255, 17, 161, 89),
              fontWeight: FontWeight.w100, // Menambahkan teks tebal
              fontSize: 15),
          onConfirmBtnTap: () {
            Navigator.pop(context); // Menutup dialog setelah klik OK
          },
        );
      });
    }

    _balitaList = _balitaController.getAllBalita();

    // Inisialisasi Future saat widget pertama kali dibangun
    _statusCountsFuture = _balitaController.getStatusCounts();

    // Untuk memperbarui waktu secara berkala setiap detik
    _currentDateTime = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateDateTime());

    // Mengambil data jumlah balita untuk 6 bulan terakhir
    _balitaCountPerMonthFuture = _balitaController.getBalitaCountLast6Months();
  }

  // Fungsi untuk memperbarui tanggal dan waktu
  void _updateDateTime() {
    setState(() {
      _currentDateTime = _formatDateTime(DateTime.now());
    });
  }

  // Fungsi untuk memformat waktu
  String _formatDateTime(DateTime dateTime) {
    return "${_getDayOfWeek(dateTime.weekday)}, ${dateTime.month}, ${dateTime.year}";
  }

  // Fungsi untuk mendapatkan nama hari dalam bahasa Indonesia
  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return "Senin";
      case 2:
        return "Selasa";
      case 3:
        return "Rabu";
      case 4:
        return "Kamis";
      case 5:
        return "Jumat";
      case 6:
        return "Sabtu";
      case 7:
        return "Minggu";
      default:
        return "";
    }
  }

  // Memperbarui status counts
  void _refreshStatusCounts() {
    setState(() {
      _statusCountsFuture = _balitaController.getStatusCounts();
    });
  }

  // Fungsi untuk memperbarui daftar balita
  void _refreshBalitaList() {
    setState(() {
      if (_selectedGender == 'Semua' ||
          _selectedGender == null ||
          _selectedGender!.isEmpty) {
        // Jika 'Semua' dipilih, ambil semua data balita
        _balitaList = _balitaController.getAllBalita();
      } else {
        // Jika 'Laki-laki' atau 'Perempuan' dipilih, filter berdasarkan jenis kelamin
        _balitaList = _balitaController.getBalitaByGender(_selectedGender!);
      }
    });
  }

  // Memperbarui data grafik jumlah balita untuk 6 bulan terakhir
  void _refreshBalitaCountPerMonth() {
    setState(() {
      _balitaCountPerMonthFuture =
          _balitaController.getBalitaCountLast6Months();
    });
  }

  // Fungsi untuk searc data balita berdasarkan nama nya
  void _searchBalita(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isNotEmpty) {
        _balitaList = _balitaController.searchBalita(query);
      } else {
        _balitaList =
            _balitaController.getAllBalita(); // Tampilkan semua jika kosong
      }
    });
  }

  // Fungsi untuk toggle visibilitas ikon
  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible; // Mengubah status visibilitas
    });
  }

  void _showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FAQDialog(); // Memanggil FAQDialog yang telah dibuat terpisah
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 35.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    // Bagian gambar header
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/photos/header_homepage.jpg'),
                          fit: BoxFit.cover, // Gambar memenuhi container
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom:
                              Radius.circular(30), // Radius melengkung di bawah
                        ),
                      ),
                    ),

                    // Greeting message & FAQ
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35.0, vertical: 37),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, top: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Balitacare ➕",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      _currentDateTime, // Menampilkan waktu yang diperbarui
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily:
                                            'Poppins', // Menggunakan font Roboto
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // FAQ Icon
                              Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _showFAQDialog(context);
                                  },
                                  onTapDown: (_) {
                                    setState(() {
                                      _faqScale =
                                          0.5; // Menyusutkan ukuran ikon saat ditekan
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _faqScale =
                                          1.0; // Mengembalikan ukuran ikon ke normal
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _faqScale =
                                          1.0; // Mengembalikan ukuran jika batal
                                    });
                                  },
                                  child: AnimatedScale(
                                    scale: _faqScale, // Skala animasi
                                    duration: Duration(
                                        milliseconds: 150), // Durasi animasi
                                    curve: Curves.easeInOut, // Kurva animasi
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 132, 158, 165),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            offset: Offset(2, 2),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                        size: 23,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 150, // Atur posisi greeting
                      left: 26,
                      // left: 25,
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 255,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                _searchBalita(value);
                              },
                              decoration: InputDecoration(
                                hintText: "Search Balita...",
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 7),
                              ),
                            ),
                          ),
                          PopupMenuTheme(
                            data: PopupMenuThemeData(
                              color: Color.fromARGB(255, 132, 158,
                                  165), // Set background color of the popup menu to black
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: GestureDetector(
                                onTapDown: (_) {
                                  // Efek animasi saat menekan tombol
                                  setState(() {
                                    _filterScale =
                                        0.5; // Ukuran lebih kecil saat ditekan
                                  });
                                },
                                onTapUp: (_) {
                                  // Kembali ke ukuran semula setelah dilepas
                                  setState(() {
                                    _filterScale = 1.0;
                                  });
                                },
                                onTapCancel: () {
                                  // Jika tap dibatalkan, kembali ke ukuran semula
                                  setState(() {
                                    _filterScale = 1.0;
                                  });
                                },
                                // icon filtering menu /jenis kelamin
                                child: GenderFilterMenu(
                                  filterScale: _filterScale,
                                  animationDuration:
                                      Duration(milliseconds: 150),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                    _refreshBalitaList();
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Bar Chart Icon
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: GestureDetector(
                              onTap:
                                  _toggleVisibility, // Mengubah ikon saat ditekan
                              onTapDown: (_) {
                                setState(() {
                                  _barChartScale =
                                      0.5; // Menyusutkan ukuran ikon saat ditekan
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _barChartScale =
                                      1.0; // Mengembalikan ukuran ikon ke normal
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  _barChartScale =
                                      1.0; // Mengembalikan ukuran jika batal
                                });
                              },
                              child: AnimatedScale(
                                scale: _barChartScale,
                                duration: Duration(milliseconds: 150),
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
                                    _isVisible
                                        ? Icons.bar_chart
                                        : Icons.bar_chart_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bagian ketiga untuk card status counts
                    Positioned(
                      height: 580,
                      right: -7,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder<Map<String, int>>(
                          future: _statusCountsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              final statusCounts = snapshot.data!;
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // decoration: BoxDecoration(
                                      //   color: Colors.white,
                                      //   borderRadius: BorderRadius.circular(16),
                                      // ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.1), // Warna bayangan
                                            offset:
                                                Offset(4, 4), // Posisi bayangan
                                            blurRadius:
                                                10, // Jarak blur bayangan
                                            spreadRadius:
                                                2, // Penyebaran bayangan
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(
                                          12.0), // Padding di dalam container
                                      child: Row(
                                        children: [
                                          StatusCard(
                                            status: 'Sehat',
                                            count: statusCounts['Sehat'] ?? 0,
                                            color: Colors.green,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BalitaStatusPage(
                                                          status: 'Sehat'),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          StatusCard(
                                            status: 'Gizi Kurang',
                                            count:
                                                statusCounts['Gizi Kurang'] ??
                                                    0,
                                            color: const Color.fromARGB(
                                                255, 216, 194, 0),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BalitaStatusPage(
                                                          status:
                                                              'Gizi Kurang'),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          StatusCard(
                                            status: 'Stunting',
                                            count: statusCounts[
                                                    'Stunting/Gizi Buruk'] ??
                                                0,
                                            color: Colors.red,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BalitaStatusPage(
                                                          status:
                                                              'Stunting/Gizi Buruk'),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(child: Text('Tidak ada data'));
                            }
                          },
                        ),
                      ),
                    ),

                    // Barchart data Balita & ListView untuk Balita
                    Padding(
                      padding: const EdgeInsets.only(top: 375.0),
                      child: Column(
                        children: [
                          BalitaBarChart(
                              balitaCountPerMonthFuture:
                                  _balitaCountPerMonthFuture,
                              isVisible: _isVisible),
                          // ListView untuk Balita
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            child: FutureBuilder<List<Balita>>(
                              future: _balitaList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 95.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/photos/no_data.png',
                                            height:
                                                100, // Sesuaikan ukuran gambar
                                            width: 100,
                                          ),
                                          const SizedBox(height: 18),
                                          Text(
                                            'Maaf, Belum ada data balita. \n Siahkan Tambahkan!',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize:
                                                  12, // Sesuaikan ukuran teks
                                              fontWeight: FontWeight.w500,
                                              color: Colors
                                                  .grey, // Sesuaikan warna teks
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final balitaList = snapshot.data!;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      NeverScrollableScrollPhysics(), // Menghindari scroll ganda
                                  itemCount: balitaList.length,
                                  itemBuilder: (context, index) {
                                    final balita = balitaList[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: BalitaCard(
                                        balita: balita,
                                        onUpdate: () {
                                          _refreshBalitaList();
                                          _refreshBalitaCountPerMonth();
                                        },
                                        onDelete: () async {
                                          await _balitaController
                                              .deleteBalita(balita.id!);
                                          _refreshBalitaList();
                                          _refreshStatusCounts();
                                          _refreshBalitaCountPerMonth();
                                        },
                                        onUpdateStatusCounts:
                                            _refreshStatusCounts,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bagian kedua untuk Search Field
                // Positioned(
                //   top: 150, // Atur posisi greeting
                //   left: 25,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 26.0, vertical: 11),
                //     child: Row(
                //       children: [
                //         Expanded(
                //           child: Container(
                //             height: 45,
                //             decoration: BoxDecoration(
                //               color: Colors.white,
                //               borderRadius: BorderRadius.circular(30.0),
                //               boxShadow: [
                //                 BoxShadow(
                //                   color: Colors.grey.withOpacity(0.5),
                //                   spreadRadius: 1,
                //                   blurRadius: 5,
                //                   offset: Offset(0, 3),
                //                 ),
                //               ],
                //             ),
                //             child: TextField(
                //               controller: _searchController,
                //               onChanged: (value) {
                //                 _searchBalita(value);
                //               },
                //               decoration: InputDecoration(
                //                 prefixIcon: Icon(Icons.search),
                //                 hintText: 'Search',
                //                 border: InputBorder.none,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
