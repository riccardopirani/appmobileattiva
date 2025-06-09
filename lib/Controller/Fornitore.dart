import 'dart:convert';

import 'package:appattiva/Model/Fornitore.dart';

import 'Api.dart';

class FornitoreController {
  static Future<List<Fornitore>> carica() async {
    String value =
        await apiRequest("/articolo/caricafornitori", {}, UrlRequest.POST);
    return (json.decode(value) as Iterable<dynamic>)
        .map((dynamic jsonObject) => Fornitore(
            jsonObject["IdFornitore"] as int, jsonObject["Nome"] as String))
        .toList();
  }
}
