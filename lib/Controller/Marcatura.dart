import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:intl/intl.dart';
import 'package:appattiva/Model/Marcatura.dart';
import 'package:appattiva/Model/Utente.dart';

import 'Api.dart';

class MarcaturaController {
  double longitudine;
  double latitudine;
  final Utente utente;

  MarcaturaController(this.utente, this.longitudine, this.latitudine);

  static Future<ResocontoMarcature> getListaMarcatureOreCantieri(
      Utente u, String data) async {
    Map<String, dynamic> map = {
      'IdRisorsa': u.GetIdUtente(),
      'dataInizio': data,
      'dataFine': data,
    };
    String value =
        await apiRequest("/risorseumane/getore", map, UrlRequest.POST);
    var list = (json.decode(value) as List<dynamic>)
        .map((dynamic jsonObject) => ResocontoMarcature(
              jsonObject["TotaleOreGiornaliereMarcaTempo"] as String,
              jsonObject["TotaleOreMeseMarcaTempo"] as String,
              jsonObject["TotaleOreMensiliCantiere"] as String,
              jsonObject["TotaleOreGiornaliereCantiere"] as String,
            ))
        .toList();

    return list[0];
  }

  Future<List<Marcatura>> getListaMarcature(String data) async {
    Map<String, dynamic> map = {
      'IdUtente': utente.GetIdUtente().toString(),
      'Data': data,
    };
    String value =
        await apiRequest("/risorseumane/getmarcature", map, UrlRequest.POST);
    return (json.decode(value) as List<dynamic>)
        .map((dynamic jsonObject) => Marcatura.perstoricomarcature(
              utente,
              jsonObject["Longitudine"] as String,
              jsonObject["Latitudine"] as String,
              jsonObject["Stato"] as String,
              jsonObject["Ore"] as String,
              "",
            ))
        .toList();
  }

  Future<bool> insertmarcatura(MarcaturaType mc, String DataCreazione) async {
    String DataCreazioneCast = DataCreazione;
    if (DataCreazione.isEmpty) {
      // Ottieni la data e ora attuale
      DateTime now = DateTime.now();
      // Controlla se la piattaforma è iOS
      if (Platform.isIOS) {
        // Aggiungi 2 ore se la piattaforma è iOS
        DateTime newDateTime = now.add(const Duration(hours: 2));
        DataCreazioneCast =
            DateFormat('dd-MM-yyyy HH:mm:ss').format(newDateTime);
      } else {
        // Usa la data e ora attuali senza modifiche per altre piattaforme
        DataCreazioneCast = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
      }
      print(DataCreazioneCast); // For debugging purposes
    }

    Map<String, dynamic> map = {
      'IdUtente': utente.GetIdUtente(),
      'Longitudine': longitudine,
      'Latitudine': latitudine,
      'Stato': mc.name,
      'DataCreazione': DataCreazioneCast,
    };
    String value = await apiRequest("/Utente/Marcatura", map, UrlRequest.POST);
    return parseSingleJson(value);
  }
}
