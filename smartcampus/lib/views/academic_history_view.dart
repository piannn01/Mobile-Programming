import 'package:flutter/material.dart';

class AcademicHistoryView extends StatelessWidget {
  final List<Map<String, dynamic>> academicHistory = [
    {
      'semester': 'Semester 1',
      'year': '2022/2023',
      'courses': [
        {'name': 'Introduction to Programming', 'grade': 'A'},
        {'name': 'Advanced Mathematics', 'grade': 'B+'},
      ],
    },
    {
      'semester': 'Semester 2',
      'year': '2022/2023',
      'courses': [
        {'name': 'Data Structures and Algorithms', 'grade': 'A-'},
        {'name': 'Database Systems', 'grade': 'B'},
      ],
    },
    {
      'semester': 'Semester 3',
      'year': '2023/2024',
      'courses': [
        {'name': 'Operating Systems', 'grade': 'A'},
        {'name': 'Computer Networks', 'grade': 'B+'},
      ],
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Akademik'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: academicHistory.length,
        itemBuilder: (context, index) {
          final history = academicHistory[index];
          final courses = history['courses'] as List<Map<String, String>>;
          return Card(
            color: Colors.primaries[index % Colors.primaries.length].shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        history['semester'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        history['year'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  ...courses.map((course) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          course['name'] ?? 'kosong',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          course['grade'] ?? '-',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
