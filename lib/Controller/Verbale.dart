import 'dart:convert';

import 'package:appattiva/Controller/Api.dart';

class VerbaleController {
  /// 📥 CREA un nuovo verbale
  static Future<bool> inserisciVerbale(
      int idCantiere, String base64, String tipo) async {
    print("sono in inseriemento verbale");
    final map = {
      'IdCantiere': idCantiere,
      'base64': base64,
      'Tipo': tipo,
    };

    final value = await apiRequest("/verbale", map, UrlRequest.POST);
    return true;
  }

  /// 📄 LEGGI tutti i verbali per cantiere
  static Future<List<dynamic>> caricaVerbali(int idCantiere) async {
    final map = {
      'IdCantiere': idCantiere,
    };
    final value = await apiRequest("/verbale/lista", map, UrlRequest.POST);
    final jsonList = json.decode(value) as List<dynamic>? ?? [];
    return jsonList;
  }

  /// 🖊️ AGGIORNA il verbale per cantiere
  static Future<bool> aggiornaVerbale(int idCantiere, String base64) async {
    final map = {
      'IdCantiere': idCantiere,
      'base64': base64,
    };
    final value = await apiRequest("/verbale/aggiorna", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  /// ❌ ELIMINA il verbale
  static Future<bool> eliminaVerbale(int idCantiere) async {
    final map = {
      'IdCantiere': idCantiere,
    };
    final value = await apiRequest("/verbale/elimina", map, UrlRequest.POST);
    return parseSingleJson(value);
  }
}
