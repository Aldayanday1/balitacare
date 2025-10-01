import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'custom_chart.dart' as custom_chart;
import 'package:aplikasibalita/models/bar_chart_data.dart' as custom_chart;

class BalitaBarChart extends StatelessWidget {
  final Future<Map<String, int>> balitaCountPerMonthFuture;
  final bool isVisible;

  const BalitaBarChart({
    Key? key,
    required this.balitaCountPerMonthFuture,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35, top: 10, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.child_care,
                  size: 20,
                  color: Color.fromARGB(255, 132, 158, 165),
                ),
                SizedBox(width: 8),
                Text(
                  "Jumlah Data Balita Per Bulan",
                  style: TextStyle(
                    fontSize: 12.2,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<Map<String, int>>(
            future: balitaCountPerMonthFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final balitaCountLast6Months = snapshot.data!;
                List<custom_chart.BarChartData> chartData =
                    balitaCountLast6Months.entries
                        .map((entry) => custom_chart.BarChartData(
                              month: entry.key,
                              count: entry.value,
                            ))
                        .toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelRotation:
                          15, // Rotasi label bulan untuk kesesuaian ruang
                      edgeLabelPlacement: EdgeLabelPlacement
                          .shift, // Agar label tidak terpotong
                      majorGridLines: MajorGridLines(
                          width: 0), // Menghilangkan gridlines besar
                      minorGridLines: MinorGridLines(
                          width: 0), // Menghilangkan gridlines kecil
                      axisLine:
                          AxisLine(width: 0), // Menghilangkan garis sumbu X
                      labelStyle: TextStyle(
                          fontSize: 12), // Ukuran font untuk label bulan
                      majorTickLines: MajorTickLines(
                          size:
                              0), // Menghilangkan garis kecil di bawah label X
                    ),
                    primaryYAxis: NumericAxis(
                      axisLine:
                          AxisLine(width: 0), // Menghilangkan garis sumbu Y
                      majorGridLines: MajorGridLines(
                          width: 0), // Menghilangkan gridlines besar
                      minorGridLines: MinorGridLines(
                          width: 0), // Menghilangkan gridlines kecil
                      labelStyle: TextStyle(
                          fontSize: 12), // Ukuran font untuk angka pada Y
                      majorTickLines: MajorTickLines(
                          size:
                              0), // Menghilangkan garis kecil di samping angka Y
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries>[
                      ColumnSeries<custom_chart.BarChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (custom_chart.BarChartData data, _) =>
                            data.month,
                        yValueMapper: (custom_chart.BarChartData data, _) =>
                            data.count,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(
                              color: Colors.white), // Warna teks data label
                        ),
                        color:
                            Color.fromARGB(255, 132, 158, 165), // Warna batang
                        borderRadius: BorderRadius.all(Radius.circular(
                            5)), // Batang dengan sudut melengkung
                        width: 0.3, // Lebar batang
                        onPointTap: (ChartPointDetails details) {
                          // Interaksi saat mengetuk batang
                        },
                      ),
                    ],
                    backgroundColor: Colors.white, // Latar belakang chart
                    borderWidth: 0, // Menghilangkan border di sekitar chart
                    borderColor:
                        Colors.transparent, // Menghilangkan warna border
                    plotAreaBorderWidth:
                        0, // Menghilangkan garis pembatas plot area
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
