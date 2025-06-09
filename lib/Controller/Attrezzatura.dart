import 'dart:convert';

import 'package:appattiva/Model/Attrezzatura.dart';
import 'package:appattiva/utils/support.dart';

import 'Api.dart';

class AttrezzaturaController {
  static List<Attrezzatura>? _cachedAttrezzature;

  static Future<List<Attrezzatura>> loadStorico() async {
    try {
      final value =
          await apiRequest("/attrezzature/load/storico", {}, UrlRequest.POST);
      final List<dynamic> jsonList = jsonDecode(value);
      _cachedAttrezzature = jsonList
          .map((jsonObject) => Attrezzatura(
                int.tryParse(jsonObject["IdAttrezzature"].toString()) ?? 0,
                int.tryParse(jsonObject["IdUtente"].toString()) ?? 0,
                jsonObject["NomeOggetto"] ?? "",
                jsonObject["Immagine"] ?? "",
                jsonObject["DataCreazione"] ?? "",
                jsonObject["Stato"].toString(),
                jsonObject["Descrizione"] ?? "",
                jsonObject["Utente"] ?? "",
              ))
          .toList();
      return _cachedAttrezzature!;
    } catch (e) {
      print("Error loading storico data: $e");
      return [];
    }
  }

  static Future<Attrezzatura> loadById(String idAttrezzatura) async {
    try {
      final value = await apiRequest("/attrezzature/load", {}, UrlRequest.POST);
      final List<dynamic> jsonList = jsonDecode(value);

      return jsonList
          .map((jsonObject) => Attrezzatura(
              jsonObject["IdAttrezzature"].toString() as int,
              int.parse(jsonObject["IdUtente"]?.toString() ?? '0'),
              jsonObject["NomeOggetto"] ?? "",
              jsonObject["Immagine"] ?? "",
              jsonObject["DataCreazione"] ?? "",
              jsonObject["Stato"].toString(),
              jsonObject["Descrizione"] ?? "",
              jsonObject["Utente"] ?? ""))
          .firstWhere(
            (attrezzatura) => attrezzatura.idAttrezzature == idAttrezzatura,
            orElse: () => Attrezzatura(0, 0, "", "", "", "", "", ""),
          );
    } catch (e) {
      print("Error loading attrezzatura by ID: $e");
      return Attrezzatura(0, 0, "", "", "", "", "", "");
    }
  }

  static Future<List<Attrezzatura>> load() async {
    try {
      final value = await apiRequest("/attrezzature/load", {}, UrlRequest.POST);
      final List<dynamic> jsonList = jsonDecode(value);

      _cachedAttrezzature = jsonList
          .map((jsonObject) => Attrezzatura(
                int.parse(jsonObject["IdAttrezzature"].toString()),
                int.parse(jsonObject["IdUtente"]?.toString() ?? ''),
                jsonObject["NomeOggetto"] ?? "",
                jsonObject["Immagine"] ?? "",
                jsonObject["DataCreazione"] ?? "",
                jsonObject["Stato"].toString(),
                jsonObject["Descrizione"] ?? "",
                jsonObject["Utente"] ?? "",
              ))
          .toList();

      return _cachedAttrezzature!;
    } catch (e) {
      print("Error loading attrezzature data: $e");
      return [];
    }
  }

  static Future<bool> addUtilizzo(
      int idAttrezzature, int stato, String note) async {
    try {
      final map = {
        'IdUtente': await Storage.leggi("IdUtente"),
        'IdAttrezzature': idAttrezzature,
        'Stato': stato.toString(),
        'Note': note,
      };

      final value =
          await apiRequest("/attrezzature/add/utilizzo", map, UrlRequest.POST);
      return parseSingleJson(value);
    } catch (e) {
      print("Error adding utilizzo: $e");
      return false;
    }
  }

  static Future<bool> add(
      String descrizione, String nomeOggetto, String immagine) async {
    try {
      final map = {
        'IdUtente': await Storage.leggi("IdUtente"),
        'NomeOggetto': nomeOggetto,
        'Immagine': immagine,
        'Descrizione': descrizione,
      };

      final value = await apiRequest("/attrezzature/add", map, UrlRequest.POST);
      return parseSingleJson(value);
    } catch (e) {
      print("Error adding attrezzatura: $e");
      return false;
    }
  }
}
