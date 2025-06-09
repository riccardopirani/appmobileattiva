import 'dart:convert';

import 'package:appattiva/Controller/Api.dart';
import 'package:appattiva/Model/Cantiere.dart';
import 'package:appattiva/Model/Impianto.dart';
import 'package:appattiva/utils/support.dart';

class ImpiantoController {
  static Future<List<Impianto>> ricerca(
      String ragioneSociale, int idImpianto) async {
    Map<String, dynamic> map = {
      "IdImpianto": idImpianto,
      "RagioneSociale": ragioneSociale
    };
    String value = await apiRequest("/impianto/ricerca", map, UrlRequest.POST);
    return (json.decode(value) as List<dynamic>)
        .map((dynamic jsonObject) => Impianto(
            jsonObject["IdImpianto"] as int,
            jsonObject["nomeTipologia"] as String,
            jsonObject["RagioneSociale"] as String,
            jsonObject["DataInserimento"] as String,
            jsonObject["Utente"] as String,
            jsonObject["Filiale"] as String,
            jsonObject["Citta"] as String,
            jsonObject["IdFiliale"] as int,
            jsonObject["IdCliente"] as int,
            jsonObject["Indirizzo"] as String))
        .toList();
  }

  static Future<Impianto?> ricercaPerIdImpianto(int idImpianto) async {
    List<Impianto> impianti = await ricerca("", idImpianto);

    for (Impianto impianto in impianti) {
      if (impianto.idImpianto == idImpianto) {
        return impianto;
      }
    }

    return null;
  }

  static Future<bool> delete(Impianto impianto) async {
    Map<String, dynamic> map = {'IdImpianto': impianto.idImpianto};
    String value = await apiRequest("/impianto/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> nuovo() async {
    int idFiliale;
    try {
      idFiliale = int.parse(await Storage.leggi("IdFilialeSelezionata"));
    } catch (ex) {
      idFiliale = 0;
    }

    Map<String, dynamic> map = {
      'IdUtente': await Storage.leggi("IdUtente"),
      'IdCliente': await Storage.leggi("IdClienteSelezionato"),
      'IdFiliale': idFiliale,
      'IdTipologia': await Storage.leggi("TipologiaSelezionata")
    };

    String value = await apiRequest("/impianto/nuovo", map, UrlRequest.POST);

    try {
      Map<String, dynamic> jsonResponse = jsonDecode(value);
      int returnValue = jsonResponse["return"];
      Storage.salva("IdImpianto", returnValue.toString());
      return true;
    } catch (err) {
      print("Error: ${err.toString()}");
      return false;
    }
  }

  static Future<bool> uploadfile(
      Impianto impianto, String base64file, String filename) async {
    Map<String, dynamic> map = {
      'IdImpianto': impianto.idImpianto,
      'IdUtente': await Storage.leggi("IdUtente"),
      'File': base64file,
      'FileName': filename
    };
    String value =
        await apiRequest("/impianto/uploadfile", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<String> avvioassistenza(
      Impianto impianto, String stato, Cantiere cantiere, String note) async {
    Map<String, dynamic> map = {
      'IdImpianto': impianto.getIdImpianto(),
      'IdUtente': await Storage.leggi("IdUtente"),
      'Stato': stato,
      'Note': note,
      'IdCantiere': cantiere.getIdCantiere().toString()
    };
    String value = await apiRequest(
        "/impianto/inserimento/assistenza", map, UrlRequest.POST);
    Map<String, dynamic> decodedResponse = jsonDecode(value);
    String returnValue = decodedResponse['return'];
    return returnValue;
  }

  static Future<String> getImpiantoOpen() async {
    Map<String, dynamic> map = {'IdUtente': await Storage.leggi("IdUtente")};
    String value =
        await apiRequest("/impianto/assistenza/aperta", map, UrlRequest.POST);
    return parseSingleJson(value).toString();
  }
}
