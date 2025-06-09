import 'dart:convert';

import 'package:appattiva/Controller/Api.dart';

import '../Model/ArticoloMagazzino.dart';
import '../Model/Magazzino.dart';

class MagazzinoController {
  static Future<bool> creaMagazzino(String nome, String indirizzo) async {
    Map<String, dynamic> map = {"Nome": nome, "Indirizzo": indirizzo};
    String value = await apiRequest("/magazzino/nuovo", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<List<Magazzino>> carica() async {
    String value = await apiRequest("/magazzino/carica", {}, UrlRequest.POST);
    Iterable<dynamic> decoded = json.decode(value) as Iterable<dynamic>;
    return decoded
        .map((dynamic jsonObject) => Magazzino(
              jsonObject['IdMagazzino'],
              jsonObject['Nome'],
              jsonObject['Indirizzo'],
              jsonObject['DataCreazione'],
            ))
        .toList();
  }

  static Future<List<dynamic>> stampa(
      int idMagazzino, int idFornitore, String codArt, String data) async {
    Map<String, dynamic> map = {
      "Magazzino": idMagazzino,
      "Fornitore": idFornitore,
      "CodArt": codArt,
      "Data": data
    };
    String value = await apiRequest("/magazzino/stampa", map, UrlRequest.POST);
    return jsonDecode(value);
  }

  static Future<bool> elimina(int idMagazzino) async {
    Map<String, dynamic> map = {"IdMagazzino": idMagazzino};
    String value = await apiRequest("/magazzino/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<List<dynamic>> recuperaInformazioni(
      String codArt, int idMagazzino) async {
    Map<String, dynamic> map = {"CodArt": codArt, "IdMagazzino": idMagazzino};
    String value = await apiRequest(
        "/magazzino/recuperoinformazioni", map, UrlRequest.POST);
    return jsonDecode(value);
  }

  static Future<bool> caricaArticolo(int idArticolo, int idUtente,
      int idMagazzino, int idFornitore, int quantita) async {
    Map<String, dynamic> map = {
      "IdArticolo": idArticolo,
      "IdUtente": idUtente,
      "IdMagazzino": idMagazzino,
      "IdFornitore": idFornitore,
      "Quantita": quantita
    };
    String value =
        await apiRequest("/magazzino/caricaarticolo", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<List<ArticoloMagazzino>> recuperaArticoli(
      {int idMagazzino = 0,
      int idArticoloMagazzino = 0,
      String codArt = "0",
      String barcode = "0"}) async {
    Map<String, dynamic> map = {
      "IdMagazzino": idMagazzino,
      "IdArticoloMagazzino": idArticoloMagazzino,
      "CodArt": codArt,
      "Barcode": barcode
    };
    String value =
        await apiRequest("/magazzino/recuperaarticoli", map, UrlRequest.POST);
    print("recupera aritcoli");
    print(value);
    return jsonDecode(value);
  }

  static Future<List<ArticoloMagazzino>> recuperaArticoliMagazzino({
    required int idMagazzino,
    required int idArticoloMagazzino,
    String? codArt,
    String? barcode,
  }) async {
    final map = {
      "IdMagazzino": idMagazzino,
      "IdArticoloMagazzino": idArticoloMagazzino,
      "CodArt": codArt ?? "",
      "Barcode": barcode ?? "",
    };

    final value =
        await apiRequest("/magazzino/recuperaarticoli", map, UrlRequest.POST);

    final jsonList = json.decode(value) as List<dynamic>? ?? [];

    return jsonList
        .map((jsonObject) =>
            ArticoloMagazzino.fromJson(jsonObject as Map<String, dynamic>))
        .toList();
  }

  static Future<bool> aggiornaArticolo(
      {required int idArticoloMagazzino,
      required int idMagazzino1,
      required int idMagazzino2,
      required int quantita,
      required int quantitaPrecedente,
      required int idUtente,
      required String modalita,
      required int IdFornitore,
      int? idPreventivo,
      String? descrizione}) async {
    Map<String, dynamic> map = {
      "IdArticoloMagazzino": idArticoloMagazzino,
      "IdMagazzino1": idMagazzino1,
      "IdMagazzino2": idMagazzino2,
      "Quantita": quantita,
      "QuantitaPrecedente": quantitaPrecedente,
      "IdUtente": idUtente,
      "Modalita": modalita,
      "IdPreventivo": idPreventivo ?? 0,
      "Descrizione": descrizione ?? ""
    };
    String value =
        await apiRequest("/magazzino/aggiornaarticolo", map, UrlRequest.POST);
    var ret = parseSingleJson(value) == false;
    if (parseSingleJson(value) == false) {
      ret = await MagazzinoController.caricaArticolo(
          idArticoloMagazzino,
          idUtente,
          idMagazzino1 != null ? idMagazzino1 : idMagazzino2,
          IdFornitore,
          quantita);
    }
    return ret;
  }

  static Future<List<dynamic>> caricaStoricoArticoli(
      int idArticoloMagazzino, int idMagazzino) async {
    Map<String, dynamic> map = {
      "IdArticoloMagazzino": idArticoloMagazzino,
      "IdMagazzino": idMagazzino
    };
    String value = await apiRequest(
        "/magazzino/caricastoricoarticoli", map, UrlRequest.POST);
    return jsonDecode(value);
  }
}
