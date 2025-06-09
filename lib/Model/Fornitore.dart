import 'dart:async';

import 'package:appattiva/Controller/Fornitore.dart';

class Fornitore {
  int _idFornitore;
  String _nomeFornitore;

  Fornitore(this._idFornitore, this._nomeFornitore);

  static Future<List<Fornitore>> caricamento() async {
    return await FornitoreController.carica();
  }

  String getNomeFornitore() {
    return this._nomeFornitore;
  }

  int getidFornitore() {
    return this._idFornitore;
  }
}
