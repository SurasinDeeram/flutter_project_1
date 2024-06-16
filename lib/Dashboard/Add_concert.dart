// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, unused_label, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddConcertPage extends StatefulWidget {
  const AddConcertPage({Key? key}) : super(key: key);

  @override
  _AddConcertPageState createState() => _AddConcertPageState();
}

class _AddConcertPageState extends State<AddConcertPage> {
  XFile? _image; // Variable to store the selected image
  final TextEditingController _concertNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> _saveConcert() async {
    String concertName = _concertNameController.text;
    String description = _descriptionController.text;
    String dateTime = _dateTimeController.text;
    String location = _locationController.text;
    String imagePath = _image?.path ?? ""; // Check if an image is selected

    // Send data to the API using HTTP POST request
    var apiurl = Uri.parse('http://localhost/api.php');
    try {
      final response = await http.post(
        apiurl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'add_concert': true,
          'concert_name': concertName,
          'description': description,
          'date_time': dateTime,
          'location': location,
          'image_path': imagePath,
        }),
      );
      // Check if the request is successful
      if (response.statusCode == 200) {
        // Handle successful response
        if (kDebugMode) {
          print('Concert data saved successfully.');
        }
        // Clear the text fields after saving concert data
        _concertNameController.clear();
        _descriptionController.clear();
        _dateTimeController.clear();
        _locationController.clear();
        setState(() {
          _image = null;
        });
      } else {
        // Handle error
        if (kDebugMode) {
          print('Failed to save concert data: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Concert'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _concertNameController,
                decoration: const InputDecoration(labelText: 'ชื่อคอนเสิร์ต'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'รายละเอียดคอนเสิร์ต'),
                maxLines: 3,
              ),

              TextFormField(
                readOnly: true,
                controller: _dateTimeController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _dateTimeController.text =
                            '${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.hour}:${pickedTime.minute}';
                      });
                    }
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'วันที่และเวลา',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'สถานที่'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('ใส่รูปภาพ'),
              ),
              if (_image != null) Image.file(File(_image!.path)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveConcert,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
