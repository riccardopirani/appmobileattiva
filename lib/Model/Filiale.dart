class Filiale {
  Filiale(this._idFiliale, this._nomeFiliale);

  int _idFiliale;
  String _nomeFiliale;

  String getIdFiliale() {
    return this._idFiliale.toString();
  }

  String getNomeFiliale() {
    return this._nomeFiliale;
  }
}
