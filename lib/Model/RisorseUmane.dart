import 'dart:async';

import 'package:appattiva/Controller/RisorseUmane.dart';
import 'package:appattiva/Model/Rapporto.dart';

class RisorseUmane {
  RisorseUmane.perRapportino(
      this._idUtente, this.username, this.nome, this.cognome, this.azienda);

  RisorseUmane.setidUtenteMain(this._idUtente);

  RisorseUmane.perRapportinoStampa(this._idUtente, this.nome, this.totaleore,
      this.descrizione, this.data, this._idRisorseUmaneRapportoMobile);

  RisorseUmane.perCantieri(
      this._idUtente,
      this.username,
      this.totaleore,
      this.descrizione,
      this.data,
      this._idRisorsaUmanaCantiere,
      this.nome,
      this.cognome);

  String? azienda, username, nome, cognome, totaleore, descrizione, data;

  int? _idUtente, _idRisorseUmaneRapportoMobile, _idRisorsaUmanaCantiere;

  bool? selected = false;

  static Future<List<RisorseUmane>> carica() async =>
      RisorseUmaneController.carica();

  int getIdUtente() {
    return this._idUtente!;
  }

  int getidRisorseUmaneRapportoMobile() {
    return this._idRisorseUmaneRapportoMobile!;
  }

  int getidRisorsaUmanaCantiere() {
    return this._idRisorsaUmanaCantiere!;
  }

  String getNome() {
    return this.nome!;
  }

  String getCognome() {
    return this.cognome!;
  }

  String getData() {
    return this.data!;
  }

  String getTotaleOre() {
    return this.totaleore!;
  }

  String getDescrizione() {
    return this.descrizione!;
  }

  static Future<bool> inserimentoCantiere(
      int idCantiere,
      String idtipologia,
      String idRisorsaUmana,
      String data,
      String oreInizio,
      String oreFine,
      String pausa,
      String descrizione,
      int extra) async {
    return await RisorseUmaneController.inserimentoCantiere(idCantiere, idtipologia,
        idRisorsaUmana, data, oreInizio, oreFine, pausa, descrizione, extra);
  }

  static Future<bool> inserisci(
      int idrapporto,
      String idtipologia,
      String idRisorsaUmana,
      String data,
      String oreInizio,
      String oreFine,
      String pausa,
      String descrizione) async {
    return await RisorseUmaneController.inserisci(idrapporto, idtipologia,
        idRisorsaUmana, data, oreInizio, oreFine, pausa, descrizione);
  }

  static Future<List<RisorseUmane>> caricadarapporto(Rapporto c) async {
    return await RisorseUmaneController.caricadarapporto(c);
  }

  static Future<List<RisorseUmane>> caricarisorseumanecantiere(
      int c) async {
    return await RisorseUmaneController.caricarisorseumanecantiere(c);
  }

  static Future<bool> eliminaRisorsaUmanaRapportino(RisorseUmane rp) async {
    return await RisorseUmaneController.eliminaRisorsaUmanaRapportino(rp);
  }

  static Future<bool> eliminaRisorsaUmanaCantiere(RisorseUmane rp) async {
    return await RisorseUmaneController.eliminaRisorsaUmanaCantiere(rp);
  }
}
