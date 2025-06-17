import 'dart:convert';

import 'package:appattivaweb/Model/Rapporto.dart';
import 'package:appattivaweb/Model/SpeseSostenute.dart';
import 'package:appattivaweb/Model/Utente.dart';
import 'package:appattivaweb/utils/support.dart';

import 'Api.dart';

class SpeseSostenuteController {
  static Future<bool> inseriscidentroCantiere(
      SpeseSostenute sps, int extra) async {
    Map<String, dynamic> map = {
      'IdCantiere': await Storage.leggi("IdCantiere"),
      'Causale': sps.getCausale(),
      'Costo': sps.getCosto().toString(),
      'DescrizioneLibera': sps.getDescrizione(),
      'Ricarico': sps.getRicarico().toString(),
      'Data': sps.getData().toString(),
      'IdUtenteInserimento': await Storage.leggi("IdUtente"),
      'ExtraPreventivo': extra.toString(),
    };
    String value =
        await apiRequest("/SpeseSostenute/Inserimento", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> inseriscidentroRapportino(
      Rapporto rptemp, SpeseSostenute sps) async {
    Map<String, dynamic> map = {
      'IdRapporto': rptemp.getIdRapporto(),
      'Causale': sps.getCausale(),
      'Costo': sps.getCosto().toString(),
      'Descrizione': sps.getDescrizione(),
      'Ricarico': sps.getRicarico().toString(),
      'Data': sps.getData().toString(),
    };
    String value = await apiRequest(
        "/rapportini/spesesostenute/inserimento", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<List<SpeseSostenute>> caricadacantiere() async {
    Map<String, dynamic> map = {
      'IdCantiere': await Storage.leggi("IdCantiere")
    };
    String value =
        await apiRequest("/SpeseSostenute/CaricaSpese", map, UrlRequest.POST);
    Utente u = await Utente.getUser();
    return (json.decode(value) as Iterable<dynamic>)
        .map((dynamic jsonObject) => SpeseSostenute.perCantiere(
              jsonObject["IdSpeseSostenute"] ?? 0,
              jsonObject["ExtraPreventivo"] ?? 0,
              u,
              jsonObject["Causale"] ?? "",
              jsonObject["Descrizione"] ?? "",
              jsonObject["Data"] ?? "",
              jsonObject["Costo"] ?? 0,
              jsonObject["Ricarico"] ?? 0,
            ))
        .toList();
  }

  static Future<List<SpeseSostenute>> caricadarapporto(Rapporto rc) async {
    Map<String, dynamic> map = {'IdRapporto': rc.getIdRapporto()};
    String value = await apiRequest(
        "/rapportini/spesesostenute/caricamento", map, UrlRequest.POST);
    Utente u = await Utente.getUser();
    return (json.decode(value) as Iterable<dynamic>)
        .map((dynamic jsonObject) => SpeseSostenute.perRapportino(
              jsonObject["IdSpeseSostenuteRapportoMobile"] as int,
              jsonObject["IdRapportoMobile"] as int,
              jsonObject["ExtraPreventivo"] as int,
              u,
              rc,
              jsonObject["Causale"] as String,
              jsonObject["Descrizione"] as String,
              jsonObject["Data"] as String,
              jsonObject["Costo"] as int,
              jsonObject["Ricarico"] as int,
            ))
        .toList();
  }

  static Future<bool> eliminadaRapporto(SpeseSostenute sps) async {
    Map<String, dynamic> map = {
      'IdSpesaSostenuta': sps.getidSpeseSostenuteRapportoMobile()
    };
    String value = await apiRequest(
        "/rapportini/spesesostenute/eliminazione", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> eliminadaCantiere(SpeseSostenute sps) async {
    Map<String, dynamic> map = {'IdSpesa': sps.getIdSpese()};
    String value =
        await apiRequest("/SpeseSostenute/Elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }
}
