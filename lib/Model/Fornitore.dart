import 'dart:async';

import 'package:appattivaweb/Controller/Fornitore.dart';

class Fornitore {
  int _idFornitore;
  String _nomeFornitore;

  Fornitore(this._idFornitore, this._nomeFornitore);

  static Future<List<Fornitore>> caricamento() async {
    return await FornitoreController.carica();
  }

  String getNomeFornitore() {
    return _nomeFornitore;
  }

  int getidFornitore() {
    return _idFornitore;
  }
}
