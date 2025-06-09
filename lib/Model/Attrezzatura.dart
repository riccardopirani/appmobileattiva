import 'dart:async';

import 'package:appattiva/Controller/Attrezzatura.dart';

class Attrezzatura {
  final int idAttrezzature;
  final int idUtente;
  final String nomeOggetto;
  final String immagine;
  final String dataCreazione;
  final String stato;
  final String descrizione;
  final String User;

  Attrezzatura(
      this.idAttrezzature,
      this.idUtente,
      this.nomeOggetto,
      this.immagine,
      this.dataCreazione,
      this.stato,
      this.descrizione,
      this.User);

  static Future<List<Attrezzatura>> load() async {
    return AttrezzaturaController.load();
  }

  static Future<bool> add(
      String descrizione, String nomeOggetto, String immagine) async {
    return AttrezzaturaController.add(descrizione, nomeOggetto, immagine);
  }

  static Future<List<Attrezzatura>> loadStorico() async {
    return AttrezzaturaController.loadStorico();
  }

  static Future<Attrezzatura> loadById(String idAttrezzatura) async {
    return AttrezzaturaController.loadById(idAttrezzatura);
  }

  static Future<bool> addUtilizzo(
      int idAttrezzature, int stato, String note) async {
    return AttrezzaturaController.addUtilizzo(idAttrezzature, stato, note);
  }
}
