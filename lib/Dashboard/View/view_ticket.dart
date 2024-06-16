// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Dashboard/Add_Ticket.dart';
// import 'package:flutter_application_1/Dashboard/Add_concert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewTicket extends StatefulWidget {
  final String userId;

  const ViewTicket({Key? key, required this.userId}) : super(key: key);

  @override
  _ViewConcertState createState() => _ViewConcertState();
}

class _ViewConcertState extends State<ViewTicket> {
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

  Future<List<dynamic>> fetchDataTicket() async {
    const ticketsApiUrl = 'http://localhost/api.php';
    final response = await http.post(
      Uri.parse(ticketsApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fetch_tickets': true}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        return responseData['tickets'];
      } else {
        _showSnackBar('Failed to fetch data: ${responseData['message']}');
        return [];
      }
    } else {
      _showSnackBar('An error occurred while fetching data. Please try again.');
      return [];
    }
  }

  Future<void> deleteTicket(int ticketId) async {
  const String apiUrl = 'http://localhost/api.php';
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'delete_ticket': true,
      'id': ticketId,
    }),
  );

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print('Ticket deleted successfully');
    }
  } else {
    if (kDebugMode) {
      print('Failed to delete ticket');
    }
  }
  var jsonResponse = json.decode(response.body);
  if (kDebugMode) {
    print('Response: $jsonResponse');
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
        title: const Text('View Ticket'),
        actions: const [],
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
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var concert = snapshot.data![index];

    
                debugPrint('ImagePath : ${concert['image']}');
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: concert['image'] != null
                        
                            ? Image.network(
                                concert['image'],
                                    // .replaceFirst('localhost', '172.20.10.2'),
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.music_note, size: 45),
                      ),
                      Text(concert['name'] ?? 'Unnamed Concert'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Tickets Available: '),
                          Text(concert['tickets_available'].toString()),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Ticket for : ${concert['name']}',
                                  textAlign: TextAlign.center,
                                ),
                                contentPadding: const EdgeInsets.all(10.0),
                                content: FutureBuilder<List<dynamic>>(
                                  future: fetchDataTicket(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<dynamic>> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Center(
                                          child: Text('No tickets found'));
                                    } else {
                                      return SingleChildScrollView(
                                        child: DataTable(
                                          columns: const [
                                            DataColumn(
                                                label: Text('ประเภทตั๋ว')),
                                            DataColumn(label: Text('ราคา')),
                                            DataColumn(
                                                label: Text('จำนวนตั๋วที่มี')),
                                            DataColumn(label: Text('Action')),
                                          ],
                                          rows: snapshot.data!.map((ticket) {
                                            return DataRow(cells: [
                                              DataCell(Text(ticket['type'])),
                                              DataCell(Text(ticket['price'].toString())),
                                              DataCell(Text(ticket['quantity_availble'].toString())),
                                              DataCell(
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContextcontext) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            'Confirm Delete',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          content: Text(
                                                              'Are you sure you want to delete this ticket?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  await deleteTicket( ticket[ 'id']);
                                                                  Navigator.of( context).pop();
                                                                } catch (error) {
                                                                  if (kDebugMode) {
                                                                    print('Error deleting ticket: $error');
                                                                  }
                                                                }
                                                              },
                                                              child:Text('Yes'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text('No'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('Delete'),
                                                ),
                                              ),
                                            ]);
                                          }).toList(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TicketForm(
                                              concertName: concert['name']),
                                        ),
                                      );
                                    },
                                    child: const Text('เพิ่มตั๋ว'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Manage Ticket'),
                      ),
                    ],
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


