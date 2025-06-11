import 'dart:convert';

import 'package:appattiva/Model/Kilometro.dart';
import 'package:appattiva/Model/Rapporto.dart';
import 'package:appattiva/utils/support.dart';

import 'Api.dart';

class KilometroController {
  Rapporto? rp;
  Kilometro kp;

  KilometroController(this.rp, this.kp);

  KilometroController.perCantieri(this.kp) {
    rp = null;
  }

  Future<bool> inserisciinCantiere(int extra) async {
    Map<String, dynamic> map = {
      'IdCantiere': await Storage.leggi("IdCantiere"),
      'IdUtente': await Storage.leggi("IdUtente"),
      'IdKilometro': "0",
      'Data': kp.getData(),
      'Targa': kp.getTarga(),
      'TipoMezzo': kp.getTipomezzo(),
      'CostoKilometrico': kp.getCosto(),
      'Kilometri': kp.getKilometri(),
      'DirittoChiamata': kp.getDirittochiamata(),
      'ExtraPreventivo': extra.toString(),
    };
    String value =
        await apiRequest("/kilometro/inseriscikilometro", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  Future<bool> inserisci() async {
    if (rp == null) return false;
    Map<String, dynamic> map = {
      'IdRapportoMobile': rp!.getIdRapporto(),
      'Data': kp.getData(),
      'Targa': kp.getTarga(),
      'TipoMezzo': kp.getTipomezzo(),
      'Costo': kp.getCosto(),
      'Kilometri': kp.getKilometri(),
      'DirittoChiamata': kp.getDirittochiamata(),
      'Extra': kp.extraPreventivo,
    };
    String value = await apiRequest(
        "/rapportini/kilometri/inserisci", map, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<String> getCostoKilometrico(int idCliente) async {
    String value = await apiRequest("/cliente/getcostokilometrico",
        {'IdCliente': idCliente.toString()}, UrlRequest.POST);
    Map<String, dynamic> valueMap = json.decode(value);
    return valueMap['return'].toString();
  }

  static Future<List<Kilometro>> carica(Rapporto rapporto) async {
    String value = await apiRequest("/rapportini/kilometri/caricamento",
        {'IdRapporto': rapporto.getIdRapporto().toString()}, UrlRequest.POST);
    return (json.decode(value) as List<dynamic>)
        .map((dynamic jsonObject) => Kilometro.perRapportino(
            idKilometroRapportoMobile:
                jsonObject["IdKilometriRapportoMobile"] as int,
            idRapportoMobile: jsonObject["IdRapportoMobile"] as int,
            extraPreventivo: 0,
            dirittochiamata: jsonObject["DirittoChiamata"] as String,
            kilometri: jsonObject["Kilometri"] as String,
            costo: jsonObject["CostoKilometrico"] as String,
            tipomezzo: jsonObject["TipoMezzo"] as String,
            targa: jsonObject["Targa"] as String,
            data: jsonObject["Data"] as String,
            rapporto: Rapporto.empty()))
        .toList();
  }

  static Future<bool> eliminaKilometroRapportino(Kilometro kilometro) async {
    String value = await apiRequest(
        "/rapportini/kilometri/elimina",
        {
          'IdKilometriRapportoMobile':
              kilometro.getIdKilometroRapportoMobile().toString()
        },
        UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<bool> eliminaKilometroCantiere(Kilometro kilometro) async {
    String value = await apiRequest("/kilometro/eliminakilometrocantiere",
        {'IdDelete': kilometro.getIdKilometro().toString()}, UrlRequest.POST);
    return parseSingleJson(value);
  }

  static Future<List<Kilometro>> caricaperCantiere() async {
    String value = await apiRequest("/kilometro/caricakilometricantiere",
        {'IdCantiere': await Storage.leggi("IdCantiere")}, UrlRequest.POST);
    return (json.decode(value) as List<dynamic>)
        .map((dynamic jsonObject) => Kilometro.perCantieri(
              idKilometro: jsonObject["IdKilometri"] as int,
              extraPreventivo: jsonObject["ExtraPreventivo"] as int,
              dirittochiamata: jsonObject["DirittoChiamata"] as String,
              kilometri: jsonObject["Kilometri"] as String,
              costo: jsonObject["CostoKilometrico"] as String,
              tipomezzo: jsonObject["TipoMezzo"] as String,
              targa: jsonObject["Targa"] as String,
              data: jsonObject["Data"] as String,
              rapporto: Rapporto.empty(),
              idRapportoMobile: jsonObject["IdKilometri"] as int,
            ))
        .toList();
  }
}
