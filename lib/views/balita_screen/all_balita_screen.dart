import 'package:aplikasibalita/controllers/balita_controller.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:aplikasibalita/views/balita_screen/data_balita_screen.dart';
import 'package:aplikasibalita/views/balita_screen/excel_exporter.dart';
import 'package:aplikasibalita/views/balita_screen/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:month_year_picker/month_year_picker.dart';

class AllBalitaScreen extends StatefulWidget {
  @override
  _AllBalitaScreenState createState() => _AllBalitaScreenState();
}

class _AllBalitaScreenState extends State<AllBalitaScreen> {
  final BalitaController _balitaController = BalitaController();
  // late Future<List<Balita>> _balitaList;

  // Variabel untuk menyimpan tanggal yang dipilih oleh pengguna melalui kalender
  DateTime? _selectedMonth;

  // Variabel untuk menyimpan daftar balita yang sudah difilter berdasarkan bulan dan tahun yang dipilih
  List<Balita>? _filteredBalitaList;

  // Variabel untuk efek animasi button Pick Month
  double _pickMonthScale = 1.0;

  // Variabel untuk efek animasi button Next
  double _nextScale = 1.0;

  @override
  void initState() {
    super.initState();
    // _balitaList = _balitaController.getAllBalita();
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: _selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      // Menambahkan pengaturan ukuran dialog
      builder: (context, child) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Mengatur latar belakang menjadi transparan
          child: Container(
            // Menyesuaikan ukuran dialog
            constraints: BoxConstraints(maxHeight: 515 // Ubah sesuai kebutuhan
                ),
            child: child,
          ),
        );
      },
    );

    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
      await _loadFilteredBalita(); // Memuat data setelah memilih bulan
    }
  }

  Future<void> _loadFilteredBalita() async {
    if (_selectedMonth == null) return;

    final data = await _balitaController
        .getFilteredBalitaWithPerkembangan(_selectedMonth!);

    setState(() {
      _filteredBalitaList = data;
    });
  }

  void _navigateToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataBalitaScreen(
          filteredBalitaList: _filteredBalitaList!,
          selectedMonth: _selectedMonth!,
        ),
      ),
    );
  }

  // Future<bool?> _showDownloadConfirmationDialog(BuildContext context) async {
  //   if (_selectedMonth == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Pilih bulan terlebih dahulu.')),
  //     );
  //     return null;
  //   }

  //   // Format bulan dan tahun yang dipilih
  //   String formattedMonth = DateFormat('MMMM yyyy').format(_selectedMonth!);

  //   return showDialog<bool>(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Konfirmasi Unduh'),
  //         content: Text(
  //           'Apakah Anda ingin mengunduh file Excel untuk data pada bulan $formattedMonth?',
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(false),
  //             child: Text('Tidak'),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(true),
  //             child: Text('Ya'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _downloadExcel() async {
  //   // Tampilkan dialog konfirmasi
  //   final isConfirmed = await _showDownloadConfirmationDialog(context);

  //   // Jika pengguna memilih "Tidak", hentikan proses
  //   if (isConfirmed == null || !isConfirmed) {
  //     return;
  //   }

  //   // Lanjutkan proses unduh jika "Ya"
  //   if (_filteredBalitaList == null || _filteredBalitaList!.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Tidak ada data yang tersedia untuk diunduh.')),
  //     );
  //     return;
  //   }

  //   await exportToExcelWithSAF(_filteredBalitaList!);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gambar di tengah
                Image.asset(
                  'assets/photos/xlsx_sheets.png',
                  height: 100, // Sesuaikan ukuran gambar
                  width: 100,
                ),
                const SizedBox(height: 20),
                // Teks menarik
                Text(
                  'Export data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins', // Pastikan font ini terdaftar
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 32, 32, 32),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Unduh data balita dalam format Excel \n untuk kebutuhan Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins', // Pastikan font ini terdaftar
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 41, 41, 41),
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: EdgeInsets.only(
                    left: _selectedMonth == null
                        ? 15
                        : 0, // Menyesuaikan padding kiri
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _selectMonth(context),
                        onTapDown: (_) {
                          setState(() {
                            _pickMonthScale =
                                0.9; // Menyusutkan ukuran tombol saat ditekan
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _pickMonthScale =
                                1.0; // Mengembalikan ukuran tombol ke normal
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            _pickMonthScale =
                                1.0; // Mengembalikan ukuran jika batal
                          });
                        },
                        child: AnimatedScale(
                          scale: _pickMonthScale, // Skala animasi tombol
                          duration:
                              Duration(milliseconds: 150), // Durasi animasi
                          curve: Curves.easeInOut, // Kurva animasi
                          child: Material(
                            elevation: 8, // Tinggi bayangan
                            shadowColor: Colors.black
                                .withOpacity(0.3), // Bayangan lebih ringan
                            borderRadius: BorderRadius.circular(
                                12), // Radius sudut tombol
                            child: ElevatedButton(
                              onPressed: () => _selectMonth(context),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                elevation: MaterialStateProperty.all(0),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 0)), // Padding lebih besar
                                fixedSize: MaterialStateProperty.all(
                                  Size(_selectedMonth == null ? 290 : 185,
                                      50), // Perlebar jika teks kosong
                                  // Size(_selectedMonth == null ? 240 : 185,
                                  // 50), // Perlebar jika teks kosong
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Kolom untuk ikon kalender dengan lebar tetap
                                  Container(
                                    padding: EdgeInsets.only(
                                        left:
                                            10), // Menambah jarak dengan tepi kiri
                                    child: const Icon(
                                      Icons.calendar_today,
                                      color: Color.fromARGB(255, 51, 109, 53),
                                      size: 18,
                                    ),
                                  ),

                                  /// Garis pembatas vertikal
                                  Container(
                                    width: 1, // Lebar garis
                                    height: 20, // Tinggi garis
                                    color: Color.fromARGB(
                                        255, 51, 109, 53), // Warna garis
                                    margin: const EdgeInsets.only(
                                        left: 15), // Jarak dengan elemen lain
                                  ),

                                  // Kolom untuk teks dengan animasi perubahan
                                  Expanded(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                          milliseconds: 500), // Durasi animasi
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        // Menggunakan SlideTransition untuk pergerakan dari atas
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(
                                                0, -3), // Memulai dari atas
                                            end: Offset
                                                .zero, // Bergerak ke posisi normal
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                      child: _selectedMonth == null
                                          ? Text(
                                              'Pilih bulan untuk melihat data',
                                              key: ValueKey<String>(
                                                  'defaultText'), // Gunakan key statis untuk teks default
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 51, 109, 53),
                                              ),
                                            )
                                          : Text(
                                              DateFormat('MMMM yyyy', 'id_ID')
                                                  .format(_selectedMonth!),
                                              key: ValueKey<DateTime>(
                                                  _selectedMonth!), // Gunakan key dinamis untuk teks yang berubah
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 51, 109, 53),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      // Tombol Next untuk halaman berikutnya
                      if (_selectedMonth != null)
                        GestureDetector(
                          onTap: () => _navigateToNextScreen,
                          onTapDown: (_) {
                            setState(() {
                              _nextScale =
                                  0.9; // Menyusutkan ukuran tombol saat ditekan
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _nextScale =
                                  1.0; // Mengembalikan ukuran tombol ke normal
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              _nextScale =
                                  1.0; // Mengembalikan ukuran jika batal
                            });
                          },
                          child: AnimatedScale(
                            scale: _nextScale, // Skala animasi tombol
                            duration:
                                Duration(milliseconds: 150), // Durasi animasi
                            curve: Curves.easeInOut, // Kurva animasi
                            child: Material(
                              elevation: 8, // Tinggi bayangan
                              shadowColor: Colors.black
                                  .withOpacity(0.3), // Bayangan lebih ringan
                              borderRadius: BorderRadius.circular(
                                  12), // Radius sudut tombol
                              child: ElevatedButton(
                                // onPressed: () => _selectMonth(context),
                                onPressed: _navigateToNextScreen,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          vertical: 14,
                                          horizontal:
                                              20)), // Padding lebih besar
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                        fontFamily: 'Poppins', // Font Poppins
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 51, 109,
                                            53), // Warna hijau pada teks
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1.3),
                                      child: Icon(
                                        Icons.navigate_next,
                                        color: Color.fromARGB(255, 51, 109, 53),
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // const SizedBox(height: 30),
                // _filteredBalitaList == null
                //     ? Center(child: Text('Pilih bulan untuk melihat data'))
                //     : _filteredBalitaList!.isEmpty
                //         ? Center(child: Text('Tidak ada data pada bulan ini'))
                //         : ListView.builder(
                //             shrinkWrap: true,
                //             physics: NeverScrollableScrollPhysics(),
                //             itemCount: _filteredBalitaList!.length,
                //             itemBuilder: (context, index) {
                //               final balita = _filteredBalitaList![index];
                //               return Card(
                //                 elevation: 4,
                //                 margin: EdgeInsets.symmetric(
                //                     vertical: 8, horizontal: 16),
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(16.0),
                //                   child: Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       // Informasi Balita
                //                       Text(
                //                         'Nama: ${balita.nama}',
                //                         style: TextStyle(
                //                             fontWeight: FontWeight.bold),
                //                       ),
                //                       Text(
                //                           'NIK: ${balita.nik ?? "Tidak tersedia"}'),
                //                       // Text(
                //                       //     'Tanggal Lahir: ${balita.tanggalLahir.toLocal()}'),
                //                       Text(
                //                         'Tanggal Lahir: ${DateFormat('dd MMM yyyy').format(balita.tanggalLahir)}',
                //                       ),
                //                       Text(
                //                           'Jenis Kelamin: ${balita.jenisKelamin}'),
                //                       Text(
                //                           'Nama Orang Tua: ${balita.namaOrangTua}'),
                //                       Text(
                //                           'Berat Badan Lahir: ${balita.beratBadanLahir} kg'),
                //                       Text(
                //                           'Tinggi Badan Lahir: ${balita.tinggiBadanLahir} cm'),
                //                       Divider(),

                //                       // Data Perkembangan
                //                       Text(
                //                         'Data Perkembangan:',
                //                         style: TextStyle(
                //                             fontWeight: FontWeight.bold),
                //                       ),
                //                       balita.perkembangan.isEmpty
                //                           ? Text('Tidak ada data perkembangan.')
                //                           : Column(
                //                               crossAxisAlignment:
                //                                   CrossAxisAlignment.start,
                //                               children: balita.perkembangan
                //                                   .map((perkembangan) {
                //                                 return Padding(
                //                                   padding:
                //                                       const EdgeInsets.only(
                //                                           top: 8.0),
                //                                   child: Column(
                //                                     crossAxisAlignment:
                //                                         CrossAxisAlignment
                //                                             .start,
                //                                     children: [
                //                                       // Text(
                //                                       //   'Tanggal Ukur: ${perkembangan.tanggalUkur.toLocal()}',
                //                                       // ),
                //                                       Text(
                //                                         'Tanggal Ukur: ${DateFormat('dd MMM yyyy').format(perkembangan.tanggalUkur)}',
                //                                       ),
                //                                       Text(
                //                                         'Lingkar Kepala: ${perkembangan.lingkarKepala} cm',
                //                                       ),
                //                                       Text(
                //                                           'Cara Ukur: ${perkembangan.caraUkur}'),
                //                                       Text(
                //                                         'Lingkar Lengan Atas: ${perkembangan.lingkarLenganAtas} cm',
                //                                       ),
                //                                       Text(
                //                                         'Berat Badan: ${perkembangan.beratBadan} kg',
                //                                       ),
                //                                       Text(
                //                                         'Tinggi Badan: ${perkembangan.tinggiBadan} cm',
                //                                       ),
                //                                       Divider(), // Separator antar data perkembangan
                //                                     ],
                //                                   ),
                //                                 );
                //                               }).toList(),
                //                             ),
                //                     ],
                //                   ),
                //                 ),
                //               );
                //             },
                //           ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: 2), // Posisi index untuk HomeScreen
    );
  }
}
