// ignore_for_file: file_names, prefer_const_constructors, unnecessary_string_interpolations, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Dashboard/View/view_customer.dart';
import 'package:flutter_application_1/InterfaceApp/login_page.dart';
import 'package:flutter_application_1/UserDashboard/View/View_Booking_concert.dart';

class ConcertTicketPage extends StatelessWidget {
  final String userId;

  const ConcertTicketPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concert Ticket'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.orangeAccent,
              ),
              child: Text(
                'Welcome, $userId',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Navigate to ConcertTicketPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConcertTicketPage(userId: '$userId'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note_outlined),
              title: const Text('Concert'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingConcert(userId: ''),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.airplane_ticket),
              title: const Text('Ticket'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewCustomer(userId: userId)),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Perform logout action here
                // For example, navigate back to the login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ViewCustomer extends StatelessWidget {
  final String userId;

  const ViewCustomer({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement your view customer screen UI here
    return Scaffold(
      appBar: AppBar(
        title: Text('View Customers - $userId'),
      ),
      body: Center(
        child: Text('View Customer Screen for User ID: $userId'),
      ),
    );
  }
}
