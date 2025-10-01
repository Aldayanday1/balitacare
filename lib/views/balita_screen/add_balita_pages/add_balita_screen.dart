import 'package:aplikasibalita/controllers/balita_controller.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:aplikasibalita/views/balita_screen/navigation_bar.dart';
import 'package:aplikasibalita/views/perkembangan_screen/add_perkembangan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

class AddBalitaScreen extends StatefulWidget {
  final int? balitaId; // Parameter opsional untuk balitaId

  AddBalitaScreen({this.balitaId});

  @override
  _AddBalitaScreenState createState() => _AddBalitaScreenState();
}

class _AddBalitaScreenState extends State<AddBalitaScreen> {
  final BalitaController _balitaController = BalitaController();
  final _formKey = GlobalKey<FormState>();
  String nik = '';
  String nama = '';
  DateTime? tanggalLahir;
  String jenisKelamin = 'Laki-laki';
  String namaOrangTua = '';
  double beratBadanLahir = 0;
  double tinggiBadanLahir = 0;

  int? _balitaId;

  double _scale = 1.0;

  // TextEditingController untuk tanggal lahir
  final TextEditingController _tanggalLahirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Jika balitaId diberikan, ambil data balita dari database
    if (widget.balitaId != null) {
      _loadBalitaData(widget.balitaId!);
    }
  }

  // Fungsi untuk memuat data balita berdasarkan ID
  void _loadBalitaData(int id) async {
    Balita? balita = await _balitaController.getBalitaById(id);
    if (balita != null) {
      setState(() {
        _balitaId = balita.id;
        nik =
            balita.nik ?? ''; // Jika nik nullable, berikan nilai default kosong
        nama = balita.nama;
        tanggalLahir = balita.tanggalLahir;
        jenisKelamin = balita.jenisKelamin;
        namaOrangTua = balita.namaOrangTua;
        beratBadanLahir = balita.beratBadanLahir;
        tinggiBadanLahir = balita.tinggiBadanLahir;
      });
    } else {
      // Handle jika balita tidak ditemukan atau null
      print("Balita dengan ID $id tidak ditemukan");
    }
  }

  @override
  void dispose() {
    // Jangan lupa untuk dispose controller-nya
    _tanggalLahirController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.85; // Ukuran sedikit lebih kecil
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Kembali ke ukuran normal
    });
  }

  // Modal Jenis kelamin
  void _showGenderPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Jenis Kelamin',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title:
                    Text('Laki-laki', style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  setState(() {
                    jenisKelamin = 'Laki-laki';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title:
                    Text('Perempuan', style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  setState(() {
                    jenisKelamin = 'Perempuan';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 130.0, left: 20, right: 20, bottom: 50),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Form
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Data Balita',
                        style: TextStyle(
                          fontFamily: 'Poppins', // Font Poppins
                          fontSize: 24, // Ukuran font lebih besar
                          fontWeight: FontWeight.bold, // Gaya font tebal
                          color: Colors.grey[700], // Warna teks
                        ),
                      ),
                      SizedBox(height: 11), // Jarak antara judul dan deskripsi
                      // Deskripsi Form
                      Text(
                        'Harap cek data terlebih dahulu sebelum melanjutkan.',
                        style: TextStyle(
                          fontFamily: 'Poppins', // Font Poppins
                          fontSize: 14, // Ukuran font lebih kecil
                          color: Colors.grey[700], // Warna teks abu-abu
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30), // Jarak antara deskripsi dan form

                // NIK Input
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_box, color: Colors.grey),
                      labelText: 'NIK (Opsional)',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                    style: TextStyle(
                      fontFamily: 'Poppins', // Menggunakan font Poppins
                      fontSize: 15, // Ukuran font
                      color: Colors.grey[700], // Warna teks
                      fontWeight: FontWeight.w500, // Ketebalan font
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => nik = value,
                  ),
                ),
                // SizedBox(height: 16),

                // Nama Input
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      labelText: 'Nama',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                    style: TextStyle(
                      fontFamily: 'Poppins', // Menggunakan font Poppins
                      fontSize: 15, // Ukuran font
                      color: Colors.grey[700], // Warna teks
                      fontWeight: FontWeight.w500, // Ketebalan font
                    ),
                    onChanged: (value) => nama = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
                // SizedBox(height: 16),

                // Tanggal Lahir Input
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _tanggalLahirController,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.grey),
                      labelText: 'Tanggal Lahir',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                    style: TextStyle(
                      fontFamily: 'Poppins', // Menggunakan font Poppins
                      fontSize: 15, // Ukuran font
                      color: Colors.grey[700], // Warna teks
                      fontWeight: FontWeight.w500, // Ketebalan font
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      tanggalLahir = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (tanggalLahir != null) {
                        setState(() {
                          _tanggalLahirController.text =
                              DateFormat('dd-MM-yyyy').format(tanggalLahir!);
                        });
                      }
                    },
                    validator: (value) {
                      if (tanggalLahir == null) {
                        return 'Tanggal lahir harus diisi';
                      }
                      return null;
                    },
                  ),
                ),

                // Jenis Kelamin (modal)
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.wc, color: Colors.grey),
                    title: Text(
                      jenisKelamin,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_drop_down, color: Colors.grey),
                    onTap: () => _showGenderPicker(context),
                  ),
                ),

                // Nama Orang Tua Input
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.person_2_outlined, color: Colors.grey),
                      labelText: 'Nama Orang Tua',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                    style: TextStyle(
                      fontFamily: 'Poppins', // Menggunakan font Poppins
                      fontSize: 15, // Ukuran font
                      color: Colors.grey[700], // Warna teks
                      fontWeight: FontWeight.w500, // Ketebalan font
                    ),
                    onChanged: (value) => namaOrangTua = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama orang tua harus diisi';
                      }
                      return null;
                    },
                  ),
                ),

                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'Nama Orang Tua',
                //     labelStyle: TextStyle(fontFamily: 'Poppins'),
                //     border: OutlineInputBorder(),
                //     filled: true,
                //     fillColor: Colors.grey[100],
                //     contentPadding: EdgeInsets.all(16),
                //   ),
                //   onChanged: (value) => namaOrangTua = value,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Nama orang tua harus diisi';
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(height: 16),

                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'Berat Badan Lahir (kg)',
                //     labelStyle: TextStyle(fontFamily: 'Poppins'),
                //     border: OutlineInputBorder(),
                //     filled: true,
                //     fillColor: Colors.grey[100],
                //     contentPadding: EdgeInsets.all(16),
                //   ),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) =>
                //       beratBadanLahir = double.tryParse(value) ?? 0,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Berat Badan Lahir harus diisi';
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(height: 16),

                // Row untuk Berat Badan Lahir dan Tinggi Badan Lahir
                Row(
                  children: [
                    // Berat Badan Lahir Input
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: 16, right: 8), // Beri jarak antar kolom
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.monitor_weight, color: Colors.grey),
                            label: Container(
                              height:
                                  20, // Atur tinggi container sesuai kebutuhan
                              child: Marquee(
                                text:
                                    'Berat Badan Lahir (kg)', // Teks label berjalan
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                scrollAxis: Axis.horizontal,
                                blankSpace: 20.0,
                                velocity: 30.0,
                                pauseAfterRound: Duration(seconds: 1),
                                startPadding: 10.0,
                                accelerationDuration: Duration(seconds: 1),
                                accelerationCurve: Curves.easeIn,
                                decelerationDuration:
                                    Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              beratBadanLahir = double.tryParse(value) ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Berat Badan Lahir harus diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    // Tinggi Badan Lahir Input
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: 16, left: 8), // Beri jarak antar kolom
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.height, color: Colors.grey),
                            label: Container(
                              height:
                                  20, // Atur tinggi container sesuai kebutuhan
                              child: Marquee(
                                text:
                                    'Tinggi Badan Lahir (cm)', // Teks label berjalan
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                scrollAxis: Axis.horizontal,
                                blankSpace: 20.0,
                                velocity: 30.0,
                                pauseAfterRound: Duration(seconds: 1),
                                startPadding: 10.0,
                                accelerationDuration: Duration(seconds: 1),
                                accelerationCurve: Curves.easeIn,
                                decelerationDuration:
                                    Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                          ),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              tinggiBadanLahir = double.tryParse(value) ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tinggi Badan Lahir harus diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'Tinggi Badan Lahir (cm)',
                //     labelStyle: TextStyle(fontFamily: 'Poppins'),
                //     border: OutlineInputBorder(),
                //     filled: true,
                //     fillColor: Colors.grey[100],
                //     contentPadding: EdgeInsets.all(16),
                //   ),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) =>
                //       tinggiBadanLahir = double.tryParse(value) ?? 0,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Tinggi Badan Lahir harus diisi';
                //     }
                //     return null;
                //   },
                // ),

                // Form untuk input data balita
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      onTapCancel: () {
                        setState(() {
                          _scale = 1.0;
                        });
                      },
                      child: AnimatedScale(
                        scale: _scale,
                        duration: Duration(milliseconds: 150),
                        curve: Curves.bounceInOut,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Validasi data Balita
                              if (_balitaId != null) {
                                // Jika ID sudah ada, ambil data Balita yang ada
                                Balita? existingBalita = await _balitaController
                                    .getBalitaById(_balitaId!);

                                // Jika data Balita ditemukan, lakukan update
                                if (existingBalita != null) {
                                  await _balitaController.updateBalita(
                                    Balita(
                                      id: _balitaId,
                                      nik: nik.isNotEmpty ? nik : null,
                                      nama: nama,
                                      tanggalLahir: tanggalLahir!,
                                      jenisKelamin: jenisKelamin,
                                      namaOrangTua: namaOrangTua,
                                      beratBadanLahir: beratBadanLahir,
                                      tinggiBadanLahir: tinggiBadanLahir,
                                      createdAt: existingBalita.createdAt,
                                      updatedAt: existingBalita.updatedAt,
                                    ),
                                  );
                                }
                              } else {
                                // Jika ID belum ada, tambahkan data baru
                                int insertedId =
                                    await _balitaController.addBalita(
                                  Balita(
                                    id: null,
                                    nik: nik.isNotEmpty ? nik : null,
                                    nama: nama,
                                    tanggalLahir: tanggalLahir!,
                                    jenisKelamin: jenisKelamin,
                                    namaOrangTua: namaOrangTua,
                                    beratBadanLahir: beratBadanLahir,
                                    tinggiBadanLahir: tinggiBadanLahir,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                  ),
                                );
                                setState(() {
                                  _balitaId =
                                      insertedId; // Simpan ID yang diterima
                                });
                              }

                              // Navigasi ke halaman AddPerkembanganScreen untuk menyelesaikan proses
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPerkembanganScreen(
                                    balitaId: _balitaId!,
                                    returnToHome: true,
                                  ),
                                ),
                              );

                              // Validasi jika data perkembangan tidak ditambahkan
                              if (result == null || result != true) {
                                // Jika perkembangan tidak disimpan, hapus data balita yang ditambahkan
                                if (_balitaId != null) {
                                  await _balitaController
                                      .deleteBalita(_balitaId!);
                                  setState(() {
                                    _balitaId = null;
                                  });
                                }
                                // // Tampilkan pesan error
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //       content: Text(
                                //           'Harap lengkapi data perkembangan.')),
                                // );
                              } else {
                                // Jika valid, navigasi kembali atau tampilkan sukses
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Data berhasil disimpan.')),
                                );
                              }
                            }
                          },
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 24,
                            color: Colors.white,
                          ), // Menambahkan ikon panah maju
                          label: Text(
                            'Lanjut',
                            style: TextStyle(
                              fontFamily: 'Poppins', // Menggunakan font Poppins
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white, // Teks menjadi putih
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 147, 174,
                                182), // Warna latar belakang tombol
                            padding: EdgeInsets.symmetric(
                                horizontal: 148,
                                vertical: 11), // Memperlebar tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Sudut yang lebih melengkung
                            ),
                            elevation:
                                10, // Memberikan sedikit bayangan untuk efek 3D
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: 1), // Posisi index untuk HomeScreen
    );
  }
}
