import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class KhsMahasiswa extends StatefulWidget {
  @override
  _KhsMahasiswaState createState() => _KhsMahasiswaState();
}

class _KhsMahasiswaState extends State<KhsMahasiswa> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box = GetStorage();
  String? userRole;
  String? userName;
  String? selectedTahunAkademik;
  List<Map<String, dynamic>> _transkripList = [];
  List<String> _tahunAkademikList = [];

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>?;
    userRole = arguments?['role'] ?? box.read('role');
    userName = arguments?['name'] ?? box.read('name');
    if (userRole == 'mahasiswa') {
      _fetchTahunAkademik();
    }
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    // Add a page to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("KHS Mahasiswa", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text("Nama: $userName", style: pw.TextStyle(fontSize: 16)),
              pw.Text("Periode: $selectedTahunAkademik", style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 16),
              // Table for KHS data
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text('No', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Mata Kuliah', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('SKS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Nilai', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  // Data rows for each transkrip
                  ..._getFilteredTranskrip().expand((transkrip) {
                    final mataKuliah = (transkrip['transkrip'] as List<dynamic>? ?? [])
                        .cast<Map<String, dynamic>>();
                    return mataKuliah.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final matkul = entry.value;
                      return pw.TableRow(
                        children: [
                          pw.Text(index.toString()),
                          pw.Text(matkul['mataKuliah'] ?? 'N/A'),
                          pw.Text(matkul['sks']?.toString() ?? 'N/A'),
                          pw.Text(matkul['nilai'] ?? 'N/A'),
                        ],
                      );
                    }).toList();
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                "IPK Keseluruhan: ${( _getFilteredTranskrip().fold<double>(
                  0,
                      (sum, transkrip) {
                    final mataKuliah =
                    (transkrip['transkrip'] as List<dynamic>? ?? [])
                        .cast<Map<String, dynamic>>();
                    final ips = _calculateIPS(mataKuliah);
                    return sum + ips;
                  },
                ) / (_getFilteredTranskrip().length == 0
                    ? 1
                    : _getFilteredTranskrip().length))
                    .toStringAsFixed(2)}",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF file or send it to a printer
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> _fetchTahunAkademik() async {
    try {
      final querySnapshot = await _firestore
          .collection('transkrip')
          .where('nama', isEqualTo: userName)
          .get();

      List<Map<String, dynamic>> transkripList = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      final tahunAkademikSet = transkripList
          .map((transkrip) => transkrip['tahunAkademik'] as String?)
          .toSet()
          .where((tahun) => tahun != null)
          .toList();

      setState(() {
        _transkripList = transkripList;
        _tahunAkademikList = tahunAkademikSet.cast<String>();
        if (_tahunAkademikList.isNotEmpty) {
          selectedTahunAkademik = _tahunAkademikList.first;
        }
      });
    } catch (e) {
      print("Error fetching transkrip: $e");
    }
  }

  List<Map<String, dynamic>> _getFilteredTranskrip() {
    if (selectedTahunAkademik == null) return [];
    return _transkripList
        .where((transkrip) =>
    transkrip['tahunAkademik'] == selectedTahunAkademik)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (userRole != 'mahasiswa') {
      return Scaffold(
        appBar: AppBar(title: Text("KHS")),
        body: Center(
          child: Text("Anda tidak memiliki akses ke halaman ini."),
        ),
      );
    }

    final filteredTranskrip = _getFilteredTranskrip();

    return Scaffold(
      appBar: AppBar(
        title: Text("KHS Mahasiswa"),
        backgroundColor: Colors.blue,
      ),
      body: filteredTranskrip.isEmpty
          ? Center(child: Text("Belum ada data transkrip untuk tahun akademik ini."))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown Tahun Akademik
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Periode:",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: selectedTahunAkademik,
                    hint: Text("Pilih Tahun Akademik"),
                    items: _tahunAkademikList.map((tahun) {
                      return DropdownMenuItem<String>(
                        value: tahun,
                        child: Text(tahun),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTahunAkademik = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Tabel Data Transkrip Menggunakan TableCell
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(1), // Kolom No
                  1: FlexColumnWidth(4), // Kolom Mata Kuliah
                  2: FlexColumnWidth(2), // Kolom SKS
                  3: FlexColumnWidth(2), // Kolom Nilai
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Nama Mata Kuliah",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "SKS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Nilai",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...filteredTranskrip.expand((transkrip) {
                    final mataKuliah = (transkrip['transkrip']
                    as List<dynamic>? ??
                        [])
                        .cast<Map<String, dynamic>>();
                    return mataKuliah.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final matkul = entry.value;
                      return TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                index.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(matkul['mataKuliah'] ?? 'N/A'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                matkul['sks']?.toString() ?? 'N/A',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                matkul['nilai'] ?? 'N/A',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  }).toList(),
                ],
              ),

              SizedBox(height: 16),
              Text(
                "IPK Keseluruhan: ${(filteredTranskrip.fold<double>(
                  0,
                      (sum, transkrip) {
                    final mataKuliah =
                    (transkrip['transkrip'] as List<dynamic>? ?? [])
                        .cast<Map<String, dynamic>>();
                    final ips = _calculateIPS(mataKuliah);
                    return sum + ips;
                  },
                ) / (filteredTranskrip.length == 0
                    ? 1
                    : filteredTranskrip.length))
                    .toStringAsFixed(2)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: _generatePdf, // Call the function to generate and print the PDF
                child: Text("Cetak KHS"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateIPS(List<Map<String, dynamic>> mataKuliah) {
    if (mataKuliah.isEmpty) return 0.0;

    double totalBobotNilai = 0.0;
    int totalSKS = 0;

    for (var matkul in mataKuliah) {
      int sks = matkul['sks'] ?? 0;
      double bobotNilai = _convertNilaiToBobot(matkul['nilai'] ?? 'E');
      totalBobotNilai += bobotNilai * sks;
      totalSKS += sks;
    }

    return totalSKS == 0 ? 0.0 : totalBobotNilai / totalSKS;
  }

  double _convertNilaiToBobot(String nilai) {
    switch (nilai.toUpperCase()) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      case 'E':
        return 0.0;
      default:
        return 0.0;
    }
  }
}
