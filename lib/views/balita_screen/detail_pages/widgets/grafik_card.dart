import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class PerkembanganGrafikCard extends StatelessWidget {
  final List<Map<String, dynamic>> grafikData;

  PerkembanganGrafikCard({required this.grafikData});

  @override
  Widget build(BuildContext context) {
    // Reverse the grafikData to start from the left and show the most recent data on the right
    List<Map<String, dynamic>> reversedGrafikData =
        List.from(grafikData.reversed);

    return Padding(
      padding: const EdgeInsets.only(right: 52.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250, // Tinggi kontainer untuk grafik
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: false, // Menghilangkan garis grid
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 54, // Lebar untuk teks kiri lebih besar
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    'Stunting',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.blueGrey,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              case 1:
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    'Gizi Kurang',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.blueGrey,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              case 2:
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    'Sehat',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.blueGrey,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              default:
                                return const SizedBox.shrink();
                            }
                          },
                          interval: 1,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles:
                              false, // Pastikan sisi kanan tidak menampilkan teks
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index < reversedGrafikData.length) {
                              if (index % 2 == 0) {
                                DateTime dateTime = DateTime.parse(
                                    reversedGrafikData[index]['tanggal']
                                        .toString());
                                String formattedDate =
                                    DateFormat('dd/MM').format(dateTime);
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                          interval: 1,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    minX: 0,
                    maxX: reversedGrafikData.length.toDouble() - 1,
                    minY: 0,
                    maxY: 2,
                    lineBarsData: [
                      LineChartBarData(
                        spots: reversedGrafikData.asMap().entries.map((entry) {
                          int index = entry.key;
                          String status = entry.value['status'];
                          double y = status == "Stunting/Gizi Buruk"
                              ? 0
                              : status == "Gizi Kurang"
                                  ? 1
                                  : 2;
                          return FlSpot(index.toDouble(), y);
                        }).toList(),
                        isCurved: true,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(
                          show: false, // Hilangkan titik pada garis
                        ),
                        color: Color.fromARGB(255, 34, 139,
                            34), // Mengubah warna garis menjadi hijau
                      ),
                    ],
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
