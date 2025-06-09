import 'dart:async';

import 'package:appattiva/Controller/SpeseSostenute.dart';
import 'package:appattiva/Model/Rapporto.dart';

import 'Utente.dart';

class SpeseSostenute {
  SpeseSostenute(this.utemp, this.rptemp, this.causale, this.descrizione,
      this.data, this.costo, this.ricarico);

  SpeseSostenute.perRapportino(
      this.idSpeseSostenuteRapportoMobile,
      this.idRapportoMobile,
      this.extraPreventivo,
      this.utemp,
      this.rptemp,
      this.causale,
      this.descrizione,
      this.data,
      this.costo,
      this.ricarico);

  SpeseSostenute.perCantiere(this.idspese, this.extraPreventivo, this.utemp,
      this.causale, this.descrizione, this.data, this.costo, this.ricarico);

  bool? selected = false;
  Rapporto? rptemp;
  Utente? utemp;
  String? causale, descrizione, data;
  int? costo,
      ricarico,
      idspese,
      idSpeseSostenuteRapportoMobile,
      idRapportoMobile,
      extraPreventivo;

  int getidSpeseSostenuteRapportoMobile() {
    return this.idSpeseSostenuteRapportoMobile!;
  }

  int getIdSpese() {
    return this.idspese!;
  }

  String getCausale() {
    return this.causale!;
  }

  String getDescrizione() {
    return this.descrizione!;
  }

  String getData() {
    return this.data!;
  }

  int getCosto() {
    return this.costo!;
  }

  int getRicarico() {
    return this.ricarico!;
  }

  static Future<bool> inseriscidentroRapportino(
      SpeseSostenute sps, Rapporto rptemp) async {
    return await SpeseSostenuteController.inseriscidentroRapportino(
        rptemp, sps);
  }

  static Future<List<SpeseSostenute>> caricadarapporto(Rapporto c) async {
    return await SpeseSostenuteController.caricadarapporto(c);
  }

  static Future<bool> eliminadaRapporto(SpeseSostenute rp) async {
    return await SpeseSostenuteController.eliminadaRapporto(rp);
  }

  static Future<List<SpeseSostenute>> caricadacantiere() async {
    return await SpeseSostenuteController.caricadacantiere();
  }

  static Future<bool> inseriscidentroCantiere(
      SpeseSostenute sps, int extra) async {
    return await SpeseSostenuteController.inseriscidentroCantiere(sps, extra);
  }

  static Future<bool> eliminadaCantiere(SpeseSostenute sps) async {
    return await SpeseSostenuteController.eliminadaCantiere(sps);
  }
}
