import 'package:mysql1/mysql1.dart';

class MySql {
  static String host = '127.0.0.1', user = 'root', db = 'profiles';
  static int port = 3306;

  MySql();

  Future<MySqlConnection> getConnection() async {
    var settings =
        ConnectionSettings(host: host, port: port, user: user, db: db);
    return await MySqlConnection.connect(settings);
  }

  connect() {}

  getConcertData(String userId) {}
}
