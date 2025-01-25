import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TambahKrsDosen extends StatefulWidget {
  @override
  _TambahKrsDosenState createState() => _TambahKrsDosenState();
}

class _TambahKrsDosenState extends State<TambahKrsDosen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _mataKuliahController = TextEditingController();
  final TextEditingController _sksController = TextEditingController();
  final TextEditingController _dosenController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _ruangController = TextEditingController();
  final TextEditingController _tahunAkademikController = TextEditingController();
  final TextEditingController _kuotaController = TextEditingController();

  List<Map<String, dynamic>> _mataKuliahList = [];

  @override
  void initState() {
    super.initState();
    _fetchMataKuliah();
  }

  /// Fungsi untuk mengambil data mata kuliah dari Firestore
  Future<void> _fetchMataKuliah() async {
    final mataKuliahQuery = await _firestore.collection('mataKuliah').get();
    setState(() {
      _mataKuliahList = mataKuliahQuery.docs
          .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    });
  }

  /// Fungsi untuk menambahkan mata kuliah ke Firestore
  Future<void> _addMataKuliah() async {
    if (_kodeController.text.isEmpty ||
        _mataKuliahController.text.isEmpty ||
        _sksController.text.isEmpty ||
        _dosenController.text.isEmpty ||
        _kelasController.text.isEmpty ||
        _ruangController.text.isEmpty ||
        _tahunAkademikController.text.isEmpty ||
        _kuotaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Semua field harus diisi!")),
      );
      return;
    }

    final newMataKuliah = {
      "kode": _kodeController.text,
      "mataKuliah": _mataKuliahController.text,
      "sks": int.parse(_sksController.text),
      "dosen": _dosenController.text,
      "kelas": _kelasController.text,
      "ruang": _ruangController.text,
      "tahunAkademik": _tahunAkademikController.text,
      "batasWaktu": null,  // Tidak perlu batas waktu, simpan null atau hapus
      "kuota": int.parse(_kuotaController.text),
      "jumlahTerambil": 0, // Awalnya 0, akan diperbarui saat ada mahasiswa yang mengambil
    };

    await _firestore.collection('mataKuliah').add(newMataKuliah);

    _kodeController.clear();
    _mataKuliahController.clear();
    _sksController.clear();
    _dosenController.clear();
    _kelasController.clear();
    _ruangController.clear();
    _tahunAkademikController.clear();
    _kuotaController.clear();

    // Refresh daftar mata kuliah setelah menambahkan
    _fetchMataKuliah();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Mata kuliah berhasil ditambahkan!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Mata Kuliah"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tambah Mata Kuliah",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextField(
                controller: _kodeController,
                decoration: InputDecoration(labelText: "Kode Mata Kuliah"),
              ),
              TextField(
                controller: _mataKuliahController,
                decoration: InputDecoration(labelText: "Nama Mata Kuliah"),
              ),
              TextField(
                controller: _sksController,
                decoration: InputDecoration(labelText: "SKS"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _dosenController,
                decoration: InputDecoration(labelText: "Nama Dosen"),
              ),
              TextField(
                controller: _kelasController,
                decoration: InputDecoration(labelText: "Kelas"),
              ),
              TextField(
                controller: _ruangController,
                decoration: InputDecoration(labelText: "Ruang"),
              ),
              TextField(
                controller: _tahunAkademikController,
                decoration: InputDecoration(labelText: "Tahun Akademik"),
              ),
              // Hapus bagian Batas Waktu
              // TextField(
              //   controller: _batasWaktuController,
              //   decoration: InputDecoration(labelText: "Batas Waktu (yyyy-mm-dd)"),
              // ),
              TextField(
                controller: _kuotaController,
                decoration: InputDecoration(labelText: "Kuota"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addMataKuliah,
                child: Text("Tambah Mata Kuliah"),
              ),
              Divider(height: 24, thickness: 2),

              // Daftar Mata Kuliah
              Text(
                "Daftar Mata Kuliah",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              _mataKuliahList.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Belum ada mata kuliah yang ditambahkan."),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _mataKuliahList.length,
                itemBuilder: (context, index) {
                  final mataKuliah = _mataKuliahList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(mataKuliah['mataKuliah']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kode: ${mataKuliah['kode']}"),
                          Text("SKS: ${mataKuliah['sks']}"),
                          Text("Dosen: ${mataKuliah['dosen']}"),
                          Text("Kelas: ${mataKuliah['kelas']}"),
                          Text("Ruang: ${mataKuliah['ruang']}"),
                          Text("Tahun Akademik: ${mataKuliah['tahunAkademik']}"),
                          // Hapus batas waktu dari tampilan
                          // Text("Batas Waktu: ${mataKuliah['batasWaktu'] != null ? mataKuliah['batasWaktu'].toDate().toString() : 'Tidak ada batas waktu'}"),
                          Text("Kuota: ${mataKuliah['kuota']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
