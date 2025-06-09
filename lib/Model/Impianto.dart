import 'package:appattiva/Controller/Impianti.dart';

import 'Cantiere.dart';

class Impianto {
  Impianto.genera();

  Impianto(
      this.idImpianto,
      this.nomeTipologia,
      this.RagioneSociale,
      this.DataInserimento,
      this.Utente,
      this.Filiale,
      this.Citta,
      this.IdFiliale,
      this.IdCliente,
      this.Indirizzo);

  int? idImpianto, IdFiliale, IdCliente;
  String? nomeTipologia,
      RagioneSociale,
      DataInserimento,
      Utente,
      Filiale,
      Citta,
      Indirizzo;

  static Future<List<Impianto>> ricerca(
      String RagioneSociale, int IdImpianto) async {
    return await ImpiantoController.ricerca(RagioneSociale, IdImpianto);
  }

  static Future<Impianto?> ricercaPerIdImpianto(int idImpianto) async {
    return await ImpiantoController.ricercaPerIdImpianto(idImpianto);
  }

  String getIndirizzo() {
    return this.Indirizzo!;
  }

  String getCitta() {
    return this.Citta!;
  }

  String getFiliale() {
    return this.Filiale!;
  }

  int GetIdCliente() {
    return this.IdCliente!;
  }

  String getRagioneSociale() {
    return this.RagioneSociale!;
  }

  int getIdImpianto() {
    return this.idImpianto!;
  }

  int getIdFiliale() {
    return this.IdFiliale!;
  }

  Future<bool> delete() async {
    return await ImpiantoController.delete(this);
  }

  static Future<bool> uploadfile(
      Impianto imp, String base64file, String filename) async {
    return await ImpiantoController.uploadfile(imp, base64file, filename);
  }

  static Future<bool> nuovo() async {
    return await ImpiantoController.nuovo();
  }

  Future<String> avvioassistenza(String Stato, Cantiere c, String Note) async {
    return await ImpiantoController.avvioassistenza(this, Stato, c, Note);
  }

  static Future<String> getImpiantoOpen() async {
    return await ImpiantoController.getImpiantoOpen();
  }
}
