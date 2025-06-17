import 'dart:async';

import 'package:appattivaweb/Controller/Marcatura.dart' show MarcaturaController;
import 'package:appattivaweb/Model/Utente.dart' show Utente;

enum MarcaturaType { Ingresso, Uscita, Arrivo, Partenza }

class ResocontoMarcature {
  String totOreGiornaliereMarcatempo = "00:00",
      totOreMensiliMarcatempo = "00:00",
      totOreCantieri = "00:00",
      totOreGiornaliereCantieri = "00:00";

  ResocontoMarcature(
      this.totOreGiornaliereMarcatempo,
      this.totOreMensiliMarcatempo,
      this.totOreCantieri,
      this.totOreGiornaliereCantieri);

  String gettotOreGiornaliereMarcatempo() {
    return totOreGiornaliereMarcatempo;
  }

  String gettotOreMensiliMarcatempo() {
    return totOreMensiliMarcatempo;
  }

  String gettotOreCantieriMensili() {
    return totOreCantieri;
  }

  String gettotOreGiornaliere() {
    return totOreGiornaliereCantieri;
  }

  static Future<ResocontoMarcature> getListaMarcatureOreCantieri(
      Utente u, String data) async {
    return await MarcaturaController.getListaMarcatureOreCantieri(u, data);
  }
}

class Marcatura {
  int? idmarcatura;
  double? longitudine, latitudine;
  String? latString, lonString, stato, totaleOre;
  MarcaturaType? type;
  DateTime? data;
  Utente? utente;

  Marcatura(Utente u, double longitudine, double latitudine, DateTime data,
      MarcaturaType type) {
    utente = u;
    this.longitudine = longitudine;
    this.latitudine = latitudine;
    this.data = data;
    this.type = type;
  }

  Marcatura.perstoricomarcature(Utente u, String longitudine, String latitudine,
      String stato, String totaleORE, String s) {
    utente = u;
    latString = latitudine;
    lonString = longitudine;
    this.stato = stato;
    totaleOre = totaleORE;
  }

  Future<bool> insertmarcatura(MarcaturaType mc, String DataCreazione) async {
    var marcatura = MarcaturaController(utente!, longitudine!, latitudine!);
    return await marcatura.insertmarcatura(mc, DataCreazione);
  }

  String getStato() {
    return stato!;
  }

  MarcaturaType getType() {
    return type!;
  }

  String getTotaleOre() {
    return totaleOre!;
  }

  static Future<List<Marcatura>> getListaMarcature(
      Utente u, String data) async {
    var marcatura = MarcaturaController(u, 0, 0);
    return await marcatura.getListaMarcature(data);
  }
}
