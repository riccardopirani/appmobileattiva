import 'dart:convert';
import 'dart:typed_data';

import 'package:appattivaweb/Model/Utente.dart';
import 'package:appattivaweb/utils/support.dart';
import 'package:http/http.dart' as http;

import 'Api.dart';

class UtenteController {
  static Future<Uint8List> getFirma(int idutente) async {
    Uint8List tempvar = Uint8List(0);
    try {
      String value = await apiRequest("/utente/getfirma",
          {'IdUtente': idutente.toString()}, UrlRequest.POST);
      Map<String, dynamic> valueMap = json.decode(value);
      String val = valueMap['return'].toString();
      if (val == "true") {
        String imageUrl = await _constructImageUrl();
        tempvar = await _fetchImageBytes(imageUrl);
      } else {
        tempvar = Uint8List(0);
      }
    } catch (err) {
      tempvar = Uint8List(0);
    }
    return tempvar;
  }

  static Future<String> _constructImageUrl() async {
    String server = await Storage.leggi("Server");
    String port = await Storage.leggi("Porta2");
    return "$server:$port/firmatecnico.png";
  }

  static Future<Uint8List> _fetchImageBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return Uint8List(0);
      }
    } catch (err) {
      return Uint8List(0);
    }
  }

  Future<int> login(String email, String password) async {
    try {
      final payload = {
        'Username': email,
        'Password': password,
      };

      final response = await apiRequest("/login", payload, UrlRequest.POST);
      final Map<String, dynamic> decoded = json.decode(response);

      final int result = int.parse(decoded['return'].toString());
      return result;
    } catch (e) {
      // Log or handle the error as needed
      print('Login error: $e');
      return 0; // Or any error code you want
    }
  }

  Future<int> registrazione(String email, String username, String pwd,
      String name, String surname) async {
    var ret = 0;
    Map<String, dynamic> map = {
      'Tipo': "Utente",
      'Username': username,
      'Password': pwd,
      'Nome': name,
      'Cognome': surname,
      'Azienda': 'mobile',
      'Email': email,
      'CostoFatturazione': '0',
      'CostoInterno': '0',
      'IdAzienda': '1',
      'Stato': 'enable'
    };
    String value =
        await apiRequest("/utente/nuovoutente", map, UrlRequest.POST);
    Map<String, dynamic> valueMap = json.decode(value);
    var parsed = valueMap['return'].toString();
    if (parsed == "true") {
      map = {
        'email': email,
        'name': "$name $surname",
        'password': pwd,
        'phone': '0000000'
      };
      value = await apiRequest("/payment/create-account", map, UrlRequest.POST);
    }
    return ret;
  }

  static Future<List<Utente>> caricaValori(int idutente) async {
    Map<String, dynamic> map = {'IdUtente': idutente};
    var profiloImmagine = await Utente.getProfiloImmagine();
    String value =
        await apiRequest("/utente/caricavaloriutente", map, UrlRequest.POST);
    var ret = json.decode(value);
    return (ret as Iterable<dynamic>)
        .map((dynamic jsonObject) => Utente.completo(
            idutente,
            jsonObject["Nome"] as String,
            jsonObject["Cognome"] as String,
            jsonObject["Telefono"] as String,
            jsonObject["Email"] as String,
            profiloImmagine,
            jsonObject["AccessoCantieri"],
            jsonObject["AccessoImpianti"]))
        .toList();
  }

  static Future<bool> aggiornaimmagineprofilo(String base64) async {
    Map<String, dynamic> map = {
      'IdUtente': await Storage.leggi("IdUtente"),
      'ImmagineProfilo': base64
    };
    String value = await apiRequest(
        "/utente/aggiorna/immagineprofilo", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> inviosegnalazione(double lat, double lon) async {
    Map<String, dynamic> map = {
      'Nome': await Storage.leggi("Nome"),
      'Cognome': await Storage.leggi("Cognome"),
      'Latitudine': lat,
      'Longitudine': lon
    };
    String value =
        await apiRequest("/utente/invio/segnalazione", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<String> getImageProfilo() async {
    String server = await Storage.leggi("Server");
    String idUtente = await Storage.leggi("IdUtente");
    return "$server/$idUtente.png";
  }
}
