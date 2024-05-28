import 'package:mysql_client/mysql_client.dart';
import 'package:bcrypt/bcrypt.dart';

import '../Utils/connection.dart';

/// Cette classe s'occupe de contrôler les utilités de connexion ([login])
/// d'un utilisateur à notre site.
///
/// Elle contient aussi les utilités d'inscription ([register]), en vérifiant
/// si le mail d'inscription est unique ([checkEmailUnique]).
class UserController extends Connection {
  /// Cette fonction asynchrone s'occupe de connecter l'utilisateur à notre site.
  ///
  /// Durant son exécution, elle procède aux transactions asynchrones
  /// avec la base de données, vérifiant si le couple [email] et [username]
  /// existe bien.
  ///
  /// Elle s'occupe aussi de vérifier si le mot de passe [password] renseigné
  /// est également celui renseigné dans la base de données.
  Future login(String email, String username, String password) async {
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
      String? pseudo = row.colByName("pseudo");
      print(row.colByName("email"));
      String? email = row.colByName("email");
      String passwordHashed = row.colByName("password") ?? '';

      if (BCrypt.checkpw(password, passwordHashed)) {
        print("Mot de passe correct");
        return {"pseudo": pseudo, "email": email};
      } else {
        print("Mot de passe incorrect");
      }
    }
    // On ferme la connexion
    await disconnect();
  }

  /// Cette fonction asynchrone s'occupe d'inscrire l'utilisateur à notre site.
  ///
  /// Durant son exécution, elle procède aux transactions asynchrones
  /// avec la base de données. Elle va tout d'abord hasher le mot de passe
  /// [password] puis demander à la base de données si l'[email] existe déjà.
  ///
  /// Dans le cas où celui-ci existe déjà on affiche une erreur,
  /// sinon l'on procède à la requête pour insérer les données dans la base.
  Future register(String email, String username, String password) async {
    MySQLConnection connexion = await connect();
    String passwordHashed =
        BCrypt.hashpw(password, BCrypt.gensalt()); // On hash le mot de passe
    // On prépare la requête
    String query =
        "INSERT INTO users (email, pseudo, password) VALUES (':email', ':username', ':password')";
    String doesItAlreadyExist = "SELECT * FROM users WHERE email = ':email'";
    // On remplace les valeurs
    query = query.replaceAll(":email", email);
    query = query.replaceAll(":username", username);
    query = query.replaceAll(":password", passwordHashed);
    doesItAlreadyExist = doesItAlreadyExist.replaceAll(":email", email);
    // On exécute le check
    var mailResults = await connexion.execute(doesItAlreadyExist);
    var allMails = mailResults.rows;
    bool isMailUnique = checkEmailUnique(allMails, email);
    if (isMailUnique) {
      // Si le mail est unique, on exécute la requête
      await connexion.execute(query);
    } else {
      // Si le mail est présent en double, on affiche une erreur
      print("Email déjà utilisé");
    }
    // On ferme la connexion
    await disconnect();
  }

  /// Cette fonction parcourt la liste de [mails] et vérifie si elle contient le
  /// mail à tester [mailtoTest].
  ///
  /// Elle renvoie [true] si le mail est unique, [false] si celui-ci est dans la base de données.
  bool checkEmailUnique(mails, String mailToTest) {
    for (String mail in mails) {
      if (mail == mailToTest) {
        return (false);
      }
    }
    return (true);
  }

  void logout() {
    // Tout doux, on n'a pas encore implémenté le logout
  }
}
