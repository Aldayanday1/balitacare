import 'package:aplikasibalita/controllers/balita_controller.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:aplikasibalita/views/balita_screen/detail_pages/detail_page.dart';
import 'package:aplikasibalita/views/balita_screen/excel_exporter.dart';
import 'package:aplikasibalita/views/balita_screen/faq_dialog_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class DataBalitaScreen extends StatefulWidget {
  final List<Balita> filteredBalitaList;
  final DateTime selectedMonth;

  const DataBalitaScreen({
    Key? key,
    required this.filteredBalitaList,
    required this.selectedMonth,
  }) : super(key: key);

  @override
  State<DataBalitaScreen> createState() => _DataBalitaScreenState();
}

class _DataBalitaScreenState extends State<DataBalitaScreen>
    with TickerProviderStateMixin {
  List<Balita>? _filteredBalitaList;
  bool _isLoading = false; // Indikator loading

  // bool isExpanded = false;
  bool isAllExpanded = true; // Variabel untuk mengontrol semua card

  late AnimationController _controller;
  late Animation<double> _fadeAnimationPeriode;
  late Animation<double> _fadeAnimationDataBalita;
  late Animation<double> _fadeAnimationFormattedMonth;

  late Animation<Offset> _slideAnimationPeriode;
  late Animation<Offset> _slideAnimationDataBalita;
  late Animation<Offset> _slideAnimationFormattedMonth;

  // // Fungsi untuk mengambil data
  // Future<List<Balita>> _fetchFilteredBalitaList() async {
  //   // Mengambil data balita yang sudah difilter
  //   return widget
  //       .filteredBalitaList; // Bisa diganti dengan logika untuk mem-fetch data dari API atau database
  // }

  // Future<void> _updateFilteredBalitaList() async {
  //   final updatedData = await BalitaController()
  //       .getFilteredBalitaWithPerkembangan(widget.selectedMonth);
  //   setState(() {
  //     _filteredBalitaList = updatedData;
  //   });
  // }

  // Fungsi untuk memperbarui data balita yang difilter
  Future<void> _updateFilteredBalitaList() async {
    setState(() {
      _isLoading = true; // Tampilkan loading hanya saat memperbarui data
    });
    try {
      final updatedData = await BalitaController()
          .getFilteredBalitaWithPerkembangan(widget.selectedMonth);
      setState(() {
        _filteredBalitaList = updatedData;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saat memperbarui data: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Sembunyikan loading setelah selesai
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Inisialisasi data dengan data yang diterima dari widget
    _filteredBalitaList = widget.filteredBalitaList;

    // Inisialisasi controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Durasi animasi lebih cepat
    );

    // Animasi fade untuk 'Periode'
    _fadeAnimationPeriode = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.33,
            curve: Curves.easeInOut), // Kurva halus untuk Periode
      ),
    );

    // Animasi fade untuk 'Data Balita'
    _fadeAnimationDataBalita = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.5,
            curve: Curves.easeInOut), // Kurva halus untuk Data Balita
      ),
    );

    // Animasi fade untuk 'formattedMonth'
    _fadeAnimationFormattedMonth = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 0.66,
            curve: Curves.easeInOut), // Kurva halus untuk formattedMonth
      ),
    );

    // Animasi slide untuk 'Periode'
    _slideAnimationPeriode = Tween<Offset>(
      begin: Offset(0.0, -1.0), // Mulai dari atas layar
      end: Offset.zero, // Ke posisi awal
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.33,
            curve: Curves.easeInOut), // Kurva halus untuk Periode
      ),
    );

    // Animasi slide untuk 'Data Balita'
    _slideAnimationDataBalita = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.5,
            curve: Curves.easeInOut), // Kurva halus untuk Data Balita
      ),
    );

    // Animasi slide untuk 'formattedMonth'
    _slideAnimationFormattedMonth = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 0.66,
            curve: Curves.easeInOut), // Kurva halus untuk formattedMonth
      ),
    );

    // Mulai animasi
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool?> _showDownloadConfirmationDialog(BuildContext context) async {
    String formattedMonth =
        DateFormat('MMMM yyyy', 'id_ID').format(widget.selectedMonth);

    // Menggunakan QuickAlert untuk konfirmasi
    bool? isConfirmed = await QuickAlert.show(
      context: context,
      type: QuickAlertType.warning, // Tipe untuk konfirmasi
      title: 'Konfirmasi Unduh',
      text:
          'Apakah Anda ingin mengunduh file Excel untuk data pada bulan $formattedMonth?',
      confirmBtnText: 'Ya',
      confirmBtnColor: Colors.white, // Tombol konfirmasi warna hijau
      confirmBtnTextStyle: TextStyle(
          color: Color.fromARGB(255, 70, 108, 133),
          fontWeight: FontWeight.w100,
          fontSize: 14),
      onConfirmBtnTap: () {
        Navigator.of(context).pop(true); // Pilih "Ya"
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop(false); // Pilih "Tidak"
      },
    );

    return isConfirmed;
  }

  Future<void> _downloadExcel(BuildContext context) async {
    final isConfirmed = await _showDownloadConfirmationDialog(context);

    if (isConfirmed == null || !isConfirmed) return;

    // Ambil data terbaru sebelum mengunduh
    try {
      final updatedData = await BalitaController()
          .getFilteredBalitaWithPerkembangan(widget.selectedMonth);

      if (updatedData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Tidak ada data yang tersedia untuk diunduh.')),
        );
        return;
      }

      // Ekspor data yang diperbarui ke Excel
      final filePath = await exportToExcelWithSAF(updatedData);

      // Tampilkan snack bar hanya setelah file berhasil disimpan
      if (filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil diunduh sebagai file Excel.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Penyimpanan file dibatalkan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat mengunduh data: $e')),
      );
    }
  }

  // Variabel untuk efek animasi FAQ Icon
  double _faqScale = 1.0;

  // Variabel untuk efek animasi Expanded Scale Icon
  double _expandedScale = 1.0;

  void _showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FAQDialogExport(); // Memanggil FAQDialog yang telah dibuat terpisah
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedMonth =
        DateFormat('MMMM yyyy', 'id_ID').format(widget.selectedMonth);

    return Scaffold(
      backgroundColor: Colors.white, // Menetapkan warna latar belakang putih
      body: SafeArea(
        child: SingleChildScrollView(
          // Membuat seluruh konten bisa discroll
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              children: [
                // Header
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical:
                          12), // Menambahkan padding horizontal pada container
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          color: Color.fromARGB(255, 51, 109, 53),
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Teks periode hanya muncul jika filteredBalitaList tidak kosong
                if (widget.filteredBalitaList
                    .isNotEmpty) // Kondisi untuk menampilkan teks
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0), // Menambahkan padding kiri
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Pisahkan elemen di kiri dan kanan
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Posisikan elemen secara vertikal di tengah
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Animasi 'Periode'
                                  SlideTransition(
                                    position: _slideAnimationPeriode,
                                    child: FadeTransition(
                                      opacity: _fadeAnimationPeriode,
                                      child: Text(
                                        'Periode',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 51, 109, 53),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  // Animasi 'Data Balita'
                                  SlideTransition(
                                    position: _slideAnimationDataBalita,
                                    child: FadeTransition(
                                      opacity: _fadeAnimationDataBalita,
                                      child: Text(
                                        'Data Balita',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 75, 140, 100),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  // Animasi 'formattedMonth'
                                  SlideTransition(
                                    position: _slideAnimationFormattedMonth,
                                    child: FadeTransition(
                                      opacity: _fadeAnimationFormattedMonth,
                                      child: Text(
                                        formattedMonth,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 100, 170, 120),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Spacer(), // Ruang di antara teks dan ikon
                            // FAQ Icon
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
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
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(2, 2),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Color.fromARGB(255, 132, 158, 165),
                                      size: 23,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Icon untuk membuka semua detail
                            Padding(
                              padding: const EdgeInsets.only(right: 25.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isAllExpanded = !isAllExpanded;
                                  });
                                },
                                onTapDown: (_) {
                                  setState(() {
                                    _expandedScale =
                                        0.5; // Menyusutkan ukuran ikon saat ditekan
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _expandedScale =
                                        1.0; // Mengembalikan ukuran ikon ke normal
                                  });
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _expandedScale =
                                        1.0; // Mengembalikan ukuran jika batal
                                  });
                                },
                                child: AnimatedScale(
                                  scale: _expandedScale, // Skala animasi
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
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(2, 2),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isAllExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Color.fromARGB(255, 132, 158, 165),
                                      size: 23,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment:
                              Alignment.centerLeft, // Menyusun teks di kiri
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Menyusun kolom ke kiri
                            children: [
                              Text(
                                'Pastikan data sudah sesuai.',
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
                              Row(
                                children: [
                                  Text(
                                    'Klik ikon ',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  // Ikon download dibungkus dengan Container berbentuk lingkaran
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          8), // Padding untuk memberi ruang di sekitar ikon
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, // Warna latar belakang ikon
                                        shape:
                                            BoxShape.circle, // Bentuk lingkaran
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(
                                                0.3), // Efek bayangan ringan
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset:
                                                Offset(0, 2), // Posisi bayangan
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.download,
                                        size: 15, // Ukuran ikon
                                        color: Color.fromARGB(
                                            255, 75, 140, 100), // Warna ikon
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' untuk mengunduh data balita.',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: 16,
                ),
                // Isi body
                widget.filteredBalitaList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 222.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/photos/no_data.png',
                                height: 100, // Sesuaikan ukuran gambar
                                width: 100,
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'Maaf, Tidak ada data yang tersedia \n untuk diunduh.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12, // Sesuaikan ukuran teks
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey, // Sesuaikan warna teks
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : _isLoading
                        ? Center(
                            child: CircularProgressIndicator()) // Loading state
                        : _filteredBalitaList == null ||
                                _filteredBalitaList!.isEmpty
                            ? Center(
                                child: Text('Tidak ada data')) // Data kosong
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _filteredBalitaList!.length,
                                itemBuilder: (context, index) {
                                  final balita = _filteredBalitaList![index];
                                  return Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 1),
                                        child: InkWell(
                                          onTap: () async {
                                            if (balita.id != null) {
                                              final isUpdated =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPage(
                                                          balitaId: balita.id!),
                                                ),
                                              );
                                              if (isUpdated == true) {
                                                // Perbarui data jika kembali dari DetailPage
                                                setState(() {
                                                  // Memanggil ulang FutureBuilder untuk memperbarui data
                                                  _updateFilteredBalitaList();
                                                });
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Data balita tidak valid')),
                                              );
                                            }
                                          },
                                          child: Card(
                                            color: Colors
                                                .white, // Pastikan warna Card putih
                                            elevation:
                                                8, // Efek bayangan untuk memberi kesan melayang
                                            shadowColor: Colors.grey.withOpacity(
                                                0.5), // Warna bayangan yang lembut
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      16), // Sudut melengkung
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .white, // Pastikan background putih di dalam Card
                                                borderRadius: BorderRadius.circular(
                                                    16), // Sudut melengkung dalam
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Nama Balita dengan Tanggal Lahir
                                                    Text(
                                                      '${balita.nama}',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255,
                                                            51,
                                                            109,
                                                            53), // Warna kedua (lebih muda)
                                                      ),
                                                      maxLines:
                                                          1, // Membatasi menjadi satu baris
                                                      overflow: TextOverflow
                                                          .ellipsis, // Menampilkan "..." jika teks terlalu panjang
                                                      softWrap:
                                                          false, // Tidak membungkus ke baris berikutnya
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),

                                                    Text(
                                                      'NIK: ${balita.nik ?? "Tidak tersedia"}',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                            255,
                                                            67,
                                                            124,
                                                            89), // Warna kedua (lebih muda)
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Tanggal Lahir: ${DateFormat('dd MMM yyyy', 'id_ID').format(balita.tanggalLahir)}',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                            255,
                                                            67,
                                                            124,
                                                            89), // Warna kedua (lebih muda)
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            05), // Spasi antara tombol lihat detail dan data tambahan

                                                    // Bagian Data Perkembangan dan Detail
                                                    if (isAllExpanded)
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Data Perkembangan
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        8.0),
                                                            child: Text(
                                                              'Data Balita',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          51,
                                                                          109,
                                                                          53),
                                                                  fontFamily:
                                                                      'Poppins'),
                                                            ),
                                                          ),
                                                          // Data tambahan yang ditampilkan setelah tombol "Lihat detail" diklik
                                                          Text(
                                                            'Jenis Kelamin: ${balita.jenisKelamin}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'Nama Orang Tua: ${balita.namaOrangTua}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                            maxLines:
                                                                1, // Membatasi menjadi satu baris
                                                            overflow: TextOverflow
                                                                .ellipsis, // Menampilkan "..." jika teks terlalu panjang
                                                            softWrap:
                                                                false, // Tidak membungkus ke baris berikutnya
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'Berat Badan Lahir: ${balita.beratBadanLahir.toStringAsFixed(0)} kg',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'Tinggi Badan Lahir: ${balita.tinggiBadanLahir.toStringAsFixed(0)} cm',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),

                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Divider(
                                                              color: Colors
                                                                  .grey[300]),

                                                          // Data Perkembangan
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        5.0),
                                                            child: Text(
                                                              'Data Perkembangan',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          51,
                                                                          109,
                                                                          53),
                                                                  fontFamily:
                                                                      'Poppins'),
                                                            ),
                                                          ),
                                                          balita.perkembangan
                                                                  .isEmpty
                                                              ? Text(
                                                                  'Tidak ada data perkembangan.',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          700]),
                                                                )
                                                              : Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: balita
                                                                      .perkembangan
                                                                      .map(
                                                                          (perkembangan) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Tanggal Ukur: ${DateFormat('dd MMMM yyyy', 'id_ID').format(perkembangan.tanggalUkur)}',
                                                                            style:
                                                                                TextStyle(color: Colors.grey[700]),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'Lingkar Kepala: ${perkembangan.lingkarKepala.toStringAsFixed(0)} cm',
                                                                            style:
                                                                                TextStyle(color: Colors.grey[700]),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'Cara Ukur: ${perkembangan.caraUkur}',
                                                                            style:
                                                                                TextStyle(color: Colors.grey[700]),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'Lingkar Lengan Atas: ${perkembangan.lingkarLenganAtas.toStringAsFixed(0)} cm',
                                                                            style:
                                                                                TextStyle(color: Colors.grey[700]),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'Berat Badan: ${perkembangan.beratBadan.toStringAsFixed(0)} kg',
                                                                            style:
                                                                                TextStyle(color: Colors.grey[700]),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'Tinggi Badan: ${perkembangan.tinggiBadan.toStringAsFixed(0)} cm',
                                                                            style:
                                                                                TextStyle(color: Colors.grey[700]),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: widget.filteredBalitaList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Latar belakang putih
                  shape: BoxShape.circle, // Bentuk bulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Bayangan lebih kuat dan gelap
                      spreadRadius: 4, // Menambah ukuran bayangan
                      blurRadius: 15, // Membuat bayangan lebih lembut
                      offset: Offset(0, 8), // Mengatur posisi bayangan
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () => _downloadExcel(context),
                  child: Icon(
                    Icons.download,
                    size: 25,
                    color:
                        const Color.fromARGB(255, 75, 140, 100), // Ikon hijau
                  ),
                  backgroundColor: Colors.white, // Latar belakang putih
                  elevation: 0, // Menghilangkan bayangan default
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Membuat bulat
                  ),
                ),
              ),
            )
          : null, // Menyembunyikan FAB jika filteredBalitaList kosong
    );
  }
}
