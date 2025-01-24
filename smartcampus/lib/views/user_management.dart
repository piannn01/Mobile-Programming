import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<Map<String, String>> _users = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersData = prefs.getString('users');
    if (usersData != null) {
      setState(() {
        _users.addAll(List<Map<String, String>>.from(json.decode(usersData)));
      });
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', json.encode(_users));
  }

  void _addUser() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_editingIndex == null) {
          _users.add({
            'email': _emailController.text,
            'password': _passwordController.text,
          });
        } else {
          _users[_editingIndex!] = {
            'email': _emailController.text,
            'password': _passwordController.text,
          };
          _editingIndex = null;
        }
        _emailController.clear();
        _passwordController.clear();
      });
      _saveUsers();
    }
  }

  void _editUser(int index) {
    setState(() {
      _editingIndex = index;
      _emailController.text = _users[index]['email']!;
      _passwordController.text = _users[index]['password']!;
    });
  }

  void _deleteUser(int index) {
    setState(() {
      _users.removeAt(index);
    });
    _saveUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addUser,
                    child: Text(_editingIndex == null ? 'Add User' : 'Update User'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_users[index]['email']!),
                      subtitle: Text('Password: ${_users[index]['password']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editUser(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteUser(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
