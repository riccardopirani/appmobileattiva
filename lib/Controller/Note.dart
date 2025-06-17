import 'dart:convert';

import 'package:appattivaweb/Model/Impianto.dart';
import 'package:appattivaweb/Model/Note.dart';
import 'package:appattivaweb/utils/support.dart';

import 'Api.dart';

class NoteController {
  static Future<List<Note>> load(Impianto imp) async {
    Map<String, dynamic> map = {'IdImpianto': imp.getIdImpianto()};
    String value =
        await apiRequest("/impianto/note/caricamento", map, UrlRequest.POST);
    List<dynamic> ret = json.decode(value) as List<dynamic>? ?? [];
    return ret
        .map((dynamic jsonObject) => Note(
              jsonObject["IdNoteimpianto"] as int,
              jsonObject["Testo"] as String,
              jsonObject["Data"] as String,
              jsonObject["Utente"] as String,
              imp,
            ))
        .toList();
  }

  static Future<bool> insert(Impianto imp, String testo) async {
    Map<String, dynamic> map = {
      'IdImpianto': imp.getIdImpianto(),
      'IdUtente': await Storage.leggi("IdUtente"),
      'testo': testo,
    };
    String value =
        await apiRequest("/impianto/nota/nuovo", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> delete(Note np) async {
    Map<String, dynamic> map = {'IdNota': np.IdNoteimpianto};
    String value =
        await apiRequest("/impianto/note/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }
}
