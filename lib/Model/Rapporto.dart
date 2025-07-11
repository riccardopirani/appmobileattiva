import 'dart:async';
import 'dart:typed_data';

import 'package:appattivaweb/Controller/Rapporto.dart';
import 'package:appattivaweb/Model/Cantiere.dart';
import 'package:appattivaweb/Model/Utente.dart' show Utente;
import 'package:appattivaweb/utils/support.dart';
import 'package:flutter/material.dart';

class Rapporto {
  Rapporto.empty();

  Rapporto(Utente u, Cantiere c) {
    utente = u;
    this.c = c;
  }

  Rapporto.daCantiere(
      int idRapporto,
      int idRapportoMobile,
      Utente utente,
      String dataInserimento,
      Cantiere ctemp,
      String noteTecnico,
      String noteCliente,
      String Citta) {
    idRapportino = idRapporto;
    this.idRapportoMobile = idRapportoMobile;
    this.utente = utente;
    data = dataInserimento;
    c = ctemp;
    this.noteCliente = noteCliente;
    this.noteTecnico = noteTecnico;
    citta = Citta;
  }

  Cantiere? c;
  String? data, noteTecnico, noteCliente, citta;
  int? idRapportino = 0, idRapportoMobile = 0;
  Utente? utente;
  static Uint8List? logo, firmatecnico;

  String getNoteTecnico() => noteTecnico!;

  String getNoteCliente() => noteCliente!;

  int getIdRapporto() => idRapportoMobile!;

  int getIdRapportoUtente() => idRapportino!;

  Utente getUtente() => utente!;

  Cantiere getCantiere() => c!;

  String getData() => data!;

  static Future<List<Rapporto>> genera(
      Utente utente, Cantiere c, String data) async {
    List<Rapporto> rp = await RapportoController.genera(utente, c, data);
    return rp;
  }

  static Future<List<Rapporto>> ricerca(
          Utente utemp, String nomeCantiere) async =>
      RapportoController.ricerca(utemp, nomeCantiere);

  static Future<Uint8List> getTestata(BuildContext context) async {
    if (logo == null) {
      String server = await Storage.leggi("Server");
      String porta2 = await Storage.leggi("Porta2");
      String testata = '$server:$porta2/logo.png';
      logo = await fetchImageAsBytes(testata);
    }
    return logo!;
  }

  static Future<bool> elimina(Rapporto rp) async {
    return await RapportoController.elimina(rp);
  }

  static Future<Uint8List> getFirma(BuildContext context) async {
    if (firmatecnico == null) {
      if (await RapportoController.generafirma()) {
        String server = await Storage.leggi("Server");
        String porta2 = await Storage.leggi("Porta2");
        String firmaUrl = '$server:$porta2/firmatecnico.png';
        firmatecnico = await fetchImageAsBytes(firmaUrl);
      }
    }
    return firmatecnico!;
  }

  static Future<bool> invioFile(
      String base64pdf, int IdRapporto, int IdCantiere) async {
    return await RapportoController.invioFile(
        base64pdf, IdRapporto, IdCantiere);
  }

  static Future<String> costoTotaleFatturazione(int idRapporto) async {
    return await RapportoController.costoTotaleFatturazione(idRapporto);
  }

  static Future<bool> salvaNoteTecnicoCliente(
      Rapporto rp, String noteTecnico, String noteCliente) async {
    return await RapportoController.salvaNoteTecnicoCliente(
        rp, noteTecnico, noteCliente);
  }

  static Future<List<Rapporto>> recuperoNoteTecnicoCliente(Rapporto rp) async {
    return await RapportoController.recuperoNoteTecnicoCliente(rp);
  }

  static Future<bool> inserisciDocumento(
      Rapporto rapporto, String filePDf) async {
    return await RapportoController.inserisciDocumento(rapporto, filePDf);
  }
}
