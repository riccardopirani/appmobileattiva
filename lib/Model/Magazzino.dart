import 'dart:async';

import '../Controller/Magazzino.dart';
import 'ArticoloMagazzino.dart';

class Magazzino {
  int IdMagazzino;
  String Nome;
  String Indirizzo;
  String DataCreazione;

  Magazzino(this.IdMagazzino, this.Nome, this.Indirizzo, this.DataCreazione);

  // Metodo per caricare i dati e fare il cast corretto
  static Future<List<Magazzino>> caricamento() async {
    final rawList = await MagazzinoController.carica();
    return rawList;
  }

  static Future<List<ArticoloMagazzino>> recuperaArticoliMagazzino(
    int idMagazzino,
    int idArticoloMagazzino,
    String codArt,
    String barcode,
  ) async {
    return await MagazzinoController.recuperaArticoli(
        idMagazzino: idMagazzino,
        idArticoloMagazzino: idArticoloMagazzino,
        codArt: codArt,
        barcode: barcode);
  }

  // Getter per compatibilità
  int getIdMagazzino() => IdMagazzino;
  String getNomeMagazzino() => Nome;
  String getIndirizzo() => Indirizzo;
}
