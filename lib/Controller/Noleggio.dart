import 'dart:convert';

import 'package:appattiva/Model/Cantiere.dart';
import 'package:appattiva/Model/Noleggio.dart';
import 'package:appattiva/Model/Rapporto.dart';
import 'package:appattiva/utils/support.dart';

import 'Api.dart';

class NoleggioController {
  NoleggioController(this.rp, this.np);

  NoleggioController.perCantiere(this.np) : rp = null;

  final Rapporto? rp;
  final Noleggio np;

  Future<bool> inseriscidentroCantiere(Cantiere c, int extraPreventivo) async {
    Map<String, dynamic> map = {
      'IdCantiere': await Storage.leggi("IdCantiere"),
      'IdFornitore': np.f!.getidFornitore(),
      'DataInizioNoleggio': np.getDatainizio().toString(),
      'DataTermineNoleggio': np.getDataFine().toString(),
      'TipoMezzo': np.getTipoMezzo().toString(),
      'CostoNoleggio': np.getCostoNoleggio().toString(),
      'Trasporto': np.getTrasporto().toString(),
      'Matricola': np.getMatricola().toString(),
      'ExtraPreventivo': extraPreventivo,
      'Ricarico': np.getRicarico().toString(),
      'IdUtenteInserimento': await Storage.leggi("IdUtente"),
    };
    String value =
        await apiRequest("/noleggio/inserisci", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  Future<bool> inserisci(int extra) async {
    if (rp == null) return false;
    Map<String, dynamic> map = {
      'IdRapporto': rp!.getIdRapporto(),
      'IdFornitore': np.f!.getidFornitore(),
      'DataInizioNoleggio': np.getDatainizio().toString(),
      'DataTermineNoleggio': np.getDataFine().toString(),
      'TipoMezzo': np.getTipoMezzo().toString(),
      'CostoNoleggio': np.getCostoNoleggio().toString(),
      'Trasporto': np.getTrasporto().toString(),
      'Matricola': np.getMatricola().toString(),
      'ExtraPreventivo': "0",
      'Ricarico': np.getRicarico().toString(),
      'Extra': extra,
    };
    String value = await apiRequest(
        "/rapportini/noleggi/inserimento", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<List<Noleggio>> carica(Rapporto rp) async {
    Map<String, dynamic> map = {'IdRapporto': rp.getIdRapporto().toString()};
    String value = await apiRequest(
        "/rapportini/noleggi/caricamento", map, UrlRequest.POST);
    return (json.decode(value) as List<dynamic>)
        .map((dynamic jsonObject) => Noleggio.perRapportino(
              jsonObject["IdNoleggiRapportoMobile"] as int,
              jsonObject["IdRapportoMobile"] as int,
              jsonObject["DataInizioNoleggio"] as String,
              jsonObject["DataTermineNoleggio"] as String,
              jsonObject["TipoMezzo"] as String,
            ))
        .toList();
  }

  static Future<bool> eliminaNoleggioRapportino(Noleggio rp) async {
    Map<String, dynamic> map = {
      'IdDelete': rp.idNoleggiRapportoMobile.toString(),
    };
    String value = await apiRequest(
        "/rapportini/noleggi/eliminazione", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> eliminaNoleggioCantiere(Noleggio rp) async {
    Map<String, dynamic> map = {
      'IdNoleggio': rp.getIdNoleggio().toString(),
    };
    String value = await apiRequest("/noleggio/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<List<Noleggio>> caricaperCantiere(Cantiere c) async {
    Map<String, dynamic> map = {
      'IdCantiere': await Storage.leggi("IdCantiere")
    };
    String value = await apiRequest("/noleggio/carica", map, UrlRequest.POST);
    return (json.decode(value) as List<dynamic>)
        .map((dynamic jsonObject) => Noleggio.perCantiere(
              jsonObject["IdNoleggio"] as int,
              jsonObject["DataInizioNoleggio"] as String,
              jsonObject["DataTermineNoleggio"] as String,
              jsonObject["TipoMezzo"] as String,
            ))
        .toList();
  }
}
