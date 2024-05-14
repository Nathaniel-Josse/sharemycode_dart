import 'package:mysql_client/mysql_client.dart';
import 'package:bcrypt/bcrypt.dart';

import '../Utils/connection.dart';

class UserController extends Connection {
  void login(String email, String username, String password) async {
    MySQLConnection connexion = await connect();
    // On prépare la requête
    String query =
        "SELECT * FROM users WHERE email = ':email' AND pseudo = ':username'";
    // On remplace les valeurs
    query = query.replaceAll(":email", email);
    query = query.replaceAll(":username", username);
    // On exécute la requête
    var results = await connexion.execute(query);
    // On affiche les résultats
    for (final row in results.rows) {
      print(row.colByName("pseudo"));
      print(row.colByName("email"));
      String passwordHashed = row.colByName("password") ?? '';

      if (BCrypt.checkpw(password, passwordHashed)) {
        print("Mot de passe correct");
      } else {
        print("Mot de passe incorrect");
      }
    }
    // On ferme la connexion
    await disconnect();
  }

  void register(String email, String username, String password) async {
    MySQLConnection connexion = await connect();
    String passwordHashed =
        BCrypt.hashpw(password, BCrypt.gensalt()); // On hash le mot de passe
    // On prépare la requête
    String query =
        "INSERT INTO users (email, pseudo, password) VALUES (':email', ':username', ':password')";
    // On remplace les valeurs
    query = query.replaceAll(":email", email);
    query = query.replaceAll(":username", username);
    query = query.replaceAll(":password", passwordHashed);
    // On exécute la requête
    await connexion.execute(query);
    // On ferme la connexion
    await disconnect();
  }
}
