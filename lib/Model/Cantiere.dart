import 'dart:async';

import 'package:appattivaweb/Controller/Cantiere.dart';
import 'package:appattivaweb/Model/Cliente.dart';
import 'package:appattivaweb/Model/Filiale.dart';
import 'package:appattivaweb/Model/Preventivo.dart';

import 'Utente.dart';

class Cantiere {
  Cantiere(
      this._c,
      this._IdCantiere,
      this._nomeCantiere,
      this._DescrizioneEstesa,
      this._Tipologia,
      this._stato,
      this._statoFatturazione,
      this._DataCreazione,
      this._commessa,
      this.IdFilialeCliente,
      this._indirizzo,
      this.commessacliente);

  Cantiere.setIdCantiere(this._IdCantiere);

  Cantiere.setbase(this._IdCantiere, this._nomeCantiere, this._c,
      this._commessa, this.commessacliente);

  Cantiere.setVuoto();

  Cantiere.setCantiere(this._IdCantiere, this.TotaleCosto,
      this.TotaleFatturazione, this.TotaleExtra);

  Cliente? _c;

  String? _commessa,
      _nomeCantiere,
      _Tipologia,
      _stato,
      _DescrizioneEstesa,
      _DataCreazione,
      TotaleCosto,
      TotaleFatturazione,
      TotaleExtra,
      _indirizzo,
      commessacliente;

  int? _IdCantiere, _statoFatturazione, IdFilialeCliente;

  Cliente get c => _c!;

  set c(Cliente value) {
    _c = value;
  }

  String? getExtra() {
    return TotaleExtra;
  }

  String? getIndirizzo() {
    return _indirizzo;
  }

  String? getCommessaCliente() {
    return commessacliente;
  }

  String? getCosto() {
    return TotaleCosto;
  }

  String? getStato() {
    return _stato;
  }

  int? GetIdFilialeCliente() {
    return IdFilialeCliente;
  }

  String? getTotaleFatturazione() {
    return TotaleFatturazione;
  }

  String? getNomeCantiere() {
    return _nomeCantiere;
  }

  String getFiliale() {
    return _c!.getFiliale();
  }

  String getRagioneSociale() {
    return _c!.getRagioneSociale();
  }

  String? getDataCreazione() {
    return _DataCreazione;
  }

  int? getIdCantiere() {
    return _IdCantiere;
  }

  String? getCommessa() {
    return _commessa;
  }

  String? getDescrizione() {
    return _DescrizioneEstesa;
  }

  String getLinkStatoImmagine() {
    String ret = "assets/images/contoinviato.png";
    if (_stato == "Chiuso") {
      ret = "assets/images/Accettato.png";
    } else if (_stato == "InCorso") {
      ret = "assets/images/InCorso.png";
    } else if (_stato == "Lavoro terminato inserire bolle ") {
      ret = "assets/images/Rifiutato.png";
    }
    return ret;
  }

  Cliente? getCliente() {
    return _c;
  }

  String? getTipologia() {
    return _Tipologia;
  }

  String get commessa => _commessa!;

  set commessa(String value) {
    _commessa = value;
  }

  get nomeCantiere => _nomeCantiere;

  set nomeCantiere(value) {
    _nomeCantiere = value;
  }

  get Tipologia => _Tipologia;

  set Tipologia(value) {
    _Tipologia = value;
  }

  get stato => _stato;

  set stato(value) {
    _stato = value;
  }

  get DescrizioneEstesa => _DescrizioneEstesa;

  set DescrizioneEstesa(value) {
    _DescrizioneEstesa = value;
  }

  get DataCreazione => _DataCreazione;

  set DataCreazione(value) {
    _DataCreazione = value;
  }

  get indirizzo => _indirizzo;

  set indirizzo(value) {
    _indirizzo = value;
  }

  int get IdCantiere => _IdCantiere!;

  set IdCantiere(int value) {
    _IdCantiere = value;
  }

  get statoFatturazione => _statoFatturazione;

  set statoFatturazione(value) {
    _statoFatturazione = value;
  }

  static Future<Cantiere> calcoloTotale(Cantiere c) async {
    return await CantiereController.calcoloTotale(c);
  }

  static Future<Filiale> recuperaFiliale(Cliente c) async {
    return await CantiereController.recuperaFiliale(c);
  }

  static Future<List<Preventivo>> getListaPreventivi() async {
    return await CantiereController.getListaPreventivi();
  }

  static Future<Cantiere> generaCantierePreventivo(Preventivo p) async {
    return await CantiereController.generaCantierePreventivo(p);
  }

  static Future<Cantiere> generaCantiereConsuntivo(String nomecantiere) async {
    return await CantiereController.generaCantiereConsuntivo(nomecantiere);
  }

  static Future<List<Cantiere>> ricerca(
          Utente u,
          int IdCantiere,
          String NomeCantiere,
          String RagioneSociale,
          bool isUtente,
          int IdFiliale) async =>
      CantiereController.Ricerca(
          u, IdCantiere, NomeCantiere, RagioneSociale, isUtente, IdFiliale);

  static Future<List<Cantiere>> ricercaCantieriperRapportino() async =>
      CantiereController.ricercaCantieriperRapportino();

  static Future<Object> aggiornaCantiere(Cantiere c) async {
    return CantiereController.aggiornaCantiere(c);
  }
}
