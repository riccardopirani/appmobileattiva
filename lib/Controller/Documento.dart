import 'dart:convert';

import 'package:appattiva/Model/Documento.dart';
import 'package:appattiva/Model/Impianto.dart';
import 'package:appattiva/utils/support.dart';

import 'Api.dart';

class DocumentoController {
  static Future<List<Documento>> load(Impianto imp) async {
    Map<String, dynamic> map = {'IdImpianto': imp.getIdImpianto()};
    String value =
        await apiRequest("/impianto/documenti/carica", map, UrlRequest.POST);
    final List<dynamic> ret = json.decode(value) as List<dynamic>;
    return ret
        .map((dynamic jsonObject) => Documento(
              jsonObject["IdDoc"] as int,
              jsonObject["Utente"] as String,
              imp,
              jsonObject["Testo"] as String,
            ))
        .toList();
  }

  static Future<bool> delete(Documento np) async {
    Map<String, dynamic> map = {'IdDocumento': np.IdDoc};
    String value =
        await apiRequest("/impianto/documento/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<String?> getfile(Documento dp) async {
    Map<String, dynamic> map = {'IdDocumento': dp.IdDoc};
    String value =
        await apiRequest("/impianto/documenti/getfile", map, UrlRequest.POST);
    parseSingleJson(value);
    final server = await Storage.leggi("Server");
    if (server != null) {
      return "$server/${dp.Testo}";
    }
    return null;
  }
}
