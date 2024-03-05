class Cliente {
  int? id;
  int codCli;
  String nome;
  String contato;
  DateTime dataInc;
  DateTime dataAlt;

  Cliente({
    this.id,
    required this.codCli,
    required this.nome,
    required this.contato,
    required this.dataInc,
    required this.dataAlt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'CODCLI': codCli,
      'NOME': nome,
      'CONTATO': contato,
      'DATAINC': dataInc.toIso8601String(),
      'DATAALT': dataAlt.toIso8601String(),
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map["ID"],
      codCli: map['CODCLI'],
      nome: map['NOME'],
      contato: map['CONTATO'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
    );
  }

  factory Cliente.fromJson(Map<String, dynamic> map) {
    return Cliente(
      id: map["ID"],
      codCli: map['CODCLI'],
      nome: map['NOME'],
      contato: map['CONTATO'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
    );
  }
}
