// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingConcert extends StatefulWidget {
  final String userId;

  const BookingConcert({Key? key, required this.userId}) : super(key: key);

  @override
  _BookingConcertState createState() => _BookingConcertState();
}

class _BookingConcertState extends State<BookingConcert> {
  late Future<List<dynamic>> _concertsFuture;
  late Future<List<dynamic>> _bookingTicketFuture;
  String? selectedPrice;
  String? selectedTicketType;

  @override
  void initState() {
    super.initState();
    _concertsFuture = fetchData();
    _bookingTicketFuture = fetchData_bookingticket();
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

  Future<List<dynamic>> fetchData_bookingticket() async {
    const apiUrl = 'http://localhost/api.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fetch_bookingticket': true}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        return responseData['booking_tickets'];
      } else {
        _showSnackBar(
            'Failed to fetch booking tickets: ${responseData['message']}');
        return [];
      }
    } else {
      _showSnackBar(
          'An error occurred while fetching booking tickets. Please try again.');
      return [];
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
        title: const Text('View Booking Concerts'),
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
                return Card(
                  margin: const EdgeInsets.all(8.0),
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
                      Text(concert['date_time'] ?? 'No date provided'),
                      Text(
                          concert['description'] ?? 'No description provided.'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    'Book Your Ticket For: ${concert['name']}'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFormField(
                                        onChanged: (value) {},
                                        decoration: InputDecoration(
                                          labelText: 'Booker Name',
                                          hintText: widget.userId,
                                        ),
                                      ),
                                      FutureBuilder<List<dynamic>>(
                                        future: _bookingTicketFuture,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<dynamic>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return const Text(
                                                'No ticket types found');
                                          } else {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  value: selectedTicketType,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedTicketType =
                                                          value;
                                                      final selectedTicket =
                                                          snapshot.data!
                                                              .firstWhere(
                                                        (ticket) =>
                                                            ticket['type'] ==
                                                            selectedTicketType,
                                                        orElse: () => null,
                                                      );
                                                      selectedPrice =
                                                          selectedTicket != null
                                                              ? selectedTicket[
                                                                  'price']
                                                              : null;
                                                    });
                                                  },
                                                  items: snapshot.data!.map<
                                                      DropdownMenuItem<String>>(
                                                    (ticket) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: ticket['type'],
                                                        child: Text(
                                                          '${ticket['id']} - ${ticket['type']} - Price: ${ticket['price']}',
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Ticket Type',
                                                  ),
                                                ),
                                                TextFormField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      final enteredQuantity =int.tryParse(value) ?? 0;
                                                      if (selectedTicketType != null) {
                                                      final selectedTicket = snapshot.data! .firstWhere((ticket) =>ticket['type'] == selectedTicketType,
                                                          orElse: () => null,
                                                        );
                                                        if (selectedTicket !=
                                                            null) {
                                                          selectedPrice = (enteredQuantity *
                                                                  double.parse(
                                                                      selectedTicket[
                                                                          'price']))
                                                              .toStringAsFixed(
                                                                  2);
                                                          }
                                                       }
                                                      });
                                                    },
                                                    onFieldSubmitted: (value) {
                                                     // ส่วนการคำนวณค่าทั้งหมดไว้ใน onChanged เพื่อให้การคำนวณเกิดขึ้นทันทีเมื่อผู้ใช้กด Enter
                                                    // ดังนั้นไม่จำเป็นต้องมีการกำหนด onFieldSubmitted ในขั้นตอนนี้
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Ticket Quantity',
                                                    hintText:
                                                        'Enter ticket quantity',
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                TextFormField(
                                                  initialValue: selectedPrice,
                                                  onChanged: (value) {},
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Total price',
                                                    hintText:
                                                        'Enter total price',
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle booking logic here
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Confirm'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Buy Ticket'),
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
