import 'dart:async';

import 'package:appattiva/Controller/Ristorante.dart';
import 'package:appattiva/Controller/RistoranteRapporto.dart';
import 'package:appattiva/Model/Rapporto.dart';

import 'Cantiere.dart';
import 'Utente.dart';

class Ristorante {
  Ristorante(this._c, this._idRistorante, this._costo, this._extraPreventivo,
      this._ragioneSociale, this._u, this._data, this._inseritoDa);

  Ristorante.perInserimento(
    this._c,
    this._idRistorante,
    this._costo,
    this._data,
    this._extraPreventivo,
    this._ragioneSociale,
    this._u,
  );

  Ristorante.perRapportino(this._c, this._ragioneSociale, this._costo,
      this._data, this._idRistorante);

  Ristorante.setCantiere(this._c);

  Ristorante.perRapportini(this.rptemp);

  bool? selected = false;

  Cantiere? _c;

  Cantiere get c => _c!;

  set c(Cantiere value) {
    _c = value;
  }

  int? _costo, _extraPreventivo, _idRistorante;
  String? _descrizioneEstesa, _data, _ragioneSociale, _inseritoDa;
  Rapporto? rptemp;
  Utente? _u;

  Future<bool> inserimento(Cantiere c) async {
    return await RistoranteController.inserisci(
        c, _u!, _ragioneSociale!, _costo!, _data!, _extraPreventivo!);
  }

  static Future<List<Ristorante>> ricerca(Cantiere c) async =>
      RistoranteController.carica(c);

  String getRagioneSociale() {
    return _ragioneSociale!;
  }

  String getDescrizione() {
    return _descrizioneEstesa!;
  }

  String getData() {
    return _data!;
  }

  String getCosto() {
    return _costo.toString();
  }

  int getIdRistorante() {
    return _idRistorante!;
  }

  static Future<List<Ristorante>> caricadarapporto(Rapporto c) async {
    return RistoranteController.caricadarapporto(c);
  }

  static Future<bool> eliminaRistoranteRapportino(Ristorante rp) async {
    return RistoranteController.eliminaRistoranteRapportino(rp);
  }

  Future<bool> inserisci(Ristorante rps) async {
    var rp = new RistoranteControllerRapporto(rptemp!, rps);
    return await rp.inserisci();
  }

  static Future<bool> eliminaRistorantedaCantiere(Ristorante rp) async {
    return RistoranteController.eliminaRistorantedaCantiere(rp);
  }

  static Future<List<Ristorante>> caricaRistorantiCantiere(
      Cantiere ctemp) async {
    return await RistoranteController.caricaRistorantiCantiere(ctemp);
  }

  int get costo => _costo!;

  set costo(int value) {
    _costo = value;
  }

  get extraPreventivo => _extraPreventivo;

  set extraPreventivo(value) {
    _extraPreventivo = value;
  }

  get idRistorante => _idRistorante;

  set idRistorante(value) {
    _idRistorante = value;
  }

  String get descrizioneEstesa => _descrizioneEstesa!;

  set descrizioneEstesa(String value) {
    _descrizioneEstesa = value;
  }

  get data => _data;

  set data(value) {
    _data = value;
  }

  get ragioneSociale => _ragioneSociale;

  set ragioneSociale(value) {
    _ragioneSociale = value;
  }

  get inseritoDa => _inseritoDa;

  set inseritoDa(value) {
    _inseritoDa = value;
  }

  Utente get u => _u!;

  set u(Utente value) {
    _u = value;
  }
}
