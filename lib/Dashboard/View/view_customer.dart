// ignore_for_file: unused_import, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Dashboard/Add_customer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewCustomerPage extends StatefulWidget {
  final String mode;
  final bool isEditMode;

  const ViewCustomerPage({Key? key, required this.mode, required this.isEditMode, required String Mode}) : super(key: key);

  @override
  _ViewCustomerPageState createState() => _ViewCustomerPageState();
}

class _ViewCustomerPageState extends State<ViewCustomerPage> {
  late Future<List<dynamic>> _customerData;

  @override
  void initState() {
    super.initState();
    _customerData = fetchCustomerData();
  }

  Future<List<Map<String, dynamic>>> fetchCustomerData() async {
  const String apiUrl = 'http://localhost/api.php';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fetch_customers': true}),
    );

    if (response.statusCode == 200) {
      // Decode the JSON data to a List<Map<String, dynamic>>
      List<dynamic> jsonData = json.decode(response.body);
      List<Map<String, dynamic>> customerData = jsonData.cast<Map<String, dynamic>>();
      return customerData;
    } else {
      // Handle server errors
      throw Exception('Failed to load customer data from the server');
    }
  } catch (e) {
    // Handle any exceptions thrown during the request
    throw Exception('Failed to load customer data: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Customers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomerForm()), // Adjusted to the correct class name
                );
              },
              child: const Text('Add Customer'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _customerData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final customers = snapshot.data ?? [];
                    if (customers.isEmpty) {
                      return const Text('No customer data available.');
                    } else {
                      return ListView.builder(
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          return Card(
                            child: ListTile(
                              title: Text('${customer['firstname']} ${customer['lastname']}'),
                              subtitle: Text('ID: ${customer['id']} - Organization: ${customer['org']}'),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
