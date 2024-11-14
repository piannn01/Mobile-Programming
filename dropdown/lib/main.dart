import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Daftar data contoh
  List<CountryModel> CountryList = [
    CountryModel(id: 1, name: "Brazil"),
    CountryModel(id: 2, name: "Tunisia"),
    CountryModel(id: 3, name: "Canada"),
    CountryModel(id: 4, name: "India"),
    CountryModel(id: 5, name: "Indonesia"),
  ];

  // Fungsi untuk mendapatkan data yang difilter
  Future<List<CountryModel>> getData(String? filter) async {
    if (filter == null || filter.isEmpty) {
      return CountryList;
    }
    return CountryList
        .where((Country) => Country.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  // Pembuat item popup
  Widget CountryModelPopupItem(BuildContext context, CountryModel item, bool isSelected, bool isHighlighted) {
    return ListTile(
      title: Text(item.name),
      selected: isSelected,
      tileColor: isHighlighted ? Colors.blue[50] : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DROPDOWN")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: DropdownSearch<CountryModel>(
          items: (filter, t) => getData(filter),
          popupProps: PopupPropsMultiSelection.bottomSheet(
            showSelectedItems: true,
            itemBuilder: CountryModelPopupItem,
            showSearchBox: true,
          ),
          compareFn: (item, sItem) => item.id == sItem.id,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Country *',
              filled: true,
              fillColor:
              Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CountryModel {
  final int id;
  final String name;

  CountryModel({required this.id, required this.name});

  // Fungsi pembanding agar DropdownSearch dapat membandingkan item yang dipilih
  bool isEqual(CountryModel other) {
    return id == other.id;
  }

  // Override metode toString agar menampilkan nama saat dipilih
  @override
  String toString() => name;
}
