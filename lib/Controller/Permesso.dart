import 'package:appattivaweb/Controller/Api.dart';
import 'package:appattivaweb/Utils/support.dart';

class PermessoController {
  static Future<bool> insert({
    required String data,
    required String oreInizio,
    required String oreFine,
    required String motivazione,
    required String stato,
  }) async {
    Map<String, dynamic> map = {
      'IdUtente': await Storage.leggi("IdUtente"),
      'Data': data,
      'OreInizio': oreInizio,
      'OreFine': oreFine,
      'Motivazione': motivazione,
      'Stato': stato,
    };

    String response =
        await apiRequest("/permesso/inserimento", map, UrlRequest.POST);
    return parseSingleJson(response);
  }
}
