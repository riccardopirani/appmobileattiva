import 'dart:async';

import 'package:appattiva/Controller/Cliente.dart';
import 'package:appattiva/Model/Filiale.dart';

class Cliente {
  final int idCliente;
  final String ragioneSociale;
  final String indirizzo;
  final String filiale;
  final String citta;

  Cliente({
    required this.idCliente,
    required this.ragioneSociale,
    required this.indirizzo,
    required this.filiale,
    required this.citta,
  });

  Cliente.base(this.idCliente)
      : ragioneSociale = '',
        indirizzo = '',
        filiale = '',
        citta = '';

  String getRagioneSociale() => ragioneSociale;

  String getFiliale() => filiale;

  String getIndirizzo() => indirizzo;

  int getIdCliente() => idCliente;

  String getCitta() => citta;

  static Future<List<Cliente>> ricercaCliente(String ragioneSociale) async {
    return await ClienteController.ricercaCliente(ragioneSociale);
  }

  static Future<List<Filiale>> recuperaFiliale(Cliente cliente) async {
    return await ClienteController.recuperaFiliale(cliente);
  }
}
