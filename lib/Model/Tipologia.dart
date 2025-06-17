import 'dart:async';

import 'package:appattivaweb/Controller/RisorseUmane.dart';

class Tipologia {
  int _idTipologia;
  String nomeTipologia;

  Tipologia(this._idTipologia, this.nomeTipologia);

  factory Tipologia.fromJson(Map<String, dynamic> json) {
    return Tipologia(
      json['IdTipologia'] as int,
      json['NomeTipologia'] as String,
    );
  }

  static Future<List<Tipologia>> caricaTipoligie() async {
    return RisorseUmaneController.caricaTipologie();
  }

  String getNomeTipologia() {
    return nomeTipologia;
  }

  int getIdTipologia() {
    return _idTipologia;
  }
}
