import 'dart:convert';

import 'package:appattiva/Controller/Api.dart';

class AttivitaController {
  static Future<List<dynamic>> caricaAttivita() async {
    final value = await apiRequest("/attivita/load", {}, UrlRequest.POST);
    final jsonList = json.decode(value) as List<dynamic>? ?? [];
    return jsonList;
  }

  static Future<bool> inserisciAttivita(
    int idCantiere,
    int idUtente,
    String dataInizio,
    String dataFine,
    String descrizione,
    int idUtenteSend,
  ) async {
    final map = {
      'IdCantiere': idCantiere,
      'IdUtente': idUtente,
      'DataInizio': dataInizio,
      'DataFine': dataFine,
      'Descrizione': descrizione,
      'IdUtenteSend': idUtenteSend
    };
    final value = await apiRequest("/attivita/add", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> assegnaUtenteAttivita(
      int idUtente, int idAttivita) async {
    final map = {
      'IdUtente': idUtente,
      'IdAttivita': idAttivita,
    };
    final value = await apiRequest("/attivita/user/add", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> eliminaAttivita(int idAttivita) async {
    final value = await apiRequest(
      "/attivita/delete/$idAttivita",
      {},
      UrlRequest.DELETE,
    );
    return parseSingleJson(value);
  }
}
