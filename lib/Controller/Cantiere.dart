import 'dart:convert';

import 'package:appattiva/Model/Cantiere.dart';
import 'package:appattiva/Model/Cliente.dart';
import 'package:appattiva/Model/Filiale.dart';
import 'package:appattiva/Model/Preventivo.dart';
import 'package:appattiva/Model/Utente.dart';
import 'package:appattiva/utils/support.dart';

import 'Api.dart';

class CantiereController {
  static Future<List<Cantiere>> ricercaCantieriperRapportino() async {
    String value = await apiRequest(
        "/cantieri/ricercacantierirapportini", {}, UrlRequest.POST);
    return decodeList(value);
  }

  static Future<List<Cantiere>> Ricerca(
      Utente u,
      int IdCantiere,
      String NomeCantiere,
      String RagioneSociale,
      bool isUtente,
      int IdFiliale) async {
    Map<String, dynamic> map = {
      'IdUtente': u.GetIdUtente(),
      'IdCantiere': IdCantiere,
      'NomeCantiere': NomeCantiere,
      'RagioneSociale': RagioneSociale,
      'CheckBoxCantieriCreatiDaUtenteLoggato': isUtente,
      'VisualizzaCantieriChiusi': "false",
      'IdFiliale': IdFiliale
    };
    String value = await apiRequest("/cantieri/ricerca", map, UrlRequest.POST);
    List<Cantiere> list = decodeList(value);
    return list;
  }

  static Future<Cantiere> calcoloTotale(Cantiere c) async {
    Map<String, dynamic> map = {'IdCantiere': c.getIdCantiere()};
    String value =
        await apiRequest("/cantieri/calcolototale", map, UrlRequest.POST);
    var list = (json.decode(value) as Iterable<dynamic>)
        .map((dynamic jsonObject) => Cantiere.setCantiere(
            c.getIdCantiere(),
            jsonObject["TotaleCostoCantiere"] as String,
            jsonObject["TotaleCostoCantiereFatturazione"] as String,
            jsonObject["TotaleExtra"] as String))
        .toList();
    return list[0];
  }

  static Future<Cantiere> generaCantiereConsuntivo(String nomecantiere) async {
    var idFiliale = 0;
    try {
      idFiliale = int.parse(await Storage.leggi("IdFilialeSelezionata"));
    } catch (ex) {
      idFiliale = 0;
    }
    Map<String, dynamic> map = {
      'IdUtente': await Storage.leggi("IdUtente"),
      'IdCliente': await Storage.leggi("IdClienteSelezionato"),
      'Tipo': "Consuntivo",
      'NomeCantiere': nomecantiere,
      'IdFiliale': idFiliale,
    };
    String value =
        await apiRequest("/cantieri/generacantiere", map, UrlRequest.POST);
    List<Cantiere> list = decodeList(value);
    return list[0];
  }

  static List<Cantiere> decodeList(String valuejson) {
    try {
      final List<dynamic> jsonList =
          json.decode(valuejson); // Decode the JSON string
      // Map the decoded list into a list of Cantiere objects
      return jsonList.map((dynamic jsonObject) {
        return Cantiere(
          Cliente(
            idCliente: jsonObject["IdCliente"] as int,
            ragioneSociale: jsonObject["RagioneSociale"] ?? "",
            indirizzo: jsonObject["Indirizzo"] ?? "",
            filiale: jsonObject["Filiale"] ?? "",
            citta: jsonObject["Citta"] ?? "",
          ),
          jsonObject["IdCantiere"] ?? 0,
          jsonObject["NomeCantiere"] ?? "",
          jsonObject["DescrizioneEstesa"] ?? "",
          jsonObject["Tipologia"] ?? "",
          jsonObject["StatoCantiere"] ?? "",
          jsonObject["StatoFatturazione"] ?? 0,
          jsonObject["DataCreazioneCantiere"] ?? "",
          jsonObject["Commessa"] ?? "",
          jsonObject["IdFilialeCliente"] ?? 0,
          jsonObject["Indirizzo"] ?? "",
          jsonObject["CommessaCliente"] ?? "",
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Object> aggiornaCantiere(Cantiere c) async {
    var username = await Storage.leggi("Username");
    Map<String, dynamic> map = {
      'IdCantiere': c.getIdCantiere(),
      'Stato': c.getStato(),
      'DescrizioneEstesa': c.getDescrizione(),
      'StatoFatturazione': 0,
      'NomeCantiere': c.getNomeCantiere(),
      'CommessaCliente': c.getCommessaCliente(),
      "Utente": username
    };
    try {
      String value =
          await apiRequest("/cantieri/aggiornacantiere", map, UrlRequest.POST);
      return value;
    } catch (err) {
      return "false";
    }
  }

  static Future<Cantiere> generaCantierePreventivo(Preventivo p) async {
    Map<String, dynamic> map = {
      'IdCliente': p.getIdCliente().toString(),
      'IdUtente': await Storage.leggi("IdUtente"),
      'NomeCantiere': p.getRiferimentoInterno().toString(),
      'Tipo': "Preventivo",
      'IdPreventivo': p.getIdPreventivo().toString(),
    };
    String value =
        await apiRequest("/cantieri/generacantiere", map, UrlRequest.POST);
    List<Cantiere> list = decodeList(value);
    return list[0];
  }

  static Future<Filiale> recuperaFiliale(Cliente c) async {
    Map<String, dynamic> map = {'IdCliente': c.getIdCliente().toString()};
    String value = await apiRequest(
        "/cantieri/caricafilialicliente", map, UrlRequest.POST);
    var list = (json.decode(value) as Iterable<dynamic>)
        .map((dynamic jsonObject) => Filiale(
            jsonObject["IdFiliale"] as int, jsonObject["Citta"] as String))
        .toList();
    return list[0];
  }

  static Future<List<Preventivo>> getListaPreventivi() async {
    String value = await apiRequest(
        "/preventivo/caricapreventivosenzacantiere", {}, UrlRequest.POST);
    return (json.decode(value) as Iterable<dynamic>)
        .map((dynamic jsonObject) => Preventivo(
              jsonObject["IdPreventivo"] as int,
              jsonObject["IdCliente"] as int,
              jsonObject["RagioneSociale"] as String,
              jsonObject["RiferimentoInterno"] as String,
            ))
        .toList();
  }
}
