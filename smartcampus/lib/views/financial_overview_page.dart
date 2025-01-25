import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancialOverviewPage extends StatelessWidget {
  final int dailySales = 150000; // Contoh total penjualan harian
  final List<Map<String, dynamic>> popularItems = [
    {'name': 'FST', 'Rp': 4700000},
    {'name': 'FIK', 'Rp': 7000000},
    {'name': 'FAI', 'Rp': 3000000},
    {'name': 'FBBP', 'Rp': 4000000},
  ];

  final List<Map<String, dynamic>> revenueData = [
    {'period': 'FIK', 'revenue': 450},
    {'period': 'FAI', 'revenue': 300},
    {'period': 'FBBP', 'revenue': 350},
    {'period': 'FST', 'revenue': 440},
  ];

  final List<Map<String, dynamic>> ratings = [
    {'rating': 4.5, 'count': 100},
    {'rating': 4.0, 'count': 50},
    {'rating': 3.5, 'count': 20},
    {'rating': 3.0, 'count': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Overview'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Sales
            Card(
              elevation: 4,
              child: ListTile(
                title: Text('Jumlah Pembayaran'),
                subtitle: Text('Rp $dailySales'),
                leading: Icon(Icons.account_box, color: Colors.green),
              ),
            ),
            SizedBox(height: 16),

            // Popular Items
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jumlah Pembayaran/Fakultas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: popularItems
                          .map((item) => ListTile(
                        title: Text(item['name']),
                        trailing: Text('Rp ${item['Rp']}'),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Pelaporan
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grafik Pembayaran/Fakultas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          barGroups: revenueData
                              .asMap()
                              .entries
                              .map((entry) => BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value['revenue']/100,
                                color: Colors.blue,
                                width: 16,
                              ),
                            ],
                          ))
                              .toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: TextStyle(fontSize: 12),
                                  );
                                },
                                reservedSize: 40,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    revenueData[value.toInt()]['period'],
                                    style: TextStyle(fontSize: 12),
                                  );
                                },
                                reservedSize: 32,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              left: BorderSide(color: Colors.grey, width: 1),
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Rating Overview
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ulasan Mahasiswa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: ratings
                          .map((rating) => ListTile(
                        title: Text('Rating ${rating['rating']} ⭐️'),
                        trailing: Text('${rating['count']} ulasan'),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}