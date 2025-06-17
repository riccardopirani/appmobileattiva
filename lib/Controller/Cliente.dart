import 'dart:convert';

import 'package:appattivaweb/Model/Cliente.dart';
import 'package:appattivaweb/Model/Filiale.dart';
import 'package:flutter/foundation.dart';

import 'Api.dart';

class ClienteController {
  static final Map<String, List<Cliente>> _clientiCache = {};
  static final Map<int, List<Filiale>> _filialiCache = {};

  static Future<List<Cliente>> ricercaCliente(String ragioneSociale) async {
    if (_clientiCache.containsKey(ragioneSociale)) {
      return _clientiCache[ragioneSociale]!;
    }

    String response = await apiRequest(
      "/cliente/ricerca",
      {'TestoRicerca': ragioneSociale},
      UrlRequest.POST,
    );
    List<Cliente> clienti = await compute(_parseClienti, response);

    _clientiCache[ragioneSociale] = clienti;

    return clienti;
  }

  static List<Cliente> _parseClienti(String responseBody) {
    final Iterable<dynamic> parsed = json.decode(responseBody);
    return parsed.map<Cliente>((dynamic jsonObject) {
      return Cliente(
        idCliente: jsonObject["IdCliente"] as int,
        ragioneSociale: jsonObject["RagioneSociale"] as String,
        indirizzo: jsonObject["Indirizzo"] ?? "",
        filiale: jsonObject["Citta"] ?? "",
        citta: jsonObject["Citta"] ?? "",
      );
    }).toList();
  }

  static Future<List<Filiale>> recuperaFiliale(Cliente c) async {
    if (_filialiCache.containsKey(c.getIdCliente())) {
      print("Returning cached Filiali data");
      return _filialiCache[c.getIdCliente()]!;
    }

    String response = await apiRequest(
      "/cantieri/caricafilialicliente",
      {'IdCliente': c.getIdCliente().toString()},
      UrlRequest.POST,
    );

    List<Filiale> filiali = await compute(_parseFiliali, response);

    _filialiCache[c.getIdCliente()] = filiali;

    return filiali;
  }

  static List<Filiale> _parseFiliali(String responseBody) {
    final Iterable<dynamic> parsed = json.decode(responseBody);
    return parsed.map<Filiale>((dynamic jsonObject) {
      return Filiale(
        jsonObject["IdFiliale"] as int,
        jsonObject["Citta"] as String,
      );
    }).toList();
  }
}
