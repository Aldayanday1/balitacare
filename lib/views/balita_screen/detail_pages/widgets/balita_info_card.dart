// import 'package:aplikasibalita/models/balita.dart';
// import 'package:aplikasibalita/views/balita_screen/detail_page.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class BalitaInfoCard extends StatelessWidget {
//   final Balita balita;

//   BalitaInfoCard({required this.balita});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             InfoRow(label: 'NIK', value: balita.nik ?? 'N/A'),
//             InfoRow(
//               label: 'Tanggal Lahir',
//               value: balita.tanggalLahir.toLocal().toString().split(' ')[0],
//             ),
//             InfoRow(
//               label: 'Jenis Kelamin',
//               value: balita.jenisKelamin,
//             ),
//             InfoRow(
//               label: 'Nama Orang Tua',
//               value: balita.namaOrangTua,
//             ),
//             InfoRow(
//               label: 'Berat Badan Lahir',
//               value: '${balita.beratBadanLahir} kg',
//             ),
//             InfoRow(
//               label: 'Tinggi Badan Lahir',
//               value: '${balita.tinggiBadanLahir} cm',
//             ),
//             InfoRow(
//               label: 'Dibuat Pada',
//               value: balita.createdAt != null
//                   ? DateFormat('yyyy-MM-dd HH:mm:ss').format(balita.createdAt!)
//                   : 'Tanggal tidak tersedia',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class InfoRow extends StatelessWidget {
//   final String label;
//   final String value;

//   InfoRow({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontWeight: FontWeight.w500),
//           ),
//           Text(value),
//         ],
//       ),
//     );
//   }
// }