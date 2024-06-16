import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(const MaterialApp(home: Login()));
}

String id = "", passwd = "", fname = "", lname = "", org = "";
bool mode = false;
String buttonName = "Register";
double w = 0, h = 0;

class MySql {
  static String host = '127.0.0.1', user = 'root', db = 'profiles';
  static int port = 3306;
  MySql();
  Future<MySqlConnection> getConnection() async {
    var settings =
        ConnectionSettings(host: host, port: port, user: user, db: db);
    return await MySqlConnection.connect(settings);
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (String value) {
              if (value != '') {
                setState(() {
//                          id = value;
                });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'รหัสประจำตัว',
            ),
          ),
          TextField(
            onChanged: (String value) {
              if (value != '') {
                setState(() {
//                          passwd = value;
                });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'password',
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              setState(() {
//                        login();
              });
            },
            child: const Text('login'),
          ),
          OutlinedButton(
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
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final db = MySql();
  // ignore: non_constant_identifier_names
  int id_auto = 0;
  Future<void> insertData(
      String id, String passwd, String fname, String lname, String org) async {
    final conn = await db.getConnection();
    String sql =
        "insert into users values ('$id', '$passwd', '$fname', '$lname', '$org','$id_auto')";
    //print(sql);
    await conn.query(sql); // Note the 'await' keyword here
    await conn.close(); // Also 'await' here
    setState(() {
      if (kDebugMode) {
        print("Success");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: id),
              onChanged: (String value) {
                if (value != '') {
                  setState(() {
                    id = value;
                  });
                }
              },
              readOnly: mode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'รหัสประจำตัว',
              ),
            ),
            TextField(
              controller: TextEditingController(text: passwd),
              onChanged: (String value) {
                if (value != '') {
                  setState(() {
                    passwd = value;
                  });
                }
              },
              readOnly: mode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'password(1-15 characters)',
              ),
            ),
            TextField(
              controller: TextEditingController(text: passwd),
              onChanged: (String value) {
                if (value != '') {
                  setState(() {
                    w = double.parse(value);
                  });
                }
              },
              readOnly: mode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'retype password(1-15 characters)',
              ),
            ),
            TextField(
              controller: TextEditingController(text: fname),
              onChanged: (String value) {
                if (value != '') {
                  setState(() {
                    fname = value;
                  });
                }
              },
              readOnly: mode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
            ),
            TextField(
              controller: TextEditingController(text: lname),
              onChanged: (String value) {
                if (value != '') {
                  setState(() {
                    lname = value;
                  });
                }
              },
              readOnly: mode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Last Name',
              ),
            ),
            TextField(
              controller: TextEditingController(text: org),
              onChanged: (String value) {
                if (value != '') {
                  setState(() {
                    org = value;
                  });
                }
              },
              readOnly: mode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'University',
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  if (buttonName == 'Edit') {
                    mode = false;
                    buttonName = 'Save';
                  } else if (buttonName == 'Register') {
                    insertData(id, passwd, fname, lname, org);
                  } else {
                    if (kDebugMode) {
                      print('update');
                    }
                  }
                });
              },
              child: Text(buttonName),
            ),
            OutlinedButton(
                child: const Text('login'),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        )));
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  final db = MySql();

  void login() async {
    final conn = await db.getConnection();
    String sql = "select * from users where id = ? and password = ?";
    var results = await conn.query(sql, [id, passwd]);

    if (results.isNotEmpty) {
      if (kDebugMode) {
        print("Login Successful");
      }
      mode = true;
      buttonName = 'Edit';
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/page1');
    } else {
      if (kDebugMode) {
        print("Login Failed");
      }
    }

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const Row(
              children: [Text('')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 40,
                  child: TextField(
                    onChanged: (String value1) {
                      if (value1 != '') {
                        setState(() {
                          id = value1;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'รหัสประจำตัว',
                    ),
                  ),
                ),
              ],
            ),
            const Row(
              children: [Text('')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 40,
                  child: TextField(
                    onChanged: (String value1) {
                      if (value1 != '') {
                        setState(() {
                          passwd = value1;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'password',
                    ),
                  ),
                ),
              ],
            ),
            const Row(
              children: [Text('')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      setState(() {
                        login();
                      });
                    },
                    child: const Text('login'),
                  ),
                ),
              ],
            ),
            const Row(
              children: [Text('')],
            ),
            const Row(
              children: [Text('')],
            ),
            Center(
                child: OutlinedButton(
                    child: const Text('Register'),
                    onPressed: () {
                      setState(() {
                        mode = false;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      });
                    })),
          ],
        )));
  }
}
