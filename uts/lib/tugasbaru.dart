import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tugasbaru(),
    );
  }
}

class Tugasbaru extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buat tugas baru',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF673AB7),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: "Judul",
                  labelStyle: TextStyle(color: Colors.grey),
                  hintText: "Masukkan judul tugas",
                ),
              ),
              const SizedBox(height: 16.0),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Tanggal",
                  labelStyle: TextStyle(color: Colors.grey),
                  hintText: "Masukkan tanggal",
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Mulai jam",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 8.0),
                        TimeSelector(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hingga jam",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 8.0),
                        TimeSelector(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  labelStyle: TextStyle(color: Colors.grey),
                  hintText: "Masukkan deskripsi tugas",
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                "Kategori",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                children: [
                  CategoryChip(label: "Tugas Kuliah", isSelected: true),
                  CategoryChip(label: "Projek"),
                  CategoryChip(label: "Jalan-jalan"),
                  CategoryChip(label: "Pekerjaan kantor"),
                  CategoryChip(label: "Freelance project"),
                  CategoryChip(label: "Catatan"),
                ],
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF673AB7),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Buat Tugas",
                    style: TextStyle(color: Colors.white),
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

class TimeSelector extends StatelessWidget {
  const TimeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "08.00 AM",
            style: TextStyle(color: Colors.black),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryChip({required this.label, this.isSelected = false, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF673AB7) : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
