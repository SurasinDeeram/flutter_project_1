// login_page.dart
// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/UserDashboard/UserConcertTicket.dart';
import 'register_page.dart';
import 'mysql.dart';
import 'package:flutter_application_1/Dashboard/AdminMusic.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool mode = false;
final db = MySql();

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String id; // Declare 'id' variable
  late String passwd; // Declare 'passwd' variable

  void _navigateToDashboardPage(String id) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(userId: id),
      ),
    );
  }

  Future<void> login(String id, String passwd) async {
    const apiUrl = 'http://localhost/api.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': true, 'id': id, 'password': passwd}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('message') &&
            responseData['message'] == 'Login successful') {
          if (kDebugMode) {
            print("Login Successful");
          }
          _navigateToDashboardPage(id);
          mode = false;
        } else {
          // Authentication failed
          if (kDebugMode) {
            print("Login Failed: ${responseData['message']}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed: ${responseData['message']}'),
              ),
            );
          }
        }
      } else {
        // Handle error response
        if (kDebugMode) {
          print("Error: ${response.statusCode}");
        }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again. Details: $e'),
        ),
      );
    }
  }

  Future<void> login_customer(
      String id, String passwd, BuildContext context) async {
    const apiUrl = 'http://localhost/api.php';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({'login_customer': true, 'id': id, 'password': passwd}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('message') &&
            responseData['message'] == 'Login successful') {
          if (kDebugMode) {
            print("Login Successful");
          }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConcertTicketPage(userId: id)),
          );
          mode = false;
        } else {
          // Authentication failed
          if (kDebugMode) {
            print("Login Failed: ${responseData['message']}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed: ${responseData['message']}'),
              ),
            );
          }
        }
      } else {
        // Handle error response
        if (kDebugMode) {
          print("Error: ${response.statusCode}");
        }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again. Details: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(
              Icons.account_circle,
              size: 100.0,
              color: Colors.blue,
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (String value) {
                if (value.isNotEmpty) {
                  setState(() {
                    id = value;
                  });
                }
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (String value) {
                if (value.isNotEmpty) {
                  setState(() {
                    passwd = value;
                  });
                }
              },
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                setState(() {
    
                    login_customer(id, passwd, context);

                    login(id, passwd);
                  
                });
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20, color: Colors.blue),
              ),
              child: const Text('Register'),
              onPressed: () {
                setState(() {
                  mode = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Register(),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
