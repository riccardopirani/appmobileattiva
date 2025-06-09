import 'dart:async';

import 'package:appattiva/Controller/Marcatura.dart' show MarcaturaController;
import 'package:appattiva/Model/Utente.dart' show Utente;

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
    return this.totOreGiornaliereMarcatempo;
  }

  String gettotOreMensiliMarcatempo() {
    return this.totOreMensiliMarcatempo;
  }

  String gettotOreCantieriMensili() {
    return this.totOreCantieri;
  }

  String gettotOreGiornaliere() {
    return this.totOreGiornaliereCantieri;
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
    this.utente = u;
    this.longitudine = longitudine;
    this.latitudine = latitudine;
    this.data = data;
    this.type = type;
  }

  Marcatura.perstoricomarcature(Utente u, String longitudine, String latitudine,
      String stato, String totaleORE, String s) {
    this.utente = u;
    this.latString = latitudine;
    this.lonString = longitudine;
    this.stato = stato;
    this.totaleOre = totaleORE;
  }

  Future<bool> insertmarcatura(MarcaturaType mc, String DataCreazione) async {
    var marcatura = new MarcaturaController(utente!, longitudine!, latitudine!);
    return await marcatura.insertmarcatura(mc, DataCreazione);
  }

  String getStato() {
    return this.stato!;
  }

  MarcaturaType getType() {
    return this.type!;
  }

  String getTotaleOre() {
    return this.totaleOre!;
  }

  static Future<List<Marcatura>> getListaMarcature(
      Utente u, String data) async {
    var marcatura = new MarcaturaController(u, 0, 0);
    return await marcatura.getListaMarcature(data);
  }
}
