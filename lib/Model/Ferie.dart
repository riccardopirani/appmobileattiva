import 'package:appattiva/Controller/Ferie.dart';

enum FerieEnum { Ferie, Permesso }

class Ferie {
  final int IdFerie, IdUtente;
  final String DataInizio, DataFine, Motivazione, Stato;

  Ferie(this.IdFerie, this.IdUtente, this.DataInizio, this.DataFine,
      this.Motivazione, this.Stato);

  static Future<bool> inserimento(String DataInizio, String DataFine,
      String Motivazione, String Stato) async {
    return await FerieController.inserimento(
        DataInizio, DataFine, Motivazione, Stato);
  }

  static Future<List<Ferie>> ricerca() async {
    return await FerieController.ricerca();
  }
}
