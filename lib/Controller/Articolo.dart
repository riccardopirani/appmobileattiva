import 'dart:convert';

import 'package:appattiva/Controller/Api.dart';
import 'package:appattiva/Model/Articolo.dart';
import 'package:appattiva/Model/Cantiere.dart';
import 'package:appattiva/utils/support.dart';

class Tipologia {
  final int idTipologia;
  final String nomeTipologia;

  Tipologia(this.idTipologia, this.nomeTipologia);

  factory Tipologia.fromJson(Map<String, dynamic> json) {
    return Tipologia(
      json['IdTipologia'] as int,
      json['NomeTipologia'] as String,
    );
  }
}

class ArticoloController {
  static final Map<String, List<Articolo>> _cache = {};

  static Future<List<Articolo>> caricaArticoliRapporto(int idRapporto) async {
    final map = {'IdRapporto': idRapporto};
    final value = await apiRequest(
        "/rapportini/articoli/caricamento", map, UrlRequest.POST);
    final jsonList = json.decode(value) as List<dynamic>? ?? [];
    return jsonList
        .map((jsonObject) => Articolo.perRapporto(
            jsonObject["CodArt"] as String,
            jsonObject["Descrizione"] as String,
            jsonObject["Quantita"] as String,
            jsonObject["IdArticoloRapportoMobile"] as int,
            jsonObject["Fornitore"] as String,
            jsonObject["Data"] as String,
            jsonObject["Prezzo"].toString()))
        .toList();
  }

  static Future<List<Articolo>> ricercaArticoliCantiere(Cantiere c) async {
    final map = {'IdCantiere': c.getIdCantiere().toString()};
    final value = await apiRequest(
        "/articolo/caricaarticolicantiere", map, UrlRequest.POST);
    final jsonList = json.decode(value) as List<dynamic>? ?? [];
    return jsonList
        .map((jsonObject) => Articolo.perCantiere(
            jsonObject["IdArticoloCantiere"] ?? "",
            jsonObject["CodArt"] ?? "",
            jsonObject["Descrizione"] ?? "",
            jsonObject["Prezzo"] ?? "",
            jsonObject["CodEAN"] ?? "",
            jsonObject["CodMarca"] ?? "",
            jsonObject["CodiceValuta"] ?? "",
            jsonObject["Fornitore"] ?? "",
            jsonObject["Importato"] ?? "",
            jsonObject["Quantita"] ?? ""))
        .toList();
  }

  static List<Articolo> decodeList(String jsonValueString) {
    final jsonList = json.decode(jsonValueString) as List<dynamic>? ?? [];
    return jsonList
        .map((jsonObject) => Articolo(
            jsonObject["IdArticolo"] ?? 0,
            jsonObject["CodArt"] ?? "",
            jsonObject["Descrizione"] ?? "",
            jsonObject["Prezzo"] ?? "",
            jsonObject["CodEAN"] ?? "",
            jsonObject["CodMarca"] ?? "",
            jsonObject["CodiceValuta"] ?? "",
            jsonObject["Fornitore"] as String,
            jsonObject["Importato"] as String,
            jsonObject["Quantita"] ?? ""))
        .toList();
  }

  static Future<List<Articolo>> ricerca(String codArt, String codiceBarcode,
      String descrizione, int idarticolo) async {
    final cacheKey = '$codArt|$codiceBarcode|$descrizione|$idarticolo';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }
    final map = {
      'IdArticolo': idarticolo,
      'CodArt': codArt,
      'CodEAN': codiceBarcode,
      'Descrizione': descrizione,
    };
    final value = await apiRequest("/articolo/ricerca", map, UrlRequest.POST);
    final articoli = decodeList(value);
    _cache[cacheKey] = articoli;
    return articoli;
  }

  static Future<List<Tipologia>> caricaTipologie() async {
    try {
      final value =
          await apiRequest("/tipologia/caricamento", {}, UrlRequest.POST);
      final jsonResponse = json.decode(value);

      if (jsonResponse is List<dynamic>) {
        return jsonResponse
            .map((jsonObject) =>
                Tipologia.fromJson(jsonObject as Map<String, dynamic>))
            .toList();
      } else {
        print('Unexpected JSON format: $jsonResponse');
        return [];
      }
    } catch (e) {
      print('Error loading tipologie: $e');
      return [];
    }
  }

  static Future<bool> inserisciinCantiere(
      Cantiere ctemp,
      String quantita,
      String idtipologia,
      Articolo atemp,
      String data,
      int extraPreventivo) async {
    final idCantiere = await Storage.leggi("IdCantiere");
    final idUtente = await Storage.leggi("IdUtente");
    final map = {
      'IdTipologia': idtipologia,
      'IdCantiere': idCantiere,
      'IdUtente': idUtente,
      'CodArt': atemp.getCodArt(),
      'Descrizione': atemp.getDescrizione(),
      'CodMarca': atemp.getCodMarca(),
      'CodiceValuta': atemp.getCodiceValuta(),
      'Prezzo': atemp.getPrezzo().toString(),
      'Quantita': quantita,
      'Fornitore': atemp.getFornitore(),
      'Importato': atemp.getImportato(),
      'Data': data,
      'ExtraPreventivo': extraPreventivo.toString()
    };
    final value =
        await apiRequest("/articolo/inserimentocantiere", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> inserisci(String quantita, int idRapporto,
      String idtipologia, int idArticolo, String data, int extra) async {
    final map = {
      'IdRapportoMobile': idRapporto,
      'IdTipologia': idtipologia,
      'IdArticolo': idArticolo,
      'Quantita': quantita,
      'Data': data,
      'Extra': extra.toString()
    };
    final value = await apiRequest(
        "/rapportini/articolo/inserisci", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> eliminaArticolodaRapportino(Articolo rp) async {
    final map = {'IdArticoloRapportoMobile': rp.getIdArticoloRapportoMobile()};
    final value =
        await apiRequest("/rapportini/articoli/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> eliminaArticolodaCantiere(Articolo rp) async {
    final map = {'IdArticoloCantiere': rp.getIdArticoloCantiere()};
    final value = await apiRequest(
        "/articolo/eliminazionearticolocantiere", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> aggiornamentobarcode(
      Articolo atemp, String Barcode) async {
    final map = {'Barcode': Barcode, 'IdArticolo': atemp.getIdArticolo()};
    final value =
        await apiRequest("/articolo/barcode/associa", map, UrlRequest.POST);
    return parseSingleJson(value);
  }
}
