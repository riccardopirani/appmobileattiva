import 'dart:async';

import 'package:appattiva/Controller/Noleggio.dart';
import 'package:appattiva/Model/Rapporto.dart';

import 'Cantiere.dart';
import 'Fornitore.dart';

class Noleggio {
  Noleggio(
      this.rptemp,
      this.f,
      this._extraPreventivo,
      this._tipomezzo,
      this._trasporto,
      this._matricola,
      this._costonoleggio,
      this.datafine,
      this.datainizio,
      this.ricarico);

  Noleggio.perRapportino(this.idNoleggiRapportoMobile, this.idRapportoMobile,
      this.datainizio, this.datafine, this._tipomezzo);

  Noleggio.perCantiere(
      this.idNoleggio, this.datainizio, this.datafine, this._tipomezzo);

  bool? selected = false;
  Fornitore? f;
  int? _extraPreventivo, idNoleggiRapportoMobile, idRapportoMobile, idNoleggio;

  int get extraPreventivo => _extraPreventivo!;

  set extraPreventivo(int value) {
    _extraPreventivo = value;
  }

  String? _tipomezzo,
      _trasporto,
      _matricola,
      _costonoleggio,
      datainizio,
      datafine,
      ricarico;

  Rapporto? rptemp;

  String getTipoMezzo() {
    return this._tipomezzo!;
  }

  String getTrasporto() {
    return this._trasporto!;
  }

  String getMatricola() {
    return this._matricola!;
  }

  String getCostoNoleggio() {
    return this._costonoleggio!;
  }

  String getDatainizio() {
    return this.datainizio!;
  }

  String getDataFine() {
    return this.datafine!;
  }

  String getRicarico() {
    return this.ricarico!;
  }

  int? getIdNoleggio() {
    return this.idNoleggio;
  }

  String get tipomezzo => _tipomezzo!;

  set tipomezzo(String value) {
    _tipomezzo = value;
  }

  get trasporto => _trasporto;

  set trasporto(value) {
    _trasporto = value;
  }

  get matricola => _matricola;

  set matricola(value) {
    _matricola = value;
  }

  get costonoleggio => _costonoleggio;

  set costonoleggio(value) {
    _costonoleggio = value;
  }

  static Future<bool> inserisci(Rapporto rp, Noleggio nppass, int extra) async {
    NoleggioController np = new NoleggioController(rp, nppass);
    return await np.inserisci(extra);
  }

  static Future<List<Noleggio>> carica(Rapporto rp) async {
    return await NoleggioController.carica(rp);
  }

  static Future<bool> eliminaNoleggioRapportino(Noleggio rp) async {
    return NoleggioController.eliminaNoleggioRapportino(rp);
  }

  Future<bool> inseriscidentroCantiere(
      Cantiere c, Noleggio nppass, int extra) async {
    NoleggioController np = new NoleggioController.perCantiere(nppass);
    return await np.inseriscidentroCantiere(c, extra);
  }

  static Future<bool> eliminaNoleggioCantiere(Noleggio rp) async {
    return await NoleggioController.eliminaNoleggioCantiere(rp);
  }

  static Future<List<Noleggio>> caricaperCantiere(Cantiere rp) async {
    return await NoleggioController.caricaperCantiere(rp);
  }
}
