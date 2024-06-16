// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mysql.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String id = "", passwd = "", fname = "", lname = "", org = "";
bool mode = false;
String buttonName = "Register";
double w = 0, h = 0;
int id_auto = 0;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final db = MySql();

  TextEditingController idController = TextEditingController();
  TextEditingController passwdController = TextEditingController();
  TextEditingController retypePasswdController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController orgController = TextEditingController();

  Future<void> insertData(
      String id, String passwd, String fname, String lname, String org) async {
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
          if (kDebugMode) {
            print("Data Inserted Successfully");
          }
          _showAlertDialog('Save Successful');
          Navigator.pop(context);
        } else {
          if (kDebugMode) {
            print("Data Insertion Failed: ${responseData['message']}");
          }
          // Display an error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Data insertion failed: ${responseData['message']}'),
            ),
          );
        }
      } else {
        // Handle error response
        if (kDebugMode) {
          print("Error: ${response.statusCode}");
        }
        // Display a generic error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      if (kDebugMode) {
        print("Exception: $e");
      }
      // Display a generic error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue, // Set a color for the app bar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(idController, 'รหัสประจำตัว'),
            _buildTextField(passwdController, 'Password (1-15 characters)',
                isPassword: true),
            _buildTextField(
                retypePasswdController, 'Retype Password (1-15 characters)',
                isPassword: true),
            _buildTextField(fnameController, 'First Name'),
            _buildTextField(lnameController, 'Last Name'),
            _buildTextField(orgController, 'University'),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set a color for the button
                elevation: 3.0, // Add elevation
              ),
              onPressed: () {
                setState(() {
                  if (buttonName == 'Register') {
                    insertData(id, passwd, fname, lname, org);
                  } else {
                    if (kDebugMode) {
                      print('update');
                    }
                  }
                });
              },
              child: Text(
                buttonName,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    Colors.blue, // Set a color for the outline button
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
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
          setState(() {
            id = value;
          });
        }
      },
      readOnly: mode,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Add rounded corners
        ),
        labelText: label,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      style: const TextStyle(fontSize: 16), // Increase font size
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
