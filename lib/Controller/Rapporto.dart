import 'dart:convert';

import 'package:appattivaweb/Model/Cantiere.dart' show Cantiere;
import 'package:appattivaweb/Model/Cliente.dart';
import 'package:appattivaweb/Model/Rapporto.dart';
import 'package:appattivaweb/Model/Utente.dart';
import 'package:appattivaweb/utils/support.dart';
import 'package:flutter/foundation.dart';

import 'Api.dart';

class RapportoController {
  static Future<List<Rapporto>> genera(
      Utente utente, Cantiere c, String data) async {
    Map<String, dynamic> map = {
      'IdUtente': utente.GetIdUtente(),
      'IdCantiere': c.getIdCantiere(),
      'Data': data
    };
    String response =
        await apiRequest("/rapportini/crea", map, UrlRequest.POST);
    return decodeJson(response);
  }

  static Future<List<Rapporto>> decodeJson(String value) async {
    return compute(_parseRapporti, value);
  }

  static List<Rapporto> _parseRapporti(String value) {
    Iterable<dynamic> decoded = json.decode(value) as Iterable<dynamic>;

    return decoded.map((dynamic jsonObject) {
      return Rapporto.daCantiere(
        jsonObject["IdRapporto"] as int,
        jsonObject["IdRapportoMobile"] as int,
        Utente.setIdUtente(jsonObject["IdUtenteCreazione"] as int),
        jsonObject["DataInserimento"] as String,
        Cantiere.setbase(
          jsonObject["IdCantiere"] as int,
          jsonObject["NomeCantiere"] as String,
          Cliente(
            idCliente: jsonObject["IdCliente"] as int,
            ragioneSociale: jsonObject["RagioneSociale"] as String,
            indirizzo: jsonObject["Indirizzo"] ?? "",
            filiale: jsonObject["Filiale"] ?? "",
            citta: jsonObject["Citta"] ?? "",
          ),
          jsonObject["Commessa"] as String,
          jsonObject["CommessaCliente"] ?? "",
        ),
        "",
        "",
        jsonObject["Citta"] as String,
      );
    }).toList();
  }

  static Future<List<Rapporto>> ricerca(
      Utente utente, String nomeCantiere) async {
    Map<String, dynamic> map = {
      'IdUtente': utente.GetIdUtente(),
      'NomeCantiere': nomeCantiere,
    };

    String response =
        await apiRequest("/rapportini/ricerca", map, UrlRequest.POST);

    // Call the decoding method, which will run in a background isolate
    return decodeJson(response);
  }

  static Future<bool> elimina(Rapporto rp) async {
    Map<String, dynamic> map = {
      'IdRapporto': rp.getIdRapporto(),
      'IdRapportoUtente': rp.getIdRapportoUtente()
    };
    String response =
        await apiRequest("/rapportini/elimina", map, UrlRequest.POST);
    return parseSingleJson(response);
  }

  static Future<bool> generafirma() async {
    Map<String, dynamic> map = {'IdUtente': await Storage.leggi("IdUtente")};
    String response =
        await apiRequest("/utente/getfirma", map, UrlRequest.POST);
    return parseSingleJson(response);
  }

  static Future<bool> invioFile(
      String base64pdf, int idRapporto, int idCantiere) async {
    Map<String, dynamic> map = {
      'File': base64pdf,
      'IdRapporto': idRapporto.toString(),
      'IdUtente': await Storage.leggi("IdUtente"),
      'NumeroDocumento': idRapporto.toString(),
      'IdCantiere': idCantiere.toString()
    };
    String response =
        await apiRequest("/rapportini/inviorapporto", map, UrlRequest.POST);
    return parseSingleJson(response);
  }

  static Future<String> costoTotaleFatturazione(int idRapporto) async {
    Map<String, dynamic> map = {'IdRapporto': idRapporto};

    try {
      String response = await apiRequest(
          "/rapportini/totalecostofatturazione", map, UrlRequest.POST);

      Map<String, dynamic> valueMap =
          json.decode(response) as Map<String, dynamic>;

      if (valueMap.containsKey('return')) {
        return valueMap['return'].toString();
      } else {
        print('Key "return" not found in the response');
        return "false";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing JSON: $e');
      }
      return "false";
    }
  }

  static Future<bool> salvaNoteTecnicoCliente(
      Rapporto rp, String noteTecnico, String noteCliente) async {
    Map<String, dynamic> map = {
      'NoteTecnico': noteTecnico,
      'IdRapporto': rp.getIdRapportoUtente().toString(),
      'NoteCliente': noteCliente
    };
    String response =
        await apiRequest("/rapportini/salvanote", map, UrlRequest.POST);
    return parseSingleJson(response);
  }

  static Future<List<Rapporto>> recuperoNoteTecnicoCliente(Rapporto rp) async {
    Map<String, dynamic> map = {
      'IdRapporto': rp.getIdRapportoUtente().toString()
    };
    String response =
        await apiRequest("/rapportini/caricanote", map, UrlRequest.POST);
    Iterable<dynamic> decoded = json.decode(response) as Iterable<dynamic>;
    return decoded
        .map((dynamic jsonObject) => Rapporto.daCantiere(
              rp.getIdRapporto(),
              rp.getIdRapportoUtente(),
              rp.getUtente(),
              rp.getData(),
              rp.getCantiere(),
              jsonObject["NoteTecnico"] ?? "",
              jsonObject["NoteCliente"] ?? "",
              "",
            ))
        .toList();
  }

  static Future<bool> inserisciDocumento(
      Rapporto rapporto, String filePdf) async {
    Map<String, dynamic> map = {
      'IdRapporto': rapporto.getIdRapporto(),
      'FilePDf': filePdf
    };
    String response = await apiRequest(
        "/rapportini/inseriscidocumento", map, UrlRequest.POST);
    return parseSingleJson(response);
  }
}
