import 'dart:convert';

import 'package:appattivaweb/Model/Cantiere.dart';
import 'package:appattivaweb/Model/Rapporto.dart';
import 'package:appattivaweb/Model/Ristorante.dart';
import 'package:appattivaweb/Model/Utente.dart';
import 'package:appattivaweb/utils/support.dart';

import 'Api.dart';

class RistoranteController {
  static Future<List<Ristorante>> carica(Cantiere c) async {
    Map<String, dynamic> map = {'IdCantiere': c.getIdCantiere().toString()};
    String value = await apiRequest("/ristoranti/carica", map, UrlRequest.POST);
    return (json.decode(value) as Iterable<dynamic>)
        .map((dynamic jsonObject) => Ristorante(
            Cantiere.setIdCantiere(jsonObject["IdCantiere"] as int),
            jsonObject["IdRistorante"] as int,
            jsonObject["Costo"] as int,
            jsonObject["ExtraPreventivo"] as int,
            jsonObject["RagioneSociale"] as String,
            Utente.setIdUtente(jsonObject["IdUtenteInserimento"] as int),
            jsonObject["Data"] as String,
            jsonObject["InseritoDA"] as String))
        .toList();
  }

  static Future<bool> inserisci(Cantiere c, Utente u, String ragioneSociale,
      int costo, String data, int extraPreventivo) async {
    Map<String, dynamic> map = {
      'IdCantiere': c.getIdCantiere(),
      'ExtraPreventivo': extraPreventivo,
      'Data': data,
      'RagioneSociale': ragioneSociale,
      'Costo': costo,
      'IdUtenteInserimento': u.GetIdUtente(),
    };
    String value =
        await apiRequest("/ristoranti/inserimento", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<List<Ristorante>> caricaRistorantiCantiere(
      Cantiere ctemp) async {
    var ret;
    Map<String, dynamic> map = {'IdCantiere': ctemp.getIdCantiere().toString()};
    String value = await apiRequest("/ristoranti/carica", map, UrlRequest.POST);
    ret = json.decode(value);
    var idutente = int.parse(await Storage.leggi("IdUtente"));
    var email = await Storage.leggi("Email");
    var pwd = await Storage.leggi("Password");
    Utente utemp = Utente.init(idutente, email, pwd);

    return (ret as Iterable<dynamic>)
        .map((dynamic jsonObject) => Ristorante.perInserimento(
            ctemp,
            jsonObject["IdRistorante"] as int,
            jsonObject["Costo"] as int,
            jsonObject["Data"] as String,
            jsonObject["ExtraPreventivo"] as int,
            jsonObject["RagioneSociale"] as String,
            utemp))
        .toList();
  }

  static Future<List<Ristorante>> caricadarapporto(Rapporto c) async {
    Map<String, dynamic> map = {'IdRapporto': c.getIdRapporto().toString()};
    String value = await apiRequest(
        "/rapportini/ristorante/caricamento", map, UrlRequest.POST);
    return (json.decode(value) as Iterable<dynamic>)
        .map((dynamic jsonObject) => Ristorante.perRapportino(
            c.getCantiere(),
            jsonObject["RagioneSociale"] as String,
            jsonObject["Costo"] as int,
            jsonObject["Data"] as String,
            jsonObject["IdRistoranteRapportoMobile"] as int))
        .toList();
  }

  static Future<bool> eliminaRistorantedaCantiere(Ristorante rp) async {
    Map<String, dynamic> map = {'IdRistorante': rp.getIdRistorante()};
    String value =
        await apiRequest("/ristoranti/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> eliminaRistoranteRapportino(Ristorante rp) async {
    Map<String, dynamic> map = {'IdRistorante': rp.getIdRistorante()};
    String value = await apiRequest(
        "/rapportini/ristorante/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }
}
