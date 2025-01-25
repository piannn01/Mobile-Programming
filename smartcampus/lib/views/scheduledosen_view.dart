import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;// Import permission_handler

class AddSchedulePage extends StatefulWidget {
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  String tahunAkademik = '';
  String mataKuliah = '';
  String hari = '';
  TimeOfDay waktu = TimeOfDay.now();
  String ruang = '';
  String reminderDescription = '';
  TimeOfDay reminderTime = TimeOfDay.now();
  List<String> availableYears = [];
  List<Map<String, dynamic>> schedules = [];
  List<Map<String, dynamic>> filteredSchedules = [];
  List<Map<String, dynamic>> reminders = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadReminders();  // Panggil _loadReminders untuk mengambil data pengingat
    _initializeNotifications();
    tz.initializeTimeZones();
  }

  // Fungsi untuk memuat data pengingat dari Firestore
  Future<void> _loadReminders() async {
    var collection = FirebaseFirestore.instance.collection('reminders');
    var snapshots = await collection.get();
    reminders = snapshots.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {}); // Refresh UI setelah data pengingat dimuat
  }

  void _initializeNotifications() {
    var androidInitialize = AndroidInitializationSettings('app_icon'); // Ensure you have an 'app_icon' in drawable
    var iOSInitialize = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _addReminder() async {
    DateTime reminderDateTime = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    var androidDetails = AndroidNotificationDetails(
      "reminder_channel", "Reminders",
      channelDescription: "Channel for reminder notifications",
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );

    var iosDetails = DarwinNotificationDetails();

    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await localNotificationsPlugin.zonedSchedule(
      reminderDateTime.millisecondsSinceEpoch.remainder(100000),
      'Reminder',
      reminderDescription,
      tz.TZDateTime.from(reminderDateTime, tz.local),
      generalNotificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    var collection = FirebaseFirestore.instance.collection('reminders');
    await collection.add({
      'description': reminderDescription,
      'time': "${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}",
      'date': reminderDateTime.toIso8601String(),
    });

    // Memanggil _loadReminders untuk memperbarui data pengingat setelah ditambahkan
    await _loadReminders();
  }

  // Menambahkan pengingat
  void _showAddReminderDialog() {
    final GlobalKey<FormState> reminderFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Pengingat'),
          content: Form(
            key: reminderFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Deskripsi Pengingat'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Tolong masukkan deskripsi pengingat.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    reminderDescription = value.trim();
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        reminderTime = pickedTime;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the modal without saving
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (reminderFormKey.currentState!.validate()) {
                  // Simpan pengingat
                  try {
                    await _addReminder();
                    Navigator.pop(context); // Close the modal after saving
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pengingat berhasil disimpan!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan pengingat: $e')),
                    );
                  }
                }
              },
              child: Text('Simpan Pengingat'),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan daftar pengingat
  Widget _buildReminderList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengingat: ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (reminders.isEmpty)
          Text('Tidak ada pengingat saat ini.')
        else
          ...reminders.map((reminder) {
            DateTime reminderDate = DateTime.parse(reminder['date']);
            return ListTile(
              title: Text(reminder['description']),
              subtitle: Text('${reminderDate.hour.toString().padLeft(2, '0')}:${reminderDate.minute.toString().padLeft(2, '0')}'),
              trailing: Icon(Icons.notifications),
            );
          }).toList(),
      ],
    );
  }

  // Fungsi untuk memuat data jadwal dari Firestore
  void _loadData() async {
    var collection = FirebaseFirestore.instance.collection('schedules');
    var snapshots = await collection.get();
    schedules = [];
    availableYears = [];
    for (var doc in snapshots.docs) {
      var data = doc.data() as Map<String, dynamic>;
      schedules.add(data);
      if (!availableYears.contains(data['tahunAkademik'])) {
        availableYears.add(data['tahunAkademik']);
      }
    }
    if (availableYears.isNotEmpty && tahunAkademik.isEmpty) {
      tahunAkademik = availableYears.first;
    }
    _filterSchedules(tahunAkademik);
  }

  void _filterSchedules(String tahun) {
    setState(() {
      tahunAkademik = tahun;
      filteredSchedules = schedules.where((schedule) {
        return schedule['tahunAkademik'] == tahun;
      }).toList();
    });
  }

  // Fungsi untuk menambahkan jadwal
  Future<void> _addSchedule() async {
    DateTime scheduleDateTime = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      waktu.hour,
      waktu.minute,
    );

    var collection = FirebaseFirestore.instance.collection('schedules');
    var scheduleData = {
      'tahunAkademik': tahunAkademik,
      'mataKuliah': mataKuliah,
      'hari': hari,
      'waktu': "${waktu.hour}:${waktu.minute}",
      'ruang': ruang,
      'tanggal': _selectedDay,
    };
    await collection.add(scheduleData);
    _resetFields();
    _loadData();
  }

  void _resetFields() {
    mataKuliah = '';
    hari = '';
    waktu = TimeOfDay.now();
    ruang = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Jadwal Kuliah'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          // Menambahkan daftar pengingat
          _buildReminderList(), // Menampilkan daftar pengingat

          ElevatedButton(
            onPressed: _showAddReminderDialog, // Tombol untuk membuka dialog pengingat
            child: Text('Tambahkan Pengingat'),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          DropdownButtonFormField(
            value: tahunAkademik.isEmpty ? null : tahunAkademik,
            onChanged: (String? newValue) {
              if (newValue != null) {
                _filterSchedules(newValue);
              }
            },
            items: availableYears.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(labelText: 'Filter Tahun Akademik'),
          ),
          SizedBox(height: 20),
          Text(
            'Jadwal Kuliah untuk Tahun Akademik: $tahunAkademik',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          DataTable(
            columnSpacing: 38.0,
            columns: const [
              DataColumn(label: Text('Mata Kuliah')),
              DataColumn(label: Text('Hari')),
              DataColumn(label: Text('Waktu')),
              DataColumn(label: Text('Ruang')),
            ],
            rows: filteredSchedules.map((schedule) => DataRow(
              cells: [
                DataCell(Text(schedule['mataKuliah'])),
                DataCell(Text(schedule['hari'])),
                DataCell(Text(schedule['waktu'])),
                DataCell(Text(schedule['ruang'])),
              ],
            )).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Tambah Jadwal'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Tahun Akademik'),
                        onChanged: (value) => tahunAkademik = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Mata Kuliah'),
                        onChanged: (value) => mataKuliah = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Hari'),
                        onChanged: (value) => hari = value,
                      ),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              waktu = pickedTime;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.access_time),
                            ],
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Ruang'),
                        onChanged: (value) => ruang = value,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addSchedule();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Tambah'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}