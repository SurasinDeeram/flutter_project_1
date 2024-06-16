// ignore_for_file: prefer_const_declarations, use_build_context_synchronously, prefer_const_constructors, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Dashboard/Add_concert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewConcert extends StatefulWidget {
  final String userId;

  const ViewConcert({Key? key, required this.userId}) : super(key: key);

  @override
  _ViewConcertState createState() => _ViewConcertState();
}

class _ViewConcertState extends State<ViewConcert> {
  late Future<List<dynamic>> _concertsFuture;

  @override
  void initState() {
    super.initState();
    _concertsFuture = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    const apiUrl = 'http://localhost/api.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fetch_concerts': true}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        return responseData['concerts'];
      } else {
        _showSnackBar('Failed to fetch data: ${responseData['message']}');
        return [];
      }
    } else {
      _showSnackBar('An error occurred while fetching data. Please try again.');
      return [];
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

Future<void> deleteConcert(int concertId) async {
  final apiUrl = 'http://localhost/api.php';
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'
    },
    body: jsonEncode({
      'delete_concert': true,
      'id': concertId,
    }),
  );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ticket deleted successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to delete ticket: ${responseData['message']}'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'An error occurred while deleting the ticket. Please try again.'),
        ),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('View Concert'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddConcertPage(),
              ),
            );
          },
          icon: const Icon(Icons.add),
        ),
      ],
    ),
    body: FutureBuilder<List<dynamic>>(
      future: _concertsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No concerts found'));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two columns
              childAspectRatio:
                  0.8, // The ratio of the width to the height of each item
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              var concert = snapshot.data![index];
              var concertId = concert['id']; // Retrieve the concert ID

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Concert'),
                          content: const Text(
                              'Are you sure you want to delete this concert?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteConcert(concertId);
                              },
                              child: const Text('Delete Concert'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: concert['image'] != null
                            ? Image.network(
                                concert['image']
                                    .replaceFirst('localhost', '10.222.1.3'),
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.music_note, size: 50),
                      ),
                      Text(concert['name'] ?? 'Unnamed Concert'),
                      Text(concert['description'] ??
                          'No description provided.'),
                      Text(concert['date_time'] ?? 'No date provided'),
                      // Add more fields if necessary
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    ),
  );
}
}