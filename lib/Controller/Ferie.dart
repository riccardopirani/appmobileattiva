import 'dart:convert';
import 'dart:developer';

import 'package:appattiva/Model/Ferie.dart';

import '../Utils/support.dart';
import 'Api.dart';

class FerieController {
  static Future<bool> inserimento(String dataInizio, String dataFine,
      String motivazione, String stato) async {
    bool ret = false;
    if (motivazione.isNotEmpty) {
      var idUtente = await Storage.leggi("IdUtente");
      ret = parseSingleJson(await apiRequest(
          "/ferie/inserimento",
          {
            'IdUtente': idUtente,
            'DataFine': dataFine,
            'DataInizio': dataInizio,
            'Motivazione': motivazione,
            'Stato': stato
          },
          UrlRequest.POST));
    }
    return ret;
  }

  static Future<List<Ferie>> ricerca() async {
    var idUtente = await Storage.leggi("IdUtente");
    List<Ferie> lista = [];
    try {
      String value =
          await apiRequest("/ferie", {"IdUtente": idUtente}, UrlRequest.POST);
      lista = (json.decode(value) as List<dynamic>)
          .map((dynamic jsonObject) => Ferie(
              jsonObject["IdFerie"] as int,
              jsonObject["IdUtente"] as int,
              jsonObject["DataInizio"] ?? "",
              jsonObject["DataFine"] ?? "",
              jsonObject["Motivazione"] ?? "",
              jsonObject["Stato"] ?? ""))
          .toList();
    } catch (err) {
      log("Errore recupero ferie: " + err.toString());
    }

    return lista;
  }
}
