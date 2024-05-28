import 'package:http/http.dart';
import 'package:mysql_client/mysql_client.dart';

import '../Utils/connection.dart';

class LogsController extends Connection {
  Future create(Request request, Response response) async {
    String idContents = request.url.queryParameters['id_contents'] ?? '';
    if (idContents == '') {
      return null;
    }
    int idUsers = int.parse(request.url.queryParameters['id_users'] ?? '0');
    MySQLConnection connexion = await connect();
    // On prépare la requête
    String query =
        "INSERT INTO logs (id_contents, id_users) VALUES (:id_contents, :id_users)";
    // On remplace les valeurs
    query = query.replaceAll(":id_contents", idContents);
    query = query.replaceAll(":id_users", idUsers.toString());
    // On exécute la requête
    var results = await connexion.execute(query);
    // On affiche les résultats
    print(results);
  }
}
