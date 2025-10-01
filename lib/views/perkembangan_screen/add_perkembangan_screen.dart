import 'package:aplikasibalita/controllers/perkembangan_controller.dart';
import 'package:aplikasibalita/models/perkembangan.dart';
import 'package:aplikasibalita/views/balita_screen/detail_pages/detail_page.dart';
import 'package:aplikasibalita/views/balita_screen/home_pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddPerkembanganScreen extends StatefulWidget {
  final int balitaId;
  final bool? returnToHome; // Parameter opsional untuk mengontrol navigasi

  AddPerkembanganScreen({required this.balitaId, this.returnToHome});

  @override
  _AddPerkembanganScreenState createState() => _AddPerkembanganScreenState();
}

class _AddPerkembanganScreenState extends State<AddPerkembanganScreen> {
  final PerkembanganController _perkembanganController =
      PerkembanganController();
  final _formKey = GlobalKey<FormState>();
  DateTime? tanggalUkur;
  double lingkarKepala = 0;
  String caraUkur = 'Terlentang';
  double lingkarLenganAtas = 0;
  double beratBadan = 0;
  double tinggiBadan = 0;

  // TextEditingController untuk tanggal ukur
  final TextEditingController _tanggalUkurController = TextEditingController();

  // Variabel untuk efek animasi Back Button
  double _backButtonScale = 1.0;

  // Variabel untuk efek animasi Save Button
  double _saveButtonScale = 1.0;

  @override
  void dispose() {
    // Jangan lupa untuk dispose controller-nya
    _tanggalUkurController.dispose();
    super.dispose();
  }

  // Modal Cara Ukur
  void _showCaraUkurPicker(BuildContext context) {
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
                'Pilih Cara Ukur',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title:
                    Text('Terlentang', style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  setState(() {
                    caraUkur = 'Terlentang';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Berdiri', style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  setState(() {
                    caraUkur = 'Berdiri';
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
            const EdgeInsets.only(top: 206.0, left: 20, right: 20, bottom: 50),
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
                        'Add Data Perkembangan',
                        style: TextStyle(
                          fontFamily: 'Poppins', // Font Poppins
                          fontSize: 24, // Ukuran font lebih besar
                          fontWeight: FontWeight.bold, // Gaya font tebal
                          color: Colors.grey[700], // Warna teks
                        ),
                      ),
                      SizedBox(height: 11), // Jarak antara judul dan deskripsi
                      // Deskripsi Form dengan Ikon
                      Row(
                        children: [
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
                    ],
                  ),
                ),
                SizedBox(height: 32), //

                // TextFormField(
                //   controller:
                //       _tanggalUkurController, // Tampilkan hasil pemilihan tanggal
                //   decoration: InputDecoration(labelText: 'Tanggal Ukur'),
                //   onTap: () async {
                //     FocusScope.of(context).requestFocus(FocusNode());
                //     tanggalUkur = await showDatePicker(
                //       context: context,
                //       initialDate: DateTime.now(),
                //       firstDate: DateTime(2000),
                //       lastDate: DateTime.now(),
                //     );
                //     if (tanggalUkur != null) {
                //       // Jika tanggal dipilih, perbarui tampilan
                //       setState(() {
                //         _tanggalUkurController.text =
                //             "${tanggalUkur!.day}/${tanggalUkur!.month}/${tanggalUkur!.year}"; // Format tampilan tanggal
                //       });
                //     }
                //   },
                //   validator: (value) {
                //     if (tanggalUkur == null) {
                //       return 'Tanggal Ukur harus diisi';
                //     }
                //     return null;
                //   },
                // ),

                // Tanggal Ukur Input
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
                    controller: _tanggalUkurController,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.grey),
                      labelText: 'Tanggal Ukur',
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
                      tanggalUkur = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (tanggalUkur != null) {
                        setState(() {
                          _tanggalUkurController.text =
                              DateFormat('dd-MM-yyyy').format(tanggalUkur!);
                        });
                      }
                    },
                    validator: (value) {
                      if (tanggalUkur == null) {
                        return 'Tanggal ukur harus diisi';
                      }
                      return null;
                    },
                  ),
                ),

                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Lingkar Kepala (cm)'),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) =>
                //       lingkarKepala = double.tryParse(value) ?? 0,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Lingkar Kepala harus diisi';
                //     }
                //     return null;
                //   },
                // ),

                // Lingkar Kepala Input
                Container(
                  margin: EdgeInsets.only(bottom: 16), // Beri jarak antar kolom
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
                      prefixIcon: Icon(Icons.person_sharp, color: Colors.grey),
                      labelText: 'Lingkar Kepala (cm)',
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
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        lingkarKepala = double.tryParse(value) ?? 0,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lingkar Kepala harus diisi';
                      }
                      return null;
                    },
                  ),
                ),

                // DropdownButtonFormField<String>(
                //   value: caraUkur,
                //   decoration: InputDecoration(labelText: 'Cara Ukur'),
                //   items: ['Terlentang', 'Berdiri']
                //       .map((cara) => DropdownMenuItem(
                //             value: cara,
                //             child: Text(cara),
                //           ))
                //       .toList(),
                //   onChanged: (value) => caraUkur = value!,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Cara ukur harus diisi';
                //     }
                //     return null;
                //   },
                // ),

                // Cara Ukur (modal)
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
                    leading: Icon(Icons.straighten, color: Colors.grey),
                    title: Text(
                      caraUkur,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_drop_down, color: Colors.grey),
                    onTap: () => _showCaraUkurPicker(context),
                  ),
                ),

                // TextFormField(
                //   decoration:
                //       InputDecoration(labelText: 'Lingkar Lengan Atas (cm)'),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) =>
                //       lingkarLenganAtas = double.tryParse(value) ?? 0,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Lingkar Lengan Atas harus diisi';
                //     }
                //     return null;
                //   },
                // ),

                // Lingkar Lengan Atas
                Container(
                  margin: EdgeInsets.only(bottom: 16), // Beri jarak antar kolom
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
                      prefixIcon: Icon(Icons.accessibility, color: Colors.grey),
                      labelText: 'Lingkar Lengan Atas (cm)',
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
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        lingkarLenganAtas = double.tryParse(value) ?? 0,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lingkar Lengan Atas harus diisi';
                      }
                      return null;
                    },
                  ),
                ),

                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Berat Badan (kg)'),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) => beratBadan = double.tryParse(value) ?? 0,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Berat Badan harus diisi';
                //     }
                //     return null;
                //   },
                // ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Tinggi Badan (cm)'),
                //   keyboardType: TextInputType.number,
                //   onChanged: (value) => tinggiBadan = double.tryParse(value) ?? 0,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Tinggi Badan harus diisi';
                //     }
                //     return null;
                //   },
                // ),

                // Row untuk Berat Badan dan Tinggi Badan
                Row(
                  children: [
                    // Berat Badan Input
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
                                text: 'Berat Badan (kg)', // Teks label berjalan
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
                              beratBadan = double.tryParse(value) ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Berat Badan harus diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    // Tinggi Badan Input
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
                                    'TInggi Badan (cm)', // Teks label berjalan
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
                              tinggiBadan = double.tryParse(value) ?? 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tinggi Badan harus diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Save and Back Button
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                // // Tampilkan dialog konfirmasi sebelum menyimpan data
                                // bool confirmSave = await showDialog<bool>(
                                //       context: context,
                                //       builder: (context) {
                                //         return AlertDialog(
                                //           title: Text('Konfirmasi'),
                                //           content: Text(
                                //               'Apakah Anda yakin data yang dimasukkan sudah benar?'),
                                //           actions: [
                                //             TextButton(
                                //               onPressed: () {
                                //                 Navigator.pop(context,
                                //                     false); // Jika memilih "Tidak"
                                //               },
                                //               child: Text('Tidak'),
                                //             ),
                                //             TextButton(
                                //               onPressed: () {
                                //                 Navigator.pop(context,
                                //                     true); // Jika memilih "Ya"
                                //               },
                                //               child: Text('Ya'),
                                //             ),
                                //           ],
                                //         );
                                //       },
                                //     ) ??
                                //     false; // Default ke false jika user menutup dialog tanpa memilih

                                // Menampilkan konfirmasi menggunakan QuickAlert
                                bool? confirm = await QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  title: 'Konfirmasi',
                                  text:
                                      "Apakah Anda yakin data yang dimasukkan sudah benar?",
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

                                if (confirm == true) {
                                  // Jika konfirmasi "Ya", lanjutkan untuk menyimpan data
                                  Perkembangan newPerkembangan = Perkembangan(
                                    id: null,
                                    balitaId:
                                        widget.balitaId, // Foreign key balita
                                    tanggalUkur: tanggalUkur!,
                                    lingkarKepala: lingkarKepala,
                                    caraUkur: caraUkur,
                                    lingkarLenganAtas: lingkarLenganAtas,
                                    beratBadan: beratBadan,
                                    tinggiBadan: tinggiBadan,
                                    createdAt:
                                        DateTime.now(), // Tambahkan createdAt
                                    updatedAt:
                                        DateTime.now(), // Tambahkan updatedAt
                                  );

                                  // Simpan data perkembangan
                                  await _perkembanganController
                                      .addPerkembangan(newPerkembangan);

                                  // Cek apakah harus kembali ke halaman home atau ke halaman sebelumnya
                                  if (widget.returnToHome == true) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                                notificationMessage:
                                                    'Data Balita berhasil disimpan!', // Kirim pesan,
                                              )),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => DetailPage(
                                    //       balitaId: widget.balitaId,
                                    //       notificationMessage:
                                    //           'Data Perkembangan berhasil disimpan!',
                                    //     ),
                                    //   ),
                                    // );
                                    Navigator.pop(context, true);
                                  }
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
