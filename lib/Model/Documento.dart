import 'dart:async';

import 'package:appattiva/Controller/Documento.dart';
import 'package:appattiva/Model/Impianto.dart';

class Documento {
  Documento(this.IdDoc, this.Utente, this.imp, this.Testo);

  int IdDoc;
  String Utente, Testo;
  Impianto imp;

  static Future<List<Documento>> load(Impianto imp) async {
    return await DocumentoController.load(imp);
  }

  Future<bool> delete() async {
    return await DocumentoController.delete(this);
  }

  Future<String?> getfile() async {
    return await DocumentoController.getfile(this);
  }
}
