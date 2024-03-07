class Categoria {
  int? id;
  int codCat;
  String descricao;
  int status;
  DateTime dataInc;
  DateTime dataAlt;

  Categoria({
    this.id,
    required this.codCat,
    required this.descricao,
    required this.status,
    required this.dataInc,
    required this.dataAlt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'CODCAT': codCat,
      'DESCRICAO': descricao,
      'STATUS': status,
      'DATAINC': dataInc.toIso8601String(),
      'DATAALT': dataAlt.toIso8601String(),
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map["ID"],
      codCat: map['CODCAT'],
      descricao: map['DESCRICAO'],
      status: map['STATUS'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
    );
  }
  factory Categoria.fromJson(Map<String, dynamic> map) {
    return Categoria(
      id: map["ID"],
      codCat: map['CODCAT'],
      descricao: map['DESCRICAO'],
      status: map['STATUS'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
    );
  }
}
