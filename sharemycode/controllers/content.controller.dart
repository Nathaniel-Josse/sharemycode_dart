import 'package:mysql_client/mysql_client.dart';
import 'package:http/src/request.dart' as req;

import '../Utils/connection.dart';

/// Cette classe s'occupe de contrôler les utilités de création [create],
/// de lecture [read], de mise à jour [update] et de suppression [delete]
/// d'une page de notre site.
///
/// Elle contient également une fonction permettant de vérifier si le contenu
/// est déjà associé à un id existant [doesContentAlreadyExist].
class ContentController extends Connection {
  /// Cette fonction asynchrone s'occupe de créer une page pour notre site.
  ///
  /// Durant son exécution elle analyse la requête [request].
  ///
  /// Elle détermine la date d'expiration de la page et met à jour la requête
  /// avec les informations de l'URL avant de la résoudre.
  Future create(req.Request request) async {
    String content = request.url.queryParameters['content'] ?? '';
    String sharable = request.url.queryParameters['sharable'] ?? '';
    String language = request.url.queryParameters['language'] ?? '';
    Object idUser = request.url.queryParameters['id_user'] ?? 0;
    DateTime? expiration =
        idUser == 0 ? DateTime.now().add(Duration(days: 3)) : null;
    if (content == '') {
      return null;
    }
    MySQLConnection connexion = await connect();
    // On prépare la requête
    String query =
        "INSERT INTO contents (content, sharable, language, id_user, expiration) VALUES (':content', ':sharable', ':language', ':id_user', ':expiration')";
    // On remplace les valeurs
    query = query.replaceAll(":content", content);
    query = query.replaceAll(":sharable", sharable);
    query = query.replaceAll(":language", language);
    query = query.replaceAll(":id_user", idUser.toString());
    query = query.replaceAll(":expiration", expiration.toString());
    // On exécute la requête
    var results = await connexion.execute(query);
    // On affiche les résultats
    print(results);
  }

  /// Cette fonction asynchrone s'occupe de lire le contenu de la page.
  ///
  /// Durant son exécution elle analyse la requête [request].
  ///
  /// Elle récupère l'ID ['id'] de cette requête pour en récupérer le contenu
  /// associé et le retourner.
  Future read(req.Request request) async {
    String contentId = request.url.queryParameters['id'] ?? '';
    if (contentId == '') {
      return null;
    }
    MySQLConnection connexion = await connect();
    // On prépare la requête
    String query = "SELECT * FROM users WHERE id_contents = ':contentId'";
    // On remplace les valeurs
    query = query.replaceAll(":contentid", contentId);
    // On exécute la requête
    var results = await connexion.execute(query);
    // On affiche les résultats
    for (final row in results.rows) {
      String? sharable = row.colByName("sharable");
      //String? expirationDate = row.colByName("expiration");
      //final DateTime now = DateTime.now();
      //final DateFormat formatter = DateFormat('yyyy-MM-dd Hms');
      //final String formatted = formatter.format(now);
      //final String formattedExpiration = formatter.format(expirationDate);

      if (sharable == "1") {
        return row.colByName("content");
      }
      delete(contentId);
      return null;
    }
  }

  /// Cette fonction asynchrone vérifie si le contenu est déjà associé à un id existant.
  ///
  /// A partir d'une requête [request], elle récupère l'id de l'URL et vérifie
  /// si celui-ci est unique dans la base de données.
  Future doesContentAlreadyExist(req.Request request) async {
    String id = request.url.queryParameters['id'] ?? '';
    if (id == '') {
      return null;
    }
    MySQLConnection connexion = await connect();
    // On prépare la requête
    String query = "SELECT * FROM users WHERE id_contents = ':id'";
    // On remplace les valeurs
    query = query.replaceAll(":id", id);
    // On exécute la requête
    var results = await connexion.execute(query);
    // On affiche les résultats
    if (results.rows.isNotEmpty) {
      return true;
    }
    return false;
  }

  /// Cette fonction asynchrone met à jour le contenu de la page.
  ///
  /// En récupérant les données de la requête [request], elle s'assure
  /// qu'elle doit bien récupérer des données si la date d'[expiration]
  /// de la page n'est pas atteinte.
  ///
  /// Elle s'assure également que le contenu de la page est non vide.
  ///
  /// Enfin elle va mettre à jour les données de la requête avant de la résoudre
  /// et d'afficher les résultats de celle-ci.
  Future update(req.Request request) async {
    String content = request.url.queryParameters['content'] ?? '';
    String sharable = request.url.queryParameters['sharable'] ?? '';
    String language = request.url.queryParameters['language'] ?? '';
    Object idUser = request.url.queryParameters['id_user'] ?? 0;
    DateTime? expiration =
        idUser == 0 ? DateTime.now().add(Duration(days: 3)) : null;
    if (content == '') {
      return null;
    }
    MySQLConnection connexion = await connect();
    // On prépare la requête
    String query =
        "UPDATE contents SET content = ':content', sharable = ':sharable', language = ':language', id_user = ':id_user', expiration = ':expiration' WHERE id = ':id'";
    // On remplace les valeurs
    query = query.replaceAll(":content", content);
    query = query.replaceAll(":sharable", sharable);
    query = query.replaceAll(":language", language);
    query = query.replaceAll(":id_user", idUser.toString());
    query = query.replaceAll(":expiration", expiration.toString());
    // On exécute la requête
    var results = await connexion.execute(query);
    // On affiche les résultats
    print(results);
  }

  /// Cette fonction supprime les données d'une page de la base de données.
  ///
  /// Elle va récupérer le contenu associé à un [id] pour supprimer
  /// tout celui-ci, et retourner [null] si l'id est vide au cas où.
  Future delete(id) async {
    if (id == '') {
      return null;
    }
    MySQLConnection connexion = await connect();
    // On prépare la requête
    String query = "DELETE FROM contents WHERE id = ':id'";
    // On remplace les valeurs
    query = query.replaceAll(":id", id);
    // On exécute la requête
    var results = await connexion.execute(query);
    // On affiche les résultats
    print(results);
  }
}
