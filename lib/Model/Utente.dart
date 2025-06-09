import 'dart:typed_data';

import 'package:appattiva/Controller/Utente.dart';
import 'package:appattiva/Utils/support.dart';

class Utente {
  int? idutente, AccessoCantieri = 0, AccessoImpianti = 0;

  String? nome,
      cognome,
      email,
      password,
      telefono,
      firma,
      username,
      profiloImage;

  Utente.init(int idutente, String email, String password) {
    this.idutente = idutente;
    this.email = email;
    this.password = password;
  }

  Utente.setIdUtente(int idUtente) {
    this.idutente = idUtente;
  }

  Utente.completo(
      this.idutente,
      this.nome,
      this.cognome,
      this.telefono,
      this.email,
      this.profiloImage,
      this.AccessoCantieri,
      this.AccessoImpianti);

  Future<bool> login(String username, String password) async {
    this.username = username;
    this.password = password;
    var user = UtenteController();
    idutente = await user.login(username, password);
    print(idutente);
    List<Utente> luser = await UtenteController.caricaValori(idutente!);
    if (idutente! > 0) {

      Storage.salva("IdUtente", idutente.toString());
      Storage.salva("Username", username);
      Storage.salva("Password", password);
      Storage.salva("RisorsaSelezionata", idutente.toString());

      for (var i in luser) {
        Storage.salva("AccessoImpianti", i.AccessoImpianti.toString());
        Storage.salva("AccessoCantieri", i.AccessoCantieri.toString());
        Storage.salva("Nome", i.GetNome());
        Storage.salva("Cognome", i.GetCognome());
        Storage.salva("Email", i.GetEmail());
        Storage.salva("Telefono", i.GetTelefono());
        Storage.salva("ImmagineProfilo", i.getImageProfilo());
        Storage.salva(
            "NomeRisorsaSelezionata", i.GetNome() + " " + i.GetCognome());
      }
      return true;
    }
    return false;
  }

  static Future<int> registrazione(String email, String username, String pwd,
      String name, String surname) async {
    return new UtenteController()
        .registrazione(email, username, pwd, name, surname);
  }

  int GetIdUtente() {
    return this.idutente!;
  }

  static Future<Uint8List> getFirma(int idutente) async {
    return UtenteController.getFirma(idutente);
  }

  String GetNome() {
    return this.nome!;
  }

  String GetCognome() {
    return this.cognome!;
  }

  String getImageProfilo() {
    return this.profiloImage!;
  }

  String GetTelefono() {
    return this.telefono!;
  }

  String GetEmail() {
    return this.email!;
  }

  String GetPassword() {
    return this.password!;
  }

  Future<bool> logout() async {
    Storage.rimuovi("IdUtente");
    Storage.rimuovi("Email");
    Storage.rimuovi("Password");
    return true;
  }

  static Future<List<Utente>> getValori(int Idutente) async {
    return await UtenteController.caricaValori(Idutente);
  }

  static Future<Utente> getUser() async {
    var email = await Storage.leggi("Email");
    var password = await Storage.leggi("Password");
    var idutente = int.parse(await Storage.leggi("IdUtente"));
    return new Utente.init(idutente, email, password);
  }

  static Future<bool> aggiornaimmagineprofilo(String base64) async {
    return await UtenteController.aggiornaimmagineprofilo(base64);
  }

  static Future<bool> inviosegnalazione(double lat, double lon) async {
    return await UtenteController.inviosegnalazione(lat, lon);
  }

  static Future<String> getProfiloImmagine() async {
    return await UtenteController.getImageProfilo();
  }
}
