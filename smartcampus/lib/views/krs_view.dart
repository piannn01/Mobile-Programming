import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AmbilKrsMahasiswa extends StatefulWidget {
  @override
  _AmbilKrsMahasiswaState createState() => _AmbilKrsMahasiswaState();
}

class _AmbilKrsMahasiswaState extends State<AmbilKrsMahasiswa> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  List<Map<String, dynamic>> _mataKuliahList = [];
  List<Map<String, dynamic>> _filteredMataKuliahList = [];
  List<Map<String, dynamic>> _krsList = [];
  List<String> _tahunAkademikList = [];
  String? _selectedTahunAkademik;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchKRS();
    _listenMataKuliah(); // Menggunakan StreamBuilder untuk real-time
  }

  Future<void> _getCurrentUser() async {
    _currentUser = _auth.currentUser;
  }

  void _listenMataKuliah() {
    _firestore.collection('mataKuliah').snapshots().listen((snapshot) {
      final mataKuliahData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          "id": doc.id,
          ...data,
          "jumlahTerambil": data["jumlahTerambil"] ?? 0,
        };
      }).toList();

      final tahunAkademikSet = mataKuliahData
          .map((e) => e['tahunAkademik'] as String)
          .toSet()
          .toList();

      setState(() {
        _mataKuliahList = mataKuliahData;
        _filteredMataKuliahList = mataKuliahData;
        _tahunAkademikList = tahunAkademikSet;
      });
    });
  }

  Future<void> _fetchKRS() async {
    if (_currentUser != null) {
      final krsQuery = await _firestore
          .collection('krs')
          .where('uid', isEqualTo: _currentUser!.uid)
          .get();

      final krsData = await Future.wait(
        krsQuery.docs.map((doc) async {
          if (!doc.data().containsKey('mataKuliahId')) {
            return null;
          }

          final mataKuliahRef = await _firestore
              .collection('mataKuliah')
              .doc(doc['mataKuliahId'])
              .get();

          return {
            "id": doc.id,
            ...doc.data() as Map<String, dynamic>,
            "mataKuliahDetail": mataKuliahRef.data() as Map<String, dynamic>?,
          };
        }).where((e) => e != null).toList(),
      ).then((list) => list.cast<Map<String, dynamic>>());

      setState(() {
        _krsList = krsData;
      });
    }
  }

  Future<void> _ambilKRS(Map<String, dynamic> mataKuliah) async {
    if (_currentUser == null) return;

    try {
      print("Kuota sebelum: ${mataKuliah['jumlahTerambil']}, Maks: ${mataKuliah['kuota']}");

      // Pastikan kuota belum penuh
      if (mataKuliah['jumlahTerambil'] >= mataKuliah['kuota']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kuota mata kuliah sudah penuh!")),
        );
        return;
      }

      // Menjalankan transaksi untuk memastikan konsistensi data
      await _firestore.runTransaction((transaction) async {
        final mataKuliahDoc = _firestore.collection('mataKuliah').doc(mataKuliah['id']);
        final snapshot = await transaction.get(mataKuliahDoc);

        if (snapshot.exists) {
          final jumlahTerambil = snapshot.data()?['jumlahTerambil'] ?? 0;
          final kuota = snapshot.data()?['kuota'] ?? 0;

          // Cek jika kuota masih tersedia
          if (jumlahTerambil >= kuota) {
            throw Exception("Kuota penuh.");
          }

          // Update jumlah terambil dan kuota di Firestore
          final updatedJumlahTerambil = jumlahTerambil + 1;
          final updatedKuota = kuota - 1; // Decrease kuota when a student takes the course
          transaction.update(mataKuliahDoc, {
            'jumlahTerambil': updatedJumlahTerambil,
            'kuota': updatedKuota, // Update the kuota as well
          });

          // Tambahkan ke KRS
          final newKRS = {
            "uid": _currentUser!.uid,
            "mataKuliahId": mataKuliah['id'],
          };
          await _firestore.collection('krs').add(newKRS);
        } else {
          throw Exception("Mata kuliah tidak ditemukan.");
        }
      });

      print("Kuota berhasil diperbarui untuk ID: ${mataKuliah['id']}");

      // Memperbarui daftar KRS setelah berhasil mengambil mata kuliah
      await _fetchKRS();

      // Memuat ulang data mata kuliah setelah kuota diperbarui
      _listenMataKuliah();  // Memastikan data mata kuliah yang terbaru dimuat

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mata kuliah berhasil diambil!")),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan, coba lagi nanti!")),
      );
    }
  }

  void _filterMataKuliah() {
    setState(() {
      if (_selectedTahunAkademik != null) {
        _filteredMataKuliahList = _mataKuliahList
            .where((mk) => mk['tahunAkademik'] == _selectedTahunAkademik)
            .toList();
      } else {
        _filteredMataKuliahList = _mataKuliahList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ambil KRS Mahasiswa"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pilih Tahun Akademik",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              DropdownButton<String>(
                value: _selectedTahunAkademik,
                hint: Text("Pilih Tahun Akademik"),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTahunAkademik = newValue;
                    _filterMataKuliah();
                  });
                },
                items: _tahunAkademikList
                    .map<DropdownMenuItem<String>>(
                      (tahun) => DropdownMenuItem<String>(
                    value: tahun,
                    child: Text(tahun),
                  ),
                )
                    .toList(),
              ),
              Divider(height: 24, thickness: 2),
              Text(
                "Mata Kuliah Tersedia",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              _filteredMataKuliahList.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Belum ada mata kuliah yang tersedia."),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredMataKuliahList.length,
                itemBuilder: (context, index) {
                  final mataKuliah = _filteredMataKuliahList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(mataKuliah['mataKuliah']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kode: ${mataKuliah['kode']}"),
                          Text("Kuota: ${mataKuliah['kuota']}"),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _ambilKRS(mataKuliah),
                        child: Text("Ambil"),
                      ),
                    ),
                  );
                },
              ),
              Divider(height: 24, thickness: 2),
              Text(
                "KRS yang Telah Diambil",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              _krsList.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Belum ada mata kuliah yang diambil."),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _krsList.length,
                itemBuilder: (context, index) {
                  final krs = _krsList[index];
                  final mataKuliahDetail = krs['mataKuliahDetail'];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  mataKuliahDetail?['kode'] ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Text(
                                  mataKuliahDetail?['mataKuliah'] ?? '',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "SKS: ${mataKuliahDetail?['sks'] ?? ''}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Kelas: ${mataKuliahDetail?['kelas'] ?? ''}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Dosen: ${mataKuliahDetail?['dosen'] ?? ''}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Ruang: ${mataKuliahDetail?['ruang'] ?? ''}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
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
