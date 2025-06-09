class ArticoloMagazzino {
  final int idArticoloMagazzino;
  final String codArt;
  final String descrizione;
  final String quantita;
  final String magazzino;
  final String fornitore;
  final String dataInserimento;
  final int idMagazzino;
  final String utente;

  ArticoloMagazzino({
    required this.idArticoloMagazzino,
    required this.codArt,
    required this.descrizione,
    required this.quantita,
    required this.magazzino,
    required this.fornitore,
    required this.dataInserimento,
    required this.idMagazzino,
    required this.utente,
  });

  factory ArticoloMagazzino.fromJson(Map<String, dynamic> json) {
    return ArticoloMagazzino(
      idArticoloMagazzino: json['IdArticoloMagazzino'],
      codArt: json['CodArt'],
      descrizione: json['Descrizione'],
      quantita: json['Quantita'].toString(),
      magazzino: json['Magazzino'],
      fornitore: json['Fornitore'],
      dataInserimento: json['DataInserimento'],
      idMagazzino: json['IdMagazzino'],
      utente: json['Utente'],
    );
  }
}
