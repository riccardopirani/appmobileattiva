class Contratto {
  final int contrattoID;
  final int idCliente;
  final DateTime dataInizio;
  final DateTime? dataFine;
  final double monteOre;
  final String? note;
  final int? attivo;

  Contratto(
      {required this.contrattoID,
      required this.idCliente,
      required this.dataInizio,
      this.dataFine,
      required this.monteOre,
      this.note,
      this.attivo});

  factory Contratto.fromJson(Map<String, dynamic> json) {
    return Contratto(
      contrattoID: json["ContrattoID"] as int,
      idCliente: json["IdCliente"] as int,
      dataInizio: DateTime.parse(json["DataInizio"]),
      dataFine:
          json["DataFine"] != null ? DateTime.tryParse(json["DataFine"]) : null,
      monteOre: (json["MonteOre"] as num).toDouble(),
      note: json["Note"],
      attivo: json["Attivo"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ContrattoID": contrattoID,
      "IdCliente": idCliente,
      "DataInizio": dataInizio.toIso8601String(),
      "DataFine": dataFine?.toIso8601String(),
      "MonteOre": monteOre,
      "Note": note,
      "Attivo": attivo
    };
  }
}
