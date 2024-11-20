import 'package:flutter/material.dart';

class CreateSchedule extends StatefulWidget {
  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  String _startPeriod = 'AM';
  String _endPeriod = 'PM';
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedCategory;

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  final List<String> _categories = [
    'Tugas Kuliah',
    'Projek',
    'Jalan-jalan',
    'Pekerjaan kantor',
    'Freelance project',
    'Catatan',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text(
          'Buat Tugas Baru',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Judul',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return _buildCategoryBottomSheet(screenWidth);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBottomSheet(double screenWidth) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 35, 20, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Waktu Mulai
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTime(context, true),
                          child: _buildTimeInput(
                            label: 'Mulai jam',
                            time: _startTime,
                            period: _startPeriod,
                            onPeriodChange: (value) {
                              setModalState(() {
                                _startPeriod = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 70),
                      // Waktu Selesai
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTime(context, false),
                          child: _buildTimeInput(
                            label: 'Hingga jam',
                            time: _endTime,
                            period: _endPeriod,
                            onPeriodChange: (value) {
                              setModalState(() {
                                _endPeriod = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Deskripsi', style: TextStyle(color: Colors.grey)),
                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Kategori',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: _categories.map((category) {
                      final bool isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.deepPurple
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(screenWidth * 0.8, 40),
                      ),
                      child: Text('Buat Tugas'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeInput({
    required String label,
    required TimeOfDay? time,
    required String period,
    required Function(String?) onPeriodChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  time != null
                      ? time.format(context).split(' ')[0]
                      : '08.00',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              DropdownButton<String>(
                value: period,
                items: ['AM', 'PM']
                    .map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p),
                ))
                    .toList(),
                onChanged: onPeriodChange,
                underline: SizedBox(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
