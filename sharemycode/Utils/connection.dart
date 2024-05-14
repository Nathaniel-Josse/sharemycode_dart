import 'package:mysql_client/mysql_client.dart';
import 'package:dotenv/dotenv.dart';

class Connection {
  Future<MySQLConnection> defineConnection() async {
    var env = DotEnv(includePlatformEnvironment: true)..load();
    final conn = await MySQLConnection.createConnection(
      host: '127.0.0.1',
      port: 3306,
      userName: env['BDD_USER'] ?? 'root',
      password: env['BDD_PASSWORD'] ?? '',
      databaseName: env['BDD_TABLE'],
    );
    return conn;
  }

  Future<MySQLConnection> connect() async {
    print("Connecting to mysql server...");
    MySQLConnection connexion = await defineConnection();
    await connexion.connect();
    return connexion;
  }

  Future<void> disconnect() async {
    print("Disconnecting from mysql server...");
    MySQLConnection connexion = await defineConnection();
    await connexion.close();
    print("Disconnected");
  }
}
