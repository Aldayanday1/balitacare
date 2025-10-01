import 'package:aplikasibalita/models/balita.dart';
import 'package:aplikasibalita/views/balita_screen/detail_pages/detail_page.dart';
import 'package:aplikasibalita/views/balita_screen/edit_balita_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart'; // Untuk format tanggal

class BalitaCard extends StatefulWidget {
  final Balita balita;
  final Function onUpdate;
  final Function onDelete;
  final Function onUpdateStatusCounts; // Tambahkan callback baru

  const BalitaCard({
    Key? key,
    required this.balita,
    required this.onUpdate,
    required this.onDelete,
    required this.onUpdateStatusCounts, // Tambahkan ke constructor
  }) : super(key: key);

  @override
  State<BalitaCard> createState() => _BalitaCardState();
}

class _BalitaCardState extends State<BalitaCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.balita.id.toString()), // Kunci unik untuk setiap balita
      background: slideRightBackground(), // Geser kanan (edit)
      secondaryBackground: slideLeftBackground(), // Geser kiri (hapus)
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Jika geser ke kanan, lakukan edit
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditBalitaScreen(balita: widget.balita),
            ),
          ).then((_) => widget.onUpdate());
          return false; // Mencegah kartu dari penghapusan otomatis
        } else if (direction == DismissDirection.endToStart) {
          // Jika geser ke kiri, lakukan hapus
          bool? confirmDelete = await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Konfirmasi Hapus',
            text: 'Apakah Anda yakin ingin menghapus data Balita ini?',
            confirmBtnText: 'Hapus',
            cancelBtnText: 'Batal',
            confirmBtnColor: Colors.white, // Warna tombol Hapus
            confirmBtnTextStyle: TextStyle(
                color: Color.fromARGB(255, 156, 39, 39),
                fontWeight: FontWeight.w100, // Menambahkan teks tebal
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

          if (confirmDelete == true) {
            await widget.onDelete();
            return true; // Mengizinkan kartu dihapus
          }
          return false; // Mencegah penghapusan jika batal
        }
        return false; // Defaultnya mencegah penghapusan
      },
      child: GestureDetector(
        onTap: () async {
          final update = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(balitaId: widget.balita.id!),
            ),
          );
          if (update == true) {
            // Perbarui status count setelah kembali dari DetailPage
            widget.onUpdate(); // Memperbarui data balita
            widget.onUpdateStatusCounts(); // Memperbarui statusCounts
          }
        },
        child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: 7, vertical: 5), // Margin luar
          decoration: BoxDecoration(
            color: Colors.white, // Warna putih kartu
            borderRadius: BorderRadius.circular(15), // Sudut melengkung
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15), // Warna bayangan lembut
                spreadRadius: 1, // Seberapa jauh bayangan menyebar
                blurRadius: 10, // Seberapa kabur bayangan
                offset: Offset(0, 5), // Penempatan bayangan
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15), // Jarak dalam
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Balita (Title)
                Text(
                  widget.balita.nama,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins', // Menggunakan font Roboto
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1, // Membatasi menjadi satu baris
                  overflow: TextOverflow
                      .ellipsis, // Menampilkan "..." jika teks terlalu panjang
                  softWrap: false, // Tidak membungkus ke baris berikutnya
                ),
                SizedBox(height: 8),
                // Tanggal dibuat
                Text(
                  widget.balita.createdAt != null
                      ? DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(widget.balita.createdAt!)
                      : 'Tanggal tidak tersedia',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: 'Poppins'),
                ),
                Divider(thickness: 1, color: Colors.grey[300]), // Pembatas
                SizedBox(height: 8),
                // NIK
                Row(
                  children: [
                    Icon(Icons.credit_card,
                        size: 16, color: Colors.grey), // Ikon NIK
                    SizedBox(width: 8),
                    Text(
                      'NIK:',
                      style: TextStyle(
                          color: Colors.black54, fontFamily: 'Poppins'),
                    ),
                    SizedBox(width: 5),
                    Text(
                      widget.balita.nik ?? 'NIK belum terisi',
                      style: TextStyle(
                        fontStyle: widget.balita.nik == null
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: widget.balita.nik == null
                            ? Colors.redAccent
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Tanggal Lahir
                Row(
                  children: [
                    Icon(Icons.cake,
                        size: 16, color: Colors.grey), // Ikon Tanggal Lahir
                    SizedBox(width: 8),
                    Text(
                      'Tanggal Lahir:',
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Poppins',
                          fontSize: 13),
                    ),
                    SizedBox(width: 5),
                    Text(
                      widget.balita.tanggalLahir
                          .toLocal()
                          .toString()
                          .split(' ')[0],
                      style: TextStyle(color: Colors.black87),
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

  // Background saat geser ke kanan (untuk edit)
  Widget slideRightBackground() {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 10), // Margin untuk posisi vertical
      width: 100, // Lebar background geser kanan
      height: 20, // Tinggi background geser kanan
      color: Colors.blueAccent,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(30), // Padding untuk konten
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Background saat geser ke kiri (untuk hapus)
  Widget slideLeftBackground() {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 10), // Margin untuk posisi vertical
      width: 100, // Lebar background geser kiri
      height: 20, // Tinggi background geser kiri
      color: Colors.redAccent,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(30), // Padding untuk konten
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.delete, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
