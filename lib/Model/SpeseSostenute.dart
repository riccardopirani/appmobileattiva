import 'dart:async';

import 'package:appattivaweb/Controller/SpeseSostenute.dart';
import 'package:appattivaweb/Model/Rapporto.dart';

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
    return idSpeseSostenuteRapportoMobile!;
  }

  int getIdSpese() {
    return idspese!;
  }

  String getCausale() {
    return causale!;
  }

  String getDescrizione() {
    return descrizione!;
  }

  String getData() {
    return data!;
  }

  int getCosto() {
    return costo!;
  }

  int getRicarico() {
    return ricarico!;
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
