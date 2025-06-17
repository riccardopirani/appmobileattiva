import 'package:appattivaweb/Model/Rapporto.dart';
import 'package:appattivaweb/Model/Ristorante.dart';

import 'Api.dart';

class RistoranteControllerRapporto {
  RistoranteControllerRapporto(this.rp, this.rps);

  final Rapporto rp;
  final Ristorante rps;

  Future<bool> inserisci() async {
    Map<String, dynamic> map = {
      'IdRapporto': rp.getIdRapporto(),
      'Data': rps.getData(),
      'Costo': rps.getCosto(),
      'RagioneSociale': rps.getRagioneSociale(),
    };
    String value = await apiRequest(
        "/rapportini/ristorante/inserisci", map, UrlRequest.POST);
    return parseSingleJson(value);
  }
}
