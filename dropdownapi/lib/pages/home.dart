import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import '../models/province.dart';
import '../models/city.dart';
import 'dart:convert';

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
  String? idProv;
  final String apiKey = "cae2f8ef8cbafc83440b5a8f8fa394dd1ddef4caad4378eb29dfeab6df3d7d80";

  // Fungsi untuk mengambil data provinsi dari API
  Future<List<Province>> fetchProvinces(String? filter) async {
    final response = await http.get(
      Uri.parse('https://api.binderbyte.com/wilayah/provinsi?api_key=$apiKey'),
    );

    print("Province API Response: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Mengubah pengecekan untuk menyesuaikan struktur respons baru
      if (jsonResponse['code'] == "200" && jsonResponse['value'] is List) {
        List jsonData = jsonResponse['value'];
        List<Province> provinces = jsonData.map((province) => Province.fromJson(province)).toList();

        if (filter != null && filter.isNotEmpty) {
          provinces = provinces.where((province) =>
              province.name.toLowerCase().contains(filter.toLowerCase()))
              .toList();
        }
        return provinces;
      } else {
        throw Exception('Data not found or invalid format');
      }
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  // Fungsi untuk mengambil data kota berdasarkan provinsi yang dipilih
  Future<List<City>> fetchCities(String provinceId, String? filter) async {
    final response = await http.get(
      Uri.parse('https://api.binderbyte.com/wilayah/kabupaten?api_key=$apiKey&id_provinsi=$provinceId'),
    );

    print("City API Response: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      // Mengubah pengecekan untuk menyesuaikan struktur respons baru
      if (jsonResponse['code'] == "200" && jsonResponse['value'] is List) {
        List jsonData = jsonResponse['value'];
        List<City> cities = jsonData.map((city) => City.fromJson(city)).toList();

        if (filter != null && filter.isNotEmpty) {
          cities = cities.where((city) =>
              city.name.toLowerCase().contains(filter.toLowerCase()))
              .toList();
        }
        return cities;
      } else {
        throw Exception('Data not found or invalid format');
      }
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Province? selectedProvince;
  City? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pilih Provinsi dan Kota")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // DropdownSearch untuk memilih provinsi
            DropdownSearch<Province>(
              asyncItems: (String? filter) => fetchProvinces(filter),
              itemAsString: (Province province) => province.name,
              compareFn: (Province a, Province b) => a.id == b.id,
              popupProps: PopupProps.bottomSheet(
                showSelectedItems: true,
                showSearchBox: true,
                itemBuilder: (context, item, isSelected) {
                  return ListTile(
                    title: Text(item.name),
                    selected: isSelected,
                  );
                },
              ),
              onChanged: (value) {
                setState(() {
                  selectedProvince = value;
                  selectedCity = null; // Reset pilihan kota saat provinsi berubah
                });
              },
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Pilih Provinsi',
                  filled: true,
                ),
              ),
            ),
            SizedBox(height: 20),

            // DropdownSearch untuk memilih kota
            if (selectedProvince != null)
              DropdownSearch<City>(
                asyncItems: (String? filter) => fetchCities(selectedProvince!.id, filter),
                itemAsString: (City city) => city.name,
                compareFn: (City a, City b) => a.id == b.id,
                popupProps: PopupProps.bottomSheet(
                  showSelectedItems: true,
                  showSearchBox: true,
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(item.name),
                      selected: isSelected,
                    );
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Pilih Kota',
                    filled: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
