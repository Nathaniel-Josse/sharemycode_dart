import 'package:mysql_client/mysql_client.dart';
import 'package:dotenv/dotenv.dart';

Future<void> main(List<String> arguments) async {
  // load .env file
  var env = DotEnv(includePlatformEnvironment: true)..load();

  print("Connecting to mysql server...");

  // create connection
  final conn = await MySQLConnection.createConnection(
    host: '127.0.0.1',
    port: 3306,
    userName: env['BDD_USER'] ?? 'root',
    password: env['BDD_PASSWORD'] ?? '',
    databaseName: env['BDD_TABLE'],
  );
  await conn.connect();

  print("Connected");

  // close connection
  await conn.close();
}
