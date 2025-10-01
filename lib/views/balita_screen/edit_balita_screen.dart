// ignore_for_file: unnecessary_null_comparison

import 'package:aplikasibalita/controllers/balita_controller.dart';
import 'package:aplikasibalita/models/balita.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EditBalitaScreen extends StatefulWidget {
  final Balita balita;

  const EditBalitaScreen({Key? key, required this.balita}) : super(key: key);

  @override
  _EditBalitaScreenState createState() => _EditBalitaScreenState();
}

class _EditBalitaScreenState extends State<EditBalitaScreen> {
  final BalitaController _balitaController = BalitaController();
  final _formKey = GlobalKey<FormState>();
  late String nik;
  late String nama;
  late DateTime? tanggalLahir;
  late String jenisKelamin;
  late String namaOrangTua;
  late double beratBadanLahir;
  late double tinggiBadanLahir;

  @override
  void initState() {
    super.initState();
    nik = widget.balita.nik ?? '';
    nama = widget.balita.nama;
    tanggalLahir = widget.balita.tanggalLahir;
    jenisKelamin = widget.balita.jenisKelamin;
    namaOrangTua = widget.balita.namaOrangTua;
    beratBadanLahir = widget.balita.beratBadanLahir;
    tinggiBadanLahir = widget.balita.tinggiBadanLahir;

    // Set nilai awal untuk controller tanggal lahir
    if (tanggalLahir != null) {
      _tanggalLahirController.text =
          tanggalLahir!.toLocal().toString().split(' ')[0];
    }
  }

  // TextEditingController untuk tanggal lahir
  final TextEditingController _tanggalLahirController = TextEditingController();

  // Variabel untuk efek animasi Back Button
  double _backButtonScale = 1.0;

  // Variabel untuk efek animasi Save Button
  double _saveButtonScale = 1.0;

  // Hapus controller saat widget di-*dispose*
  @override
  void dispose() {
    _tanggalLahirController.dispose();
    super.dispose();
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
            const EdgeInsets.only(top: 165.0, left: 20, right: 20, bottom: 50),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Form
                Padding(
                  padding: const EdgeInsets.only(right: 22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Data Balita',
                        style: TextStyle(
                          fontFamily: 'Poppins', // Font Poppins
                          fontSize: 24, // Ukuran font lebih besar
                          fontWeight: FontWeight.bold, // Gaya font tebal
                          color: Colors.grey[700], // Warna teks
                        ),
                      ),
                      SizedBox(height: 13), // Jarak antara judul dan deskripsi
                      // Deskripsi Form
                      Text(
                        'Periksa kembali data Anda sebelum disimpan.',
                        style: TextStyle(
                          fontFamily: 'Poppins', // Font Poppins
                          fontSize: 14, // Ukuran font lebih kecil
                          color: Colors.grey[700], // Warna teks abu-abu
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 13), // Jarak antara judul dan deskripsi

                // // Deskripsi Form
                // Text(
                //   'Harap cek data kembali sebelum menyimpan perubahan.',
                //   style: TextStyle(
                //     fontFamily: 'Poppins', // Font Poppins
                //     fontSize: 14, // Ukuran font lebih kecil
                //     color: Colors.grey[700], // Warna teks abu-abu
                //   ),
                // ),
                SizedBox(height: 30), // Jarak antara deskripsi dan form

                // TextFormField(
                //   initialValue: nik,
                //   decoration: InputDecoration(labelText: 'NIK (Opsional)'),
                //   onChanged: (value) => nik = value,
                // ),

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
                    initialValue: nik,
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

                // TextFormField(
                //   initialValue: nama,
                //   decoration: InputDecoration(labelText: 'Nama'),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Nama tidak boleh kosong';
                //     }
                //     return null;
                //   },
                //   onChanged: (value) => nama = value,
                // ),

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
                    initialValue: nama,
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

                // TextFormField(
                //   initialValue: tanggalLahir.toLocal().toString().split(' ')[0],
                //   decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                //   onTap: () async {
                //     FocusScope.of(context).requestFocus(FocusNode());
                //     DateTime? pickedDate = await showDatePicker(
                //       context: context,
                //       initialDate: tanggalLahir,
                //       firstDate: DateTime(1900),
                //       lastDate: DateTime.now(),
                //     );
                //     if (pickedDate != null) {
                //       setState(() {
                //         tanggalLahir = pickedDate;
                //       });
                //     }
                //   },
                // ),

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
                    // initialValue:
                    //     tanggalLahir!.toLocal().toString().split(' ')[0],
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

                // DropdownButtonFormField<String>(
                //   value: jenisKelamin,
                //   decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                //   items: <String>['Laki-laki', 'Perempuan'].map((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       jenisKelamin = newValue!;
                //     });
                //   },
                // ),

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

                // TextFormField(
                //   initialValue: namaOrangTua,
                //   decoration: InputDecoration(labelText: 'Nama Orang Tua'),
                //   onChanged: (value) => namaOrangTua = value,
                // ),

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
                    initialValue: namaOrangTua,
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
                //   initialValue: beratBadanLahir.toString(),
                //   decoration: InputDecoration(labelText: 'Berat Badan Lahir'),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) =>
                //       beratBadanLahir = double.tryParse(value) ?? 0,
                // ),
                // TextFormField(
                //   initialValue: tinggiBadanLahir.toString(),
                //   decoration: InputDecoration(labelText: 'Tinggi Badan Lahir'),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) =>
                //       tinggiBadanLahir = double.tryParse(value) ?? 0,
                // ),

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
                          initialValue: beratBadanLahir.toString(),
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
                          initialValue: tinggiBadanLahir.toString(),
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

                SizedBox(height: 20),

                // Save and Back Button
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            _backButtonScale =
                                0.8; // Menyusutkan ukuran ikon saat ditekan
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _backButtonScale =
                                1.0; // Mengembalikan ukuran ikon ke normal
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            _backButtonScale =
                                1.0; // Mengembalikan ukuran jika batal
                          });
                        },
                        child: AnimatedScale(
                          scale: _backButtonScale,
                          duration: Duration(milliseconds: 150),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              size: 24,
                              color: Colors.white,
                            ), // Menambahkan ikon panah maju
                            label: Text(
                              'Kembali',
                              style: TextStyle(
                                fontFamily:
                                    'Poppins', // Menggunakan font Poppins
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white, // Teks menjadi putih
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 147, 174,
                                  182), // Warna latar belakang tombol
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 148,
                              //     vertical: 11), // Memperlebar tombol
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
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            _saveButtonScale =
                                0.8; // Menyusutkan ukuran ikon saat ditekan
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            _saveButtonScale =
                                1.0; // Mengembalikan ukuran ikon ke normal
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            _saveButtonScale =
                                1.0; // Mengembalikan ukuran jika batal
                          });
                        },
                        child: AnimatedScale(
                          scale: _saveButtonScale,
                          duration: Duration(milliseconds: 150),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Menampilkan konfirmasi menggunakan QuickAlert
                                bool? confirm = await QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  title: 'Konfirmasi',
                                  text:
                                      'Apakah Anda yakin ingin menyimpan perubahan pada data Balita ini?',
                                  confirmBtnText: 'Ya',
                                  cancelBtnText: 'Tidak',
                                  confirmBtnColor:
                                      Color.fromARGB(255, 93, 204, 185),
                                  confirmBtnTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w100,
                                      fontSize: 14),
                                  cancelBtnTextStyle: TextStyle(
                                      color: Color.fromARGB(255, 47, 102, 93),
                                      fontWeight: FontWeight.w100,
                                      fontSize: 14),
                                  onConfirmBtnTap: () {
                                    Navigator.of(context)
                                        .pop(true); // Jika memilih "Ya"
                                  },
                                  onCancelBtnTap: () {
                                    Navigator.of(context)
                                        .pop(false); // Jika memilih "Tidak"
                                  },
                                );

                                // Jika pengguna memilih 'Ya', maka lakukan update
                                if (confirm == true) {
                                  Balita updatedBalita = Balita(
                                    id: widget.balita.id,
                                    nik: nik.isEmpty
                                        ? null
                                        : nik, // Set nik ke null jika kosong
                                    nama: nama,
                                    tanggalLahir: tanggalLahir!,
                                    jenisKelamin: jenisKelamin,
                                    namaOrangTua: namaOrangTua,
                                    beratBadanLahir: beratBadanLahir,
                                    tinggiBadanLahir: tinggiBadanLahir,
                                    createdAt: widget.balita
                                        .createdAt, // Pertahankan createdAt yang sudah ada
                                    updatedAt: DateTime
                                        .now(), // Update updatedAt ke waktu sekarang
                                  );

                                  await _balitaController
                                      .updateBalita(updatedBalita);

                                  // Kembali ke halaman sebelumnya
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          notificationMessage:
                                              'Data Balita berhasil diperbarui!', // Kirim pesan,
                                        ),
                                      ));
                                }
                              }
                            },
                            icon: Icon(
                              Icons.done,
                              size: 24,
                              color: Colors.white,
                            ), // Menambahkan ikon panah maju
                            label: Text(
                              'Simpan',
                              style: TextStyle(
                                fontFamily:
                                    'Poppins', // Menggunakan font Poppins
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white, // Teks menjadi putih
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 147, 174,
                                  182), // Warna latar belakang tombol
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
