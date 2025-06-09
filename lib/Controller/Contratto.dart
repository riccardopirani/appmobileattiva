import 'dart:convert';

import 'package:appattiva/Model/Contratto.dart';

import 'Api.dart';

class ContrattoController {
  static Future<List<Contratto>> carica() async {
    String value = await apiRequest("/contratti/load", {}, UrlRequest.POST);
    return (json.decode(value) as List<dynamic>)
        .map((e) => Contratto.fromJson(e))
        .toList();
  }

  static Future<bool> attivaContratto(String contrattoID) async {
    String result = await apiRequest(
      "/contratti/activate",
      {"ContrattoID": contrattoID},
      UrlRequest.POST,
    );
    return json.decode(result)["return"] == true;
  }

  static Future<Contratto?> dettaglio(int idContratto) async {
    String value = await apiRequest("/contratti/load/detail",
        {"ContrattoID": idContratto}, UrlRequest.POST);
    if (value.isEmpty) return null;
    return Contratto.fromJson(json.decode(value));
  }

  static Future<bool> aggiungi(Contratto contratto) async {
    String result =
        await apiRequest("/contratti/add", contratto.toJson(), UrlRequest.POST);
    return json.decode(result)["return"] == true;
  }

  static Future<bool> aggiorna(Contratto contratto) async {
    String result = await apiRequest(
        "/contratti/update", contratto.toJson(), UrlRequest.POST);
    return json.decode(result)["return"] == true;
  }

  static Future<bool> elimina(int contrattoID) async {
    String result = await apiRequest(
        "/contratti/delete", {"ContrattoID": contrattoID}, UrlRequest.POST);
    return json.decode(result)["return"] == true;
  }
}
