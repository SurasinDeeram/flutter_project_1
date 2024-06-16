// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'mysql.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataShow extends StatefulWidget {
  final String userId;
  // ignore: non_constant_identifier_names
  bool Mode;

  // ignore: non_constant_identifier_names
  DataShow({Key? key, required this.userId, required this.Mode})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DataShowState createState() => _DataShowState();
}

class _DataShowState extends State<DataShow> {
  final db = MySql();
  TextEditingController idController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController orgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const apiUrl = 'http://localhost/api.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fetchdata': true,
          'id': widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('success') && responseData['success']) {
          setState(() {
            idController.text = responseData['id'] ?? '';
            fnameController.text = responseData['firstname'] ?? '';
            lnameController.text = responseData['lastname'] ?? '';
            orgController.text = responseData['org'] ?? '';
          });
        } else {
          _showSnackBar('Failed to fetch data: ${responseData['message']}');
        }
      } else {
        _showSnackBar(
            'An error occurred while fetching data. Please try again.');
      }
    } catch (e) {
      _showSnackBar('An error occurred while fetching data. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> updateData() async {
    const apiUrl = 'http://localhost/api.php';
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': widget.userId,
          'firstname': fnameController.text,
          'lastname': lnameController.text,
          'org': orgController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('success') && responseData['success']) {
          _showSnackBar('User updated successfully');
        } else {
          _showSnackBar('Failed to update user: ${responseData['message']}');
        }
      } else {
        _showSnackBar(
            'An error occurred while updating user. Please try again.');
      }
    } catch (e) {
      _showSnackBar('An error occurred while updating user. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          TextFormField(
            enabled: false,
            controller: idController,
            decoration: const InputDecoration(labelText: 'ID'),
          ),
          TextFormField(
            enabled: widget.Mode,
            controller: fnameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          TextFormField(
            enabled: widget.Mode,
            controller: lnameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          TextFormField(
            enabled: widget.Mode,
            controller: orgController,
            decoration: const InputDecoration(labelText: 'Organization'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.Mode = !widget.Mode;
              });

              if (!widget.Mode) {
                // Save button pressed, update data in the database
                updateData();
              }
            },
            child: Text(widget.Mode ? 'Save' : 'Edit'),
          ),
        ],
      ),
    );
  }
}
