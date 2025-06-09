import '../Controller/Permesso.dart';

class Permesso {
  static Future<bool> insert({
    required String data,
    required String oreInizio,
    required String oreFine,
    required String motivazione,
    required String stato,
  }) async {
    return await PermessoController.insert(
      data: data,
      oreInizio: oreInizio,
      oreFine: oreFine,
      motivazione: motivazione,
      stato: stato,
    );
  }
}
