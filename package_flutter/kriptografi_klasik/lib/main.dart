import 'package:flutter/material.dart';

void main() {
  runApp(const CipherApp());
}

class CipherApp extends StatelessWidget {
  const CipherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CipherHomePage(),
    );
  }
}

class CipherHomePage extends StatefulWidget {
  @override
  _CipherHomePageState createState() => _CipherHomePageState();
}

class _CipherHomePageState extends State<CipherHomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  String _output = "";
  String _selectedMethod = "Caesar";
  bool _isDecrypt = false;

  // Caesar Cipher Function
  String caesarCipher(String text, int shift, {bool decrypt = false}) {
    if (decrypt) shift = -shift; // Reverse shift for decryption
    final result = text.runes.map((rune) {
      if (rune >= 65 && rune <= 90) {
        // Uppercase
        return String.fromCharCode((rune - 65 + shift) % 26 + 65);
      } else if (rune >= 97 && rune <= 122) {
        // Lowercase
        return String.fromCharCode((rune - 97 + shift) % 26 + 97);
      } else {
        // Non-alphabet characters remain unchanged
        return String.fromCharCode(rune);
      }
    }).join();
    return result;
  }

  // Vigenère Cipher Function
  String vigenereCipher(String text, String key, {bool decrypt = false}) {
    int keyIndex = 0;
    final result = text.runes.map((rune) {
      if (rune >= 65 && rune <= 90 || rune >= 97 && rune <= 122) {
        final shift = (key[keyIndex % key.length].toLowerCase().codeUnitAt(0) - 97) % 26;
        final effectiveShift = decrypt ? -shift : shift; // Reverse shift for decryption
        final encryptedChar = caesarCipher(String.fromCharCode(rune), effectiveShift);
        keyIndex++;
        return encryptedChar;
      } else {
        return String.fromCharCode(rune);
      }
    }).join();
    return result;
  }

  void _processText() {
    final inputText = _textController.text;
    final key = _keyController.text;

    setState(() {
      if (_selectedMethod == "Caesar") {
        final shift = int.tryParse(key) ?? 0; // Default to 0 if key is invalid
        _output = caesarCipher(inputText, shift, decrypt: _isDecrypt);
      } else if (_selectedMethod == "Vigenère") {
        _output = vigenereCipher(inputText, key, decrypt: _isDecrypt);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cipher Enkripsi/Dekripsi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: "Enter text"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(labelText: "Enter key (shift/key word)"),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedMethod,
              onChanged: (value) {
                setState(() {
                  _selectedMethod = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: "Caesar", child: Text("Caesar Cipher")),
                DropdownMenuItem(value: "Vigenère", child: Text("Vigenère Cipher")),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isDecrypt = false;
                      });
                      _processText();
                    },
                    child: const Text("Enkripsi"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isDecrypt = true;
                      });
                      _processText();
                    },
                    child: const Text("Dekripsi"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Output:",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              _output,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
