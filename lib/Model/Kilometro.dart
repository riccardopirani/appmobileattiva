import 'dart:async';

import 'package:appattivaweb/Controller/Kilometro.dart';
import 'package:appattivaweb/Model/Fornitore.dart';
import 'package:appattivaweb/Model/Rapporto.dart';

class Kilometro {
  int idKilometro = 0;
  int idKilometroRapportoMobile = 0;
  int idRapportoMobile = 0;
  int extraPreventivo = 0;
  String tipomezzo = "";
  String targa = "";
  String data = "";
  String kilometri = "";
  String costo = "";
  String dirittochiamata = "";
  Rapporto? rapporto;
  Fornitore? fornitore;

  bool selected = false;

  Kilometro({
    required this.idKilometro,
    required this.idKilometroRapportoMobile,
    required this.idRapportoMobile,
    required this.extraPreventivo,
    required this.dirittochiamata,
    required this.kilometri,
    required this.costo,
    required this.tipomezzo,
    required this.targa,
    required this.data,
    this.rapporto,
    this.fornitore,
  });

  Kilometro.perRapportino({
    required this.idKilometroRapportoMobile,
    required this.idRapportoMobile,
    required this.extraPreventivo,
    required this.dirittochiamata,
    required this.kilometri,
    required this.costo,
    required this.tipomezzo,
    required this.targa,
    required this.data,
    required this.rapporto,
    this.fornitore,
  });

  Kilometro.perCantieri({
    required this.idKilometro,
    required this.extraPreventivo,
    required this.dirittochiamata,
    required this.kilometri,
    required this.costo,
    required this.tipomezzo,
    required this.targa,
    required this.data,
    required this.rapporto,
    required this.idRapportoMobile,
    this.fornitore,
  });

  int? getIdKilometro() => idKilometro;

  int? getIdKilometroRapportoMobile() => idKilometroRapportoMobile;

  String? getDirittochiamata() => dirittochiamata;

  String? getKilometri() => kilometri;

  String? getCosto() => costo;

  String? getTipomezzo() => tipomezzo;

  String? getTarga() => targa;

  String? getData() => data;

  static Future<bool> inserisci(Rapporto rapporto, Kilometro kilometro) async {
    final controller = KilometroController(rapporto, kilometro);
    return await controller.inserisci();
  }

  static Future<List<Kilometro>> carica(Rapporto rapporto) async {
    return await KilometroController.carica(rapporto);
  }

  static Future<bool> eliminaKilometroRapportino(Kilometro kilometro) async {
    return await KilometroController.eliminaKilometroRapportino(kilometro);
  }

  static Future<String> getCostoKilometrico(int cliente) async {
    return await KilometroController.getCostoKilometrico(cliente);
  }

  static Future<List<Kilometro>> caricaperCantiere() async {
    return await KilometroController.caricaperCantiere();
  }

  static Future<bool> eliminaKilometroCantiere(Kilometro kilometro) async {
    return await KilometroController.eliminaKilometroCantiere(kilometro);
  }

  Future<bool> inserisciinCantiere(int extra) async {
    final controller = KilometroController.perCantieri(this);
    return await controller.inserisciinCantiere(extra);
  }
}
