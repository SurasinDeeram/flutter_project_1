import 'package:flutter/material.dart';
import 'package:flutter_application_1/Dashboard/View/view_concert.dart';
import 'package:flutter_application_1/Dashboard/View/view_customer.dart';
import 'package:flutter_application_1/Dashboard/View/view_ticket.dart';
import 'package:flutter_application_1/InterfaceApp/login_page.dart';

class DashboardPage extends StatelessWidget {
  final String userId;

  const DashboardPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Music'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
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
              leading: const Icon(Icons.music_note_outlined),
              title: const Text('Concert'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewConcert(userId: ''),
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
                  MaterialPageRoute(
                    builder: (context) => const ViewTicket(userId: ''),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Customer'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewCustomerPage(Mode: '', isEditMode: false, mode: '',),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Perform logout action here
                // For example, navigate back to the login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
