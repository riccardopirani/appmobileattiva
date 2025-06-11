class Preventivo {
  Preventivo(this.IdPreventivo, this.IdCliente, this.RagioneSociale,
      this.RiferimentoInterno);

  int IdPreventivo, IdCliente;
  String RagioneSociale, RiferimentoInterno;

  bool selected = false;

  int getIdPreventivo() {
    return IdPreventivo;
  }

  int getIdCliente() {
    return IdCliente;
  }

  String getRagioneSociale() {
    return RagioneSociale;
  }

  String getRiferimentoInterno() {
    return RiferimentoInterno;
  }
}
