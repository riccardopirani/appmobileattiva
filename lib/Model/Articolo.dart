import 'dart:async';

import 'package:appattivaweb/Controller/Articolo.dart';
import 'package:appattivaweb/Model/Cantiere.dart';
import 'package:appattivaweb/Model/Rapporto.dart';

class Articolo {
  Articolo(
      this._idArticolo,
      this._codArt,
      this._descrizione,
      this._prezzo,
      this.codiceBarcode,
      this._codMarca,
      this._codicevaluta,
      this._fornitore,
      this._importato,
      this._quantita);

  Articolo.perCantiere(
      this._idArticoloCantiere,
      this._codArt,
      this._descrizione,
      this._prezzo,
      this.codiceBarcode,
      this._codMarca,
      this._codicevaluta,
      this._fornitore,
      this._importato,
      this._quantita);

  Articolo.base(this._idArticolo);

  Articolo.perRapporto(
      this._codArt,
      this._descrizione,
      this._quantita,
      this._idArticoloRapportoMobile,
      this._fornitore,
      this._data,
      this._prezzo);

  int? _idArticolo, _idArticoloRapportoMobile;
  String? _codArt,
      _descrizione,
      _quantita,
      codiceBarcode,
      _codMarca,
      _prezzo,
      _codicevaluta,
      _fornitore,
      _importato,
      _idArticoloCantiere,
      _data;

  bool? selected = false;

  String? getIdArticoloCantiere() => _idArticoloCantiere;

  bool isCodEanSet() => codiceBarcode != null;

  String? getData() => _data;

  int? getIdArticolo() => _idArticolo;

  int? getIdArticoloRapportoMobile() => _idArticoloRapportoMobile;

  String? getCodArt() => _codArt;

  String? getDescrizione() => _descrizione;

  String? getFornitore() => _fornitore;

  String? getImportato() => _importato;

  String? getCodMarca() => _codMarca;

  String? getCodiceValuta() => _codicevaluta;

  String? getPrezzo() => _prezzo;

  String? getQuantita() => _quantita;

  Future<bool> inserimento(String quantita, int idRapporto, String idtipologia,
      String data, int extra) async {
    return await ArticoloController.inserisci(
        quantita, idRapporto, idtipologia, _idArticolo!, data, extra);
  }

  static Future<List<Articolo>> caricaArticoliRapporto(Rapporto rp) async {
    return await ArticoloController.caricaArticoliRapporto(rp.getIdRapporto());
  }

  static Future<bool> eliminaArticolodaRapportino(Articolo rp) async {
    return await ArticoloController.eliminaArticolodaRapportino(rp);
  }

  static Future<bool> inserisciinCantiere(Cantiere ctemp, String quantita,
      String idtipologia, Articolo atemp, String data, int extraprev) async {
    return await ArticoloController.inserisciinCantiere(
        ctemp, quantita, idtipologia, atemp, data, extraprev);
  }

  static Future<List<Articolo>> ricerca(String codArt, String codiceBarcode,
      String descrizione, int idarticolo) async {
    return await ArticoloController.ricerca(
        codArt, codiceBarcode, descrizione, idarticolo);
  }

  static Future<List<Articolo>> ricercaArticoliCantiere(Cantiere c) async {
    return await ArticoloController.ricercaArticoliCantiere(c);
  }

  static Future<bool> eliminaArticolodaCantiere(Articolo rp) async {
    return await ArticoloController.eliminaArticolodaCantiere(rp);
  }

  static Future<bool> aggiornamentobarcode(
      Articolo atemp, String Barcode) async {
    return await ArticoloController.aggiornamentobarcode(atemp, Barcode);
  }
}
