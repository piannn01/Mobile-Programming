import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TambahTranskripDosen extends StatefulWidget {
  @override
  _TambahTranskripDosenState createState() => _TambahTranskripDosenState();
}

class _TambahTranskripDosenState extends State<TambahTranskripDosen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedMahasiswa;
  String? _tahunAkademik;
  final TextEditingController _mataKuliahController = TextEditingController();
  final TextEditingController _sksController = TextEditingController();
  final TextEditingController _nilaiController = TextEditingController();
  final List<Map<String, dynamic>> _transkripList = [];
  List<String> _mahasiswaList = [];
  List<Map<String, dynamic>> _savedDataList = [];

  Future<void> _fetchMahasiswaList() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'mahasiswa')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("Tidak ada mahasiswa dengan role 'mahasiswa'.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tidak ada mahasiswa yang ditemukan.")),
        );
        return;
      }

      List<String> mahasiswaList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        if (data.containsKey('name') && data['name'] is String) {
          return data['name'] as String;
        } else {
          print("Dokumen tidak memiliki field 'name': ${doc.id}");
          return "Tidak Ada Nama";
        }
      }).toList();

      setState(() {
        _mahasiswaList = mahasiswaList;
      });
    } catch (e) {
      print("Error fetching mahasiswa list: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat daftar mahasiswa.")),
      );
    }
  }

  Future<void> _fetchSavedDataList() async {
    try {
      final querySnapshot = await _firestore
          .collection('transkrip')
          .orderBy('timestamp', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _savedDataList = querySnapshot.docs.map((doc) => doc.data()).toList();
        });
      }
    } catch (e) {
      print("Error fetching saved data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat detail transkrip.")),
      );
    }
  }

  void _addToList() {
    if (_mataKuliahController.text.isEmpty ||
        _sksController.text.isEmpty ||
        _nilaiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Semua field harus diisi!")),
      );
      return;
    }

    setState(() {
      _transkripList.add({
        "mataKuliah": _mataKuliahController.text,
        "sks": int.parse(_sksController.text),
        "nilai": _nilaiController.text,
      });
      _mataKuliahController.clear();
      _sksController.clear();
      _nilaiController.clear();
    });
  }

  Future<void> _saveTranskrip() async {
    if (_selectedMahasiswa == null || _tahunAkademik == null || _transkripList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pilih mahasiswa, tahun akademik, dan tambahkan data transkrip!")),
      );
      return;
    }

    final newTranskrip = {
      "nama": _selectedMahasiswa,
      "tahunAkademik": _tahunAkademik,
      "transkrip": List<Map<String, dynamic>>.from(_transkripList),
      "timestamp": FieldValue.serverTimestamp(),
    };

    try {
      await _firestore.collection('transkrip').add(newTranskrip);

      setState(() {
        _transkripList.clear();
        _selectedMahasiswa = null;
        _tahunAkademik = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transkrip berhasil ditambahkan!")),
      );
    } catch (e) {
      print("Error saving transkrip: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan transkrip.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMahasiswaList();
    _fetchSavedDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Transkrip Nilai"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedMahasiswa,
                hint: Text("Pilih Mahasiswa"),
                onChanged: (value) {
                  setState(() {
                    _selectedMahasiswa = value;
                  });
                },
                items: _mahasiswaList
                    .map((mahasiswa) => DropdownMenuItem(
                  value: mahasiswa,
                  child: Text(mahasiswa),
                ))
                    .toList(),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Tahun Akademik"),
                onChanged: (value) {
                  _tahunAkademik = value;
                },
              ),
              TextField(
                controller: _mataKuliahController,
                decoration: InputDecoration(labelText: "Mata Kuliah"),
              ),
              TextField(
                controller: _sksController,
                decoration: InputDecoration(labelText: "Jumlah SKS"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _nilaiController,
                decoration: InputDecoration(labelText: "Nilai"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addToList,
                child: Text("Tambahkan Ke Daftar"),
              ),
              SizedBox(height: 16),
              if (_transkripList.isNotEmpty) ...[
                Text(
                  "Daftar Transkrip yang Ditambahkan:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Table(
                  border: TableBorder.all(),
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text("Nmr", textAlign: TextAlign.center),
                        Text("Mata Kuliah", textAlign: TextAlign.center),
                        Text("SKS", textAlign: TextAlign.center),
                        Text("Nilai", textAlign: TextAlign.center),
                      ],
                    ),
                    ..._transkripList.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final matkul = entry.value;
                      return TableRow(
                        children: [
                          Text(index.toString(), textAlign: TextAlign.center),
                          Text(matkul['mataKuliah'], textAlign: TextAlign.center),
                          Text(matkul['sks'].toString(), textAlign: TextAlign.center),
                          Text(matkul['nilai'], textAlign: TextAlign.center),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTranskrip,
                child: Text("Tambah Transkrip"),
              ),
              SizedBox(height: 16),
              Text(
                "Detail Semua Transkrip yang Tersimpan:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ..._savedDataList.map((data) {
                final transkrip = data['transkrip'] as List? ?? [];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tahun Akademik: ${data['tahunAkademik'] ?? 'Tidak Diketahui'}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Nama Mahasiswa: ${data['nama'] ?? 'Tidak Diketahui'}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            children: [
                              Text("No", textAlign: TextAlign.center),
                              Text("Mata Kuliah", textAlign: TextAlign.center),
                              Text("SKS", textAlign: TextAlign.center),
                              Text("Nilai", textAlign: TextAlign.center),
                            ],
                          ),
                          ...transkrip.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final matkul = entry.value as Map<String, dynamic>;
                            return TableRow(
                              children: [
                                Text(index.toString(), textAlign: TextAlign.center),
                                Text(matkul['mataKuliah'] ?? 'N/A', textAlign: TextAlign.center),
                                Text(matkul['sks']?.toString() ?? 'N/A', textAlign: TextAlign.center),
                                Text(matkul['nilai'] ?? 'N/A', textAlign: TextAlign.center),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
