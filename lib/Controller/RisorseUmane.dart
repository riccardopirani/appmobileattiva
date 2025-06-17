import 'dart:async';
import 'dart:convert';

import 'package:appattivaweb/Model/Rapporto.dart';
import 'package:appattivaweb/Model/RisorseUmane.dart';
import 'package:appattivaweb/Model/Tipologia.dart';
import 'package:appattivaweb/utils/support.dart';
import 'package:intl/intl.dart';

import 'Api.dart';

class RisorseUmaneController {
  static Future<bool> inserimentoCantiere(
      int IdCantiere,
      String idtipologia,
      String idRisorsaUmana,
      String data,
      String oreInizio,
      String oreFine,
      String pausa,
      String descrizione,
      int extraPreventivo,
      String ddt) async {
    Map<String, dynamic> map = {
      'IdTipologia': idtipologia,
      'Descrizione': descrizione,
      'IdCantiere': IdCantiere,
      'IdUtente': idRisorsaUmana,
      'Data': data,
      'IdUtenteInserimento': await Storage.leggi("IdUtente"),
      'OreInizio': oreInizio,
      'OreFine': oreFine,
      'Pausa': pausa,
      'ExtraPreventivo': extraPreventivo.toString(),
      'DDT': ddt,
    };

    String value = await apiRequest(
        "/RisorseUmane/InserimentoRisorsa", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<List<RisorseUmane>> carica() async {
    String value =
        await apiRequest("/RisorseUmane/CaricaRisorse", {}, UrlRequest.POST);
    return (json.decode(value) as Iterable<dynamic> ?? const <dynamic>[])
        .map((dynamic jsonObject) => RisorseUmane.perRapportino(
            jsonObject["IdUtente"] as int,
            jsonObject["Username"] as String,
            jsonObject["Nome"] as String,
            jsonObject["Cognome"] as String,
            jsonObject["Azienda"] as String))
        .toList();
  }

  static Future<List<Tipologia>> caricaTipologie() async {
    try {
      String value =
          await apiRequest("/tipologia/caricamento", {}, UrlRequest.POST);
      final jsonResponse = json.decode(value);
      if (jsonResponse is List<dynamic>) {
        return jsonResponse
            .map((dynamic jsonObject) =>
                Tipologia.fromJson(jsonObject as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<bool> inserisci(
      int idRapporto,
      String idtipologia,
      String idRisorsaUmana,
      String data,
      String oreInizio,
      String oreFine,
      String pausa,
      String descrizione) async {
    DateTime dateTime = DateTime.parse(oreInizio);
    String formattedTimeoreInizio = DateFormat('HH:mm').format(dateTime);
    DateTime dateTimeFine = DateTime.parse(oreFine);
    String formattedTimeoreFine = DateFormat('HH:mm').format(dateTimeFine);

    Map<String, dynamic> map = {
      'IdRapporto': idRapporto,
      'IdTipologia': idtipologia,
      'IdRisorsaUmana': idRisorsaUmana,
      'Data': data,
      'OreInizio': formattedTimeoreInizio,
      'OreFine': formattedTimeoreFine,
      'Pausa': pausa,
      'Descrizione': descrizione
    };
    try {
      String value = await apiRequest(
          "/rapportini/risorseumane/inserimento", map, UrlRequest.POST);

      Map<String, dynamic> jsonObject = jsonDecode(value);
      bool returnValue = jsonObject['return'];
      return returnValue;
    } catch (e) {
      return false;
    }
  }

  static Future<List<RisorseUmane>> caricarisorseumanecantiere(int c) async {
    Map<String, dynamic> map = {'IdCantiere': c.toString()};
    String value = await apiRequest(
        "/RisorseUmane/CaricaRisorseCantiere", map, UrlRequest.POST);
    return (json.decode(value) as Iterable<dynamic>)
        .map((dynamic jsonObject) => RisorseUmane.perCantieri(
              jsonObject["IdUtente"] ?? 0,
              jsonObject["Risorsa"] ?? "",
              jsonObject["TotaleOre"] ?? "",
              jsonObject["Descrizione"] ?? "",
              jsonObject["Data"] ?? "",
              jsonObject["IdRisorseUmane"] ?? 0,
              jsonObject["Nome"] ?? "",
              jsonObject["Cognome"] ?? "",
            ))
        .toList();
  }

  static Future<List<RisorseUmane>> caricadarapporto(Rapporto c) async {
    List<RisorseUmane> risorse = [];
    try {
      Map<String, dynamic> map = {'IdRapporto': c.getIdRapporto().toString()};
      String value = await apiRequest(
          "/rapportini/risorseumane/caricamento", map, UrlRequest.POST);
      risorse = (json.decode(value) as Iterable<dynamic>)
          .map((dynamic jsonObject) => RisorseUmane.perRapportinoStampa(
                jsonObject["IdUtente"] as int,
                jsonObject["Risorsa"] ?? "",
                jsonObject["Ore"] ?? "",
                jsonObject["Descrizione"] as String,
                jsonObject["Data"] ?? "",
                jsonObject["IdRisorseUmaneRapportoMobile"] as int,
              ))
          .toList();
    } catch (err) {}
    return risorse;
  }

  static Future<bool> eliminaRisorsaUmanaRapportino(RisorseUmane rp) async {
    Map<String, dynamic> map = {
      'IdRisorseUmaneRapportoMobile': rp.getidRisorseUmaneRapportoMobile()
    };
    String value = await apiRequest(
        "/rapportini/risorseumane/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> eliminaRisorsaUmanaCantiere(RisorseUmane rp) async {
    Map<String, dynamic> map = {
      'IdRisorsaUmana': rp.getidRisorsaUmanaCantiere()
    };
    String value = await apiRequest(
        "/RisorseUmane/eliminarisorsacantiere", map, UrlRequest.POST);
    return parseSingleJson(value);
  }
}
