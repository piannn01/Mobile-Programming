import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx2/dependency_management.dart';

// --- Controller FormController ---
class FormController extends GetxController {
  var name = ''.obs; // Reactive variable for name
  var email = ''.obs; // Reactive variable for name

  // Function to update the name
  void updateName(String newName) {
    name.value = newName;
  }

  // Function to update the email
  void updateEmail(String newEmail) {
    name.value = newEmail;
  }

  // Form validation function
  bool  validateForm() {
    return name.isNotEmpty && email.isNotEmpty;
  }
}

// --- Binding: FormBinding ---
class FormBinding extends Bindings {
  @override
  void  dependencies() {
    // Put FormController into GetX dependency management
    Get.put(FormController());
  }
}

// --- UI: FormPage ---
class FormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormController>();

    return Scaffold(
      appBar: AppBar(title: Text('Form Pengguna dengan GetX')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Nama', controller.updateName),
            _buildTextField('Email', controller.updateEmail),
            SizedBox(height: 20),
            Obx(() => Text(
                'Nama ${controller.name}, Email: ${controller.email}',
                style: TextStyle(fontSize: 16),
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.validateForm()
                    ? Get.snackbar('Sukses', 'Formulir berhasil dikirim')
                    : Get.snackbar('Gagal', 'Nama dan Email harus diisi');
              },
              child: Text('Kirim'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

// --- Main: MyApp ---
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Bindings Form Example',
      initialRoute: '/form',
      getPages: [
        GetPage(
            name: '/form',
            page: () => FormPage(),
            binding: FormBinding(), // Binding the FormController to this page
        ),
      ],
    );
  }
}