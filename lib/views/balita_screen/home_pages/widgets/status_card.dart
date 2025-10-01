import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String status;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const StatusCard({
    Key? key,
    required this.status,
    required this.count,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  IconData _getIconForStatus(String status) {
    switch (status) {
      case 'Sehat':
        return Icons.health_and_safety; // Ikon kesehatan
      case 'Gizi Kurang':
        return Icons.warning_amber_rounded; // Ikon peringatan untuk gizi kurang
      case 'Stunting/Gizi Buruk':
        return Icons.error; // Ikon peringatan serius untuk stunting/gizi buruk
      default:
        return Icons.help_outline; // Ikon default jika status tidak dikenal
    }
  }

  Color _getBackgroundColorForStatus(String status) {
    switch (status) {
      case 'Sehat':
        return Colors.white; // Hijau cerah
      case 'Gizi Kurang':
        return Colors.white; // Kuning cerah
      case 'Stunting':
        return Colors.white; // Merah cerah (misal #FFF4F4)
      default:
        return Colors.white; // Warna default jika status tidak dikenal
    }
  }

  // Color _getBackgroundColorForStatus(String status) {
  //   switch (status) {
  //     case 'Sehat':
  //       return Color(0xFFE8F5E9); // Hijau cerah
  //     case 'Gizi Kurang':
  //       return Color(0xFFFFF9C4); // Kuning cerah
  //     case 'Stunting':
  //       return Color(0xFFFFF4F4); // Merah cerah (misal #FFF4F4)
  //     default:
  //       return Colors.white; // Warna default jika status tidak dikenal
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 98,
          height: 100,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: _getBackgroundColorForStatus(status)
                .withOpacity(0.8), // Warna terang dengan transparansi
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              // BoxShadow(
              //   // color: Colors.black12,
              //   // blurRadius: 10,
              //   // offset: Offset(0, 5),
              // ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _getIconForStatus(status),
                    color: color, // Warna ikon sesuai status
                    size: 24,
                  ),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Poppins', // Menggunakan font Roboto
                      fontWeight: FontWeight.w400,
                      color: color, // Warna teks sesuai status
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontFamily: 'Poppins', // Menggunakan font Roboto
                    fontWeight: FontWeight.normal,
                    color: Colors
                        .grey[700], // Tetap menggunakan warna teks yang jelas
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
