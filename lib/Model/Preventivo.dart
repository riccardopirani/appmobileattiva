class Preventivo {
  Preventivo(this.IdPreventivo, this.IdCliente, this.RagioneSociale,
      this.RiferimentoInterno);

  int IdPreventivo, IdCliente;
  String RagioneSociale, RiferimentoInterno;

  bool selected = false;

  int getIdPreventivo() {
    return this.IdPreventivo;
  }

  int getIdCliente() {
    return this.IdCliente;
  }

  String getRagioneSociale() {
    return this.RagioneSociale;
  }

  String getRiferimentoInterno() {
    return this.RiferimentoInterno;
  }
}
