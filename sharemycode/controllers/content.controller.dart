import 'dart:ffi';

import 'package:http/http.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:intl/intl.dart';
import 'package:shelf/shelf.dart';
import 'package:http/src/request.dart' as req;
import 'package:http/src/response.dart' as res;

import '../Utils/connection.dart';

class CodeController extends Connection {
  Future read(req.Request request, res.Response response) async {
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

  Future doesContentAlreadyExist(
      req.Request request, res.Response response) async {
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

  Future create(req.Request request, res.Response response) async {
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

  Future update(req.Request request, res.Response response) async {
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
