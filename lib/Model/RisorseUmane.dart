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
    return _idUtente!;
  }

  int getidRisorseUmaneRapportoMobile() {
    return _idRisorseUmaneRapportoMobile!;
  }

  int getidRisorsaUmanaCantiere() {
    return _idRisorsaUmanaCantiere!;
  }

  String getNome() {
    return nome!;
  }

  String getCognome() {
    return cognome!;
  }

  String getData() {
    return data!;
  }

  String getTotaleOre() {
    return totaleore!;
  }

  String getDescrizione() {
    return descrizione!;
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
      int extra,
      String ddt) async {
    return await RisorseUmaneController.inserimentoCantiere(
        idCantiere,
        idtipologia,
        idRisorsaUmana,
        data,
        oreInizio,
        oreFine,
        pausa,
        descrizione,
        extra,
        ddt);
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

  static Future<List<RisorseUmane>> caricarisorseumanecantiere(int c) async {
    return await RisorseUmaneController.caricarisorseumanecantiere(c);
  }

  static Future<bool> eliminaRisorsaUmanaRapportino(RisorseUmane rp) async {
    return await RisorseUmaneController.eliminaRisorsaUmanaRapportino(rp);
  }

  static Future<bool> eliminaRisorsaUmanaCantiere(RisorseUmane rp) async {
    return await RisorseUmaneController.eliminaRisorsaUmanaCantiere(rp);
  }
}
