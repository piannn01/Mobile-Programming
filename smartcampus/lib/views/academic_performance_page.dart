import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// save
class AcademicPerformancePage extends StatelessWidget {
  final List<Map<String, dynamic>> allUserData = [
    {'name': 'User 1', 'role': 'mahasiswa', 'fakultas': 'FST', 'ipk': 3.8},
    {'name': 'User 2', 'role': 'mahasiswa', 'fakultas': 'FIK', 'ipk': 3.6},
    {'name': 'User 3', 'role': 'staff', 'fakultas': 'FAI', 'ipk': 3.9},
    {'name': 'User 4', 'role': 'mahasiswa', 'fakultas': 'FBBP', 'ipk': 3.5},
    {'name': 'User 5', 'role': 'mahasiswa', 'fakultas': 'FST', 'ipk': 3.9},
  ];

  @override
  Widget build(BuildContext context) {
    // Filter data untuk user dengan role "mahasiswa"
    final List<Map<String, dynamic>> mahasiswaData = allUserData
        .where((user) => user['role'] == 'mahasiswa')
        .toList();

    // Kelompokkan data mahasiswa berdasarkan fakultas
    final Map<String, Map<String, dynamic>> groupedData = {};
    for (var user in mahasiswaData) {
      final fakultas = user['fakultas'];
      if (!groupedData.containsKey(fakultas)) {
        groupedData[fakultas] = {
          'fakultas': fakultas,
          'mhs': 0,
          'totalIpk': 0.0,
        };
      }
      groupedData[fakultas]!['mhs'] += 1;
      groupedData[fakultas]!['totalIpk'] += user['ipk'];
    }

    // Konversi hasil grup ke daftar dan hitung rata-rata IPK
    final List<Map<String, dynamic>> ipkData = groupedData.values.map((data) {
      data['ipk'] = data['totalIpk'] / data['mhs'];
      return data;
    }).toList();

    // Urutkan berdasarkan IPK
    ipkData.sort((a, b) => b['ipk'].compareTo(a['ipk']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Performance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Card
            Card(
              elevation: 4,
              child: ListTile(
                title: const Text('Jumlah Mahasiswa Berdasarkan IPK'),
                subtitle: const Text('Diurutkan dari IPK tertinggi ke terendah'),
                leading: const Icon(Icons.school, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),

            // List of Faculties with IPK Data
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rata-rata IPK Mahasiswa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: ipkData
                          .map(
                            (item) => ListTile(
                          subtitle: Text('Rata-rata IPK: ${item['ipk'].toStringAsFixed(2)}'),
                          trailing: Text('${item['mhs']} Mhs'),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bar Chart
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Grafik IPK Mahasiswa/Fakultas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          barGroups: ipkData
                              .asMap()
                              .entries
                              .map(
                                (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value['ipk'],
                                  color: Colors.blue,
                                  width: 16,
                                ),
                              ],
                            ),
                          )
                              .toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toStringAsFixed(1)}',
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                                reservedSize: 40,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    ipkData[value.toInt()]['fakultas'],
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                                reservedSize: 32,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
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
          ],
        ),
      ),
    );
  }
}
