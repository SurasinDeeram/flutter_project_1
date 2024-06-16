import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwdController = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController orgController = TextEditingController();

  Future<void> insertData() async {
    const apiUrl = 'http://localhost/api.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'register': true,
          'id': idController.text,
          'password': passwdController.text,
          'firstname': fnameController.text,
          'lastname': lnameController.text,
          'org': orgController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('message') &&
            responseData['message'] == 'User registered successfully') {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else {
          _showSnackBar('Data insertion failed: ${responseData['message']}');
        }
      } else {
        _showSnackBar('An error occurred. Please try again.');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(idController, 'Username'),
            const SizedBox(height: 20),
            _buildTextField(passwdController, 'Password (1-15 characters)',
                isPassword: true),
            const SizedBox(height: 20),
            _buildTextField(fnameController, 'First Name'),
            const SizedBox(height: 20),
            _buildTextField(lnameController, 'Last Name'),
            const SizedBox(height: 20),
            _buildTextField(orgController, 'University'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 3.0,
              ),
              onPressed: () {
                insertData();
              },
              child: const Text('Register', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 8.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Login', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      onChanged: (String value) {
        if (value.isNotEmpty) {
          setState(() {});
        }
      },
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        labelText: label,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
