// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TicketForm extends StatefulWidget {
  final String concertName;

  const TicketForm({Key? key, required this.concertName}) : super(key: key);

  @override
  _TicketFormState createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  int? concertId;

  @override
  void initState() {
    super.initState();
    // Call fetchConcertId function when entering the page
    fetchConcertId(widget.concertName).then((id) {
      setState(() {
        concertId = id;
        debugPrint('Concert ID ${concertId}');
      });
    }).catchError((error) {
      // Handle error if any
      if (kDebugMode) {
        print('Error fetching concertId: $error');
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String type = _typeController.text;
      double price = double.tryParse(_priceController.text) ?? 0.0;
      int quantity = int.tryParse(_quantityController.text) ?? 0;

      // Check if price and quantity are valid
      if (price <= 0) {
        // Show error message for invalid price
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter a valid price.'),
        ));
        return;
      }

      if (quantity <= 0) {
        // Show error message for invalid quantity
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter a valid quantity.'),
        ));
        return;
      }

      var apiurl = Uri.parse('http://localhost/api.php');
      try {
        // Fetch concert_id from the database
        // int? concertId = await fetchConcertId(widget.concertName);

        final response = await http.post(
          apiurl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'add_ticket': true,
            'type': type,
            'price': price,
            'quantity_availble': quantity,
            'concert_id': concertId,
            // 'concertName': widget.concertName, 
          }),
        );

        // Handle response from the API
        if (response.statusCode == 200) {
          // Success
          if (kDebugMode) {
            print('Ticket submitted successfully');
            print('Type: $type');
            print('Price: $price');
            print('quantity_availble: $quantity');
            print('Concert Id: ${concertId}');
            // print('Concert Name: ${widget.concertName}');
          }

          // Clear text fields after submission
          _typeController.clear();
          _priceController.clear();
          _quantityController.clear();
          // Show success message or navigate to the next screen
        } else {
          // Error
          if (kDebugMode) {
            print('Failed to submit ticket');
          }
          // Handle the error case, show an error message, or retry logic
        }
      } catch (e) {
        // Handle the error
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
  }

  Future<int?> fetchConcertId(String concertName) async {
    var apiurl = Uri.parse('http://localhost/api.php');
    var response = await http.post(
      apiurl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'get_concert_id': true,
        'concertName': concertName,
      }),
    );

    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(response.body);

        return data['concertId'] as int?;
      } catch (e) {
        if (kDebugMode) {
          print('Error decoding concertId: $e');
        }
        return null;
      }
    } else {
      throw Exception('Failed to fetch concert_id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มตั๋วสำหรับ ${widget.concertName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'ประเภทตั๋ว',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter ticket type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ราคา',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'จำนวนตั๋วที่มี',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Ticket Form Demo',
    home: TicketForm(concertName: 'name'),
  ));
}
