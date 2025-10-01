import 'package:aplikasibalita/views/balita_screen/detail_pages/widgets/balita_info_card.dart';
import 'package:aplikasibalita/views/balita_screen/detail_pages/widgets/grafik_card.dart';
import 'package:aplikasibalita/views/balita_screen/detail_pages/widgets/grafik_dropdown.dart';
import 'package:aplikasibalita/views/balita_screen/detail_pages/widgets/perkembangan_card.dart';
import 'package:aplikasibalita/views/balita_screen/faq_dialog_detail.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:aplikasibalita/controllers/balita_controller.dart';
import 'package:aplikasibalita/controllers/perkembangan_controller.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:aplikasibalita/models/perkembangan.dart';
import 'package:aplikasibalita/views/perkembangan_screen/add_perkembangan_screen.dart';
import 'package:aplikasibalita/views/perkembangan_screen/edit_perkembangan_screen.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class DetailPage extends StatefulWidget {
  final int balitaId;
  final String? notificationMessage; // Tambahkan parameter untuk notifikasi

  DetailPage({required this.balitaId, this.notificationMessage});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  final BalitaController _balitaController = BalitaController();
  final PerkembanganController _perkembanganController =
      PerkembanganController();

  late Future<Balita?> _balita;
  late Future<List<Perkembangan>> _perkembanganList;

  // Variabel untuk dropdown
  int _selectedDataCount = 5; // Jumlah data yang dipilih, default 5
  final List<int> _dataOptions = [5, 10, 15]; // Opsi data yang ditampilkan

  late AnimationController _controller;
  late Animation<Offset> _slideAnimationNamaBalita;
  late Animation<Offset> _slideAnimationTanggalLahir;
  late Animation<Offset> _slideAnimationIcon;

  late Animation<double> _fadeAnimationNamaBalita;
  late Animation<double> _fadeAnimationTanggalLahir;
  late Animation<double> _fadeAnimationIcon;

  // Variabel untuk efek animasi FAQ Icon
  double _faqScale = 1.0;

  @override
  void initState() {
    super.initState();

    // Pastikan pesan notifikasi ditampilkan saat DetailPage dibuka
    if (widget.notificationMessage != null &&
        widget.notificationMessage!.isNotEmpty) {
      showNotification(widget.notificationMessage!);
    }

    _balita = _balitaController.getBalitaById(widget.balitaId);
    _perkembanganList =
        _perkembanganController.getPerkembanganByBalitaId(widget.balitaId);

    // Inisialisasi controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Durasi animasi
    );

    // Animasi slide dan fade untuk ikon gambar (muncul pertama)
    _slideAnimationIcon = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Mulai dari kiri layar
      end: Offset.zero, // Ke posisi awal
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.3,
            curve: Curves.easeInOut), // Kurva halus untuk ikon
      ),
    );

    _fadeAnimationIcon = Tween<double>(
      begin: 0.0, // Mulai menghilang
      end: 1.0, // Muncul penuh
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.3,
            curve: Curves.easeInOut), // Kurva halus untuk ikon
      ),
    );

    // Animasi slide dan fade untuk nama balita (dari kiri ke kanan)
    _slideAnimationNamaBalita = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Mulai dari kiri layar
      end: Offset.zero, // Ke posisi awal
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.5,
            curve: Curves.easeInOut), // Mulai setelah ikon, hampir bersamaan
      ),
    );

    _fadeAnimationNamaBalita = Tween<double>(
      begin: 0.0, // Mulai menghilang
      end: 1.0, // Muncul penuh
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.5,
            curve: Curves.easeInOut), // Mulai setelah ikon, hampir bersamaan
      ),
    );

    // Animasi slide dan fade untuk tanggal lahir (dari kiri ke kanan)
    _slideAnimationTanggalLahir = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Mulai dari kiri layar
      end: Offset.zero, // Ke posisi awal
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.5,
            curve: Curves.easeInOut), // Mulai sedikit setelah nama
      ),
    );

    _fadeAnimationTanggalLahir = Tween<double>(
      begin: 0.0, // Mulai menghilang
      end: 1.0, // Muncul penuh
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.5,
            curve: Curves.easeInOut), // Mulai sedikit setelah nama
      ),
    );

    // Mulai animasi
    _controller.forward();
  }

  // Fungsi untuk mengambil jumlah data yang sesuai dengan pilihan dropdown
  List<Perkembangan> _getLimitedData(List<Perkembangan> perkembanganList) {
    int count = perkembanganList.length > _selectedDataCount
        ? _selectedDataCount
        : perkembanganList.length;
    return perkembanganList.sublist(perkembanganList.length - count);
  }

  // Fungsi untuk membuat data grafik berdasarkan perkembangan yang terbatas
  List<Map<String, dynamic>> _getGrafikData(
      List<Perkembangan> perkembanganList, String jenisKelamin) {
    List<Map<String, dynamic>> data = [];
    List<Perkembangan> limitedData = _getLimitedData(perkembanganList);

    for (var perkembangan in limitedData) {
      String status = _perkembanganController.determineStatus(
          jenisKelamin, perkembangan.beratBadan, perkembangan.tinggiBadan);
      data.add({
        'tanggal': perkembangan
            .tanggalUkur, // Menggunakan tanggalUkur sebagai ganti createdAt
        'status': status,
      });
    }

    return data;
  }

  Future<void> showNotification(String message) async {
    if (message.isNotEmpty) {
      // Menampilkan notifikasi QuickAlert setelah halaman siap
      Future.microtask(() {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Berhasil',
          text: message,
          confirmBtnText: 'Oke',
          confirmBtnColor: Colors.white,
          confirmBtnTextStyle: TextStyle(
            color: Color.fromARGB(255, 17, 161, 89),
            fontWeight: FontWeight.w100,
            fontSize: 15,
          ),
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
        );
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--; // Kurangi 1 tahun jika belum mencapai ulang tahun tahun ini
    }
    return age;
  }

  void _showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FAQDialogDetail(); // Memanggil FAQDialog yang telah dibuat terpisah
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Balita?>(
        future: _balita,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Balita tidak ditemukan'));
          }

          final balita = snapshot.data!;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Memastikan kolom terletak kiri
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // Back button section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 19),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          color: Color.fromARGB(255, 51, 109, 53),
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                    // Header Section di tengah halaman
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Pisahkan elemen di kiri dan kanan
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Posisikan elemen secara vertikal di tengah
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Ikon gambar dengan animasi
                                    FadeTransition(
                                      opacity: _fadeAnimationIcon,
                                      child: SlideTransition(
                                        position: _slideAnimationIcon,
                                        child: Image.asset(
                                          'assets/photos/user.png', // Gambar dari folder assets
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FadeTransition(
                                          opacity:
                                              _fadeAnimationNamaBalita, // Efek menghilang dan muncul
                                          child: SlideTransition(
                                            position:
                                                _slideAnimationNamaBalita, // Efek slide dari kiri ke kanan
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      200), // Batasi lebar nama
                                              child: Text(
                                                balita.nama,
                                                overflow: TextOverflow
                                                    .ellipsis, // Menghindari teks meluber
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins',
                                                  color: Color.fromARGB(
                                                      255, 67, 124, 89),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        FadeTransition(
                                          opacity:
                                              _fadeAnimationTanggalLahir, // Efek menghilang dan muncul
                                          child: SlideTransition(
                                            position:
                                                _slideAnimationTanggalLahir, // Efek slide dari kiri ke kanan
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${_calculateAge(balita.tanggalLahir)} tahun', // Menampilkan usia
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    fontFamily: 'Poppins',
                                                    color: Color.fromARGB(
                                                        255, 67, 124, 89),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // FAQ Icon
                                Padding(
                                  padding: const EdgeInsets.only(right: 47.0),
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
                                          color: Colors.white,
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
                                          color: Color.fromARGB(
                                              255, 132, 158, 165),
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),

                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 51, 109, 53),
                            ),
                            textAlign:
                                TextAlign.left, // Menambahkan textAlign ke kiri
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Data Balita.",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 84, 156, 111),
                            ),
                            textAlign:
                                TextAlign.left, // Menambahkan textAlign ke kiri
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: 20),

                    Card(
                      color: Colors.white, // Pastikan warna Card tetap putih
                      elevation: 8, // Efek bayangan
                      shadowColor: Colors.grey.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors
                                .white, // Tambahkan untuk memastikan warna latar belakang tetap putih
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Data Balita
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Text(
                                          'NIK : ${balita.nik ?? "Tidak tersedia"}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 51, 109, 53),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      Divider(color: Colors.grey[300]),

                                      // Detail Data Balita

                                      // Nama
                                      Text(
                                        'Nama Lengkap: ${balita.nama}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Tanggal Lahir
                                      Text(
                                        'Tanggal Lahir: ${balita.tanggalLahir.toLocal().toString().split(' ')[0]}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Jenis Kelamin
                                      Text(
                                        'Jenis Kelamin: ${balita.jenisKelamin}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Nama Orang Tua
                                      Text(
                                        'Nama Orang Tua: ${balita.namaOrangTua}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Berat Badan Lahir
                                      Text(
                                        'Berat Badan Lahir: ${balita.beratBadanLahir.toStringAsFixed(0)} kg',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Tinggi Badan Lahir
                                      Text(
                                        'Tinggi Badan Lahir: ${balita.tinggiBadanLahir.toStringAsFixed(0)} cm',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0, // Mengatur posisi vertikal ikon
                            right: 30, // Mengatur posisi horizontal ikon
                            child: Icon(
                              Icons.bookmark,
                              color: Color.fromARGB(
                                  255, 75, 140, 100), // Warna ikon bookmark
                              size: 35, // Ukuran ikon
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 35),

                    // // Tombol untuk Menambah Data Perkembangan
                    // Center(
                    //   child: ElevatedButton.icon(
                    //     onPressed: () async {
                    //       final result = await Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => AddPerkembanganScreen(
                    //             balitaId: balita.id!,
                    //             returnToHome: false,
                    //           ),
                    //         ),
                    //       );
                    //       if (result == true) {
                    //         setState(() {
                    //           _perkembanganList = _perkembanganController
                    //               .getPerkembanganByBalitaId(balita.id!);
                    //         });
                    //         showNotification(
                    //             "Data Perkembangan berhasil disimpan!"); // Panggil fungsi notifikasi
                    //       }
                    //     },
                    //     icon: Icon(Icons.add),
                    //     label: Text('Tambah Perkembangan'),
                    //     style: ElevatedButton.styleFrom(
                    //       padding: EdgeInsets.symmetric(
                    //           horizontal: 20, vertical: 15),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20),

                    // Card untuk menampilkan grafik perkembangan
                    FutureBuilder<List<Perkembangan>>(
                        future: _perkembanganList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                                child:
                                    Text('Data perkembangan tidak ditemukan'));
                          }

                          final perkembanganList = snapshot.data!;
                          final grafikData = _getGrafikData(
                              perkembanganList, balita.jenisKelamin);
                          print(
                              grafikData); // Periksa apakah data ini tidak kosong

                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(children: [
                              // Dropdown untuk memilih jumlah data
                              GrafikIconMenu(
                                selectedValue: _selectedDataCount,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDataCount = value;
                                  });
                                },
                                dataOptions: _dataOptions,
                              ),

                              // Card untuk menampilkan grafik perkembangan
                              PerkembanganGrafikCard(grafikData: grafikData),
                            ]),
                          );
                        }),

                    const Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 51, 109, 53),
                            ),
                            textAlign:
                                TextAlign.left, // Menambahkan textAlign ke kiri
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Data Perkembangan.",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 84, 156, 111),
                            ),
                            textAlign:
                                TextAlign.left, // Menambahkan textAlign ke kiri
                          ),
                          SizedBox(height: 10),
                          // Text(
                          //   "Tanggal Ukur Balita",
                          //   style: TextStyle(
                          //     fontFamily: 'Poppins',
                          //     fontSize: 26,
                          //     fontWeight: FontWeight.bold,
                          //     color: Color.fromARGB(255, 100, 170, 120),
                          //   ),
                          //   textAlign:
                          //       TextAlign.left, // Menambahkan textAlign ke kiri
                          // ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, top: 15, bottom: 0),
                      child: Align(
                        alignment:
                            Alignment.centerLeft, // Menyusun teks di kiri
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Menyusun kolom ke kiri
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Menyusun ikon dan teks ke kiri
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .arrow_forward, // Ikon panah ke kanan
                                      size: 15,
                                      color: Color.fromARGB(
                                          255, 75, 140, 100), // Warna ikon
                                    ),
                                    SizedBox(
                                        width: 5), // Jarak antara ikon dan teks
                                    Expanded(
                                      child: Text(
                                        'Geser ke kanan untuk mengedit.',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10), // Jarak antar baris
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back, // Ikon panah ke kiri
                                      size: 15,
                                      color: Colors.redAccent, // Warna ikon
                                    ),
                                    SizedBox(
                                        width: 5), // Jarak antara ikon dan teks
                                    Expanded(
                                      child: Text(
                                        'Geser ke kiri untuk menghapus.',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Text(
                              '*Dihitung berdasarkan Tanggal Ukur pada : ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                                height: 1.5, // Menambahkan spasi antar baris
                              ),
                            ),
                            SizedBox(
                                height: 10), // Memberikan jarak antar baris
                          ],
                        ),
                      ),
                    ),

                    // List Perkembangan
                    FutureBuilder<List<Perkembangan>>(
                      future: _perkembanganList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text('Tidak ada data perkembangan'));
                        }

                        final perkembanganList = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap:
                              true, // Agar ListView tidak mengisi seluruh ruang
                          physics:
                              NeverScrollableScrollPhysics(), // Menonaktifkan scroll pada ListView
                          itemCount: perkembanganList.length,
                          itemBuilder: (context, index) {
                            final perkembangan = perkembanganList[index];
                            return PerkembanganCard(
                              perkembangan: perkembangan,
                              onEdit: () async {
                                final update = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditPerkembanganScreen(
                                      perkembangan: perkembangan,
                                      balitaId: balita.id!,
                                    ),
                                  ),
                                );
                                if (update == true) {
                                  // Jika ada pesan, tampilkan notifikasi di DetailPage
                                  setState(() {
                                    _perkembanganList = _perkembanganController
                                        .getPerkembanganByBalitaId(
                                            widget.balitaId);
                                  });

                                  showNotification(
                                      "Data Perkembangan berhasil diperbarui!"); // Panggil fungsi notifikasi
                                }
                              },
                              onDelete: () async {
                                // bool confirmDelete = await showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return AlertDialog(
                                //       title: Text('Konfirmasi Hapus'),
                                //       content: Text(
                                //           'Apakah Anda yakin ingin menghapus data ini?'),
                                //       actions: [
                                //         TextButton(
                                //           onPressed: () {
                                //             Navigator.of(context).pop(false);
                                //           },
                                //           child: Text('Batal'),
                                //         ),
                                //         TextButton(
                                //           onPressed: () {
                                //             Navigator.of(context).pop(true);
                                //           },
                                //           child: Text('Hapus'),
                                //         ),
                                //       ],
                                //     );
                                //   },
                                // );
                                // Menampilkan QuickAlert untuk konfirmasi
                                bool? confirmDelete = await QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Konfirmasi Hapus',
                                  text:
                                      'Apakah Anda yakin ingin menghapus data Perkembangan ini?',
                                  confirmBtnText: 'Hapus',
                                  cancelBtnText: 'Batal',
                                  confirmBtnColor:
                                      Colors.white, // Warna tombol Hapus
                                  confirmBtnTextStyle: TextStyle(
                                      color: Color.fromARGB(255, 156, 39, 39),
                                      fontWeight: FontWeight
                                          .w100, // Menambahkan teks tebal
                                      fontSize: 15),
                                  onConfirmBtnTap: () {
                                    // Ketika tombol Hapus diklik, kembalikan nilai true
                                    Navigator.of(context).pop(true);
                                  },
                                  onCancelBtnTap: () {
                                    // Ketika tombol Batal diklik, kembalikan nilai false
                                    Navigator.of(context).pop(false);
                                  },
                                );

                                // Jika konfirmasi hapus adalah true, lakukan penghapusan
                                if (confirmDelete != null && confirmDelete) {
                                  await _perkembanganController
                                      .deletePerkembangan(perkembangan.id!);
                                  setState(() {
                                    _perkembanganList = _perkembanganController
                                        .getPerkembanganByBalitaId(
                                            perkembangan.balitaId);
                                  });
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder<Balita?>(
        future: _balita,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(); // FAB tidak ditampilkan saat menunggu data
          } else if (snapshot.hasError || !snapshot.hasData) {
            return SizedBox(); // FAB tidak ditampilkan jika terjadi error atau data kosong
          }

          final balita = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Latar belakang putih
                shape: BoxShape.circle, // Bentuk bulat
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Warna bayangan
                    spreadRadius: 4, // Ukuran penyebaran bayangan
                    blurRadius: 15, // Kehalusan bayangan
                    offset: Offset(0, 8), // Posisi bayangan
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPerkembanganScreen(
                        balitaId: balita.id!,
                        returnToHome: false,
                      ),
                    ),
                  );
                  if (result == true) {
                    setState(() {
                      _perkembanganList = _perkembanganController
                          .getPerkembanganByBalitaId(balita.id!);
                    });
                    showNotification("Data Perkembangan berhasil disimpan!");
                  }
                },
                child: Icon(
                  Icons.add,
                  size: 25,
                  color: const Color.fromARGB(
                      255, 75, 140, 100), // Warna ikon hijau
                ),
                backgroundColor: Colors.white, // Latar belakang putih
                elevation: 0, // Menghilangkan bayangan default
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(50), // Membuat bentuk bulat
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
