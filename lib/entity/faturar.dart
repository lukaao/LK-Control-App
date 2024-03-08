class Faturar {
  int? id;
  int codFat;
  double custo;
  double precoFinal;
  DateTime dataFaturado;
  int codAlu;
  DateTime dataInc;
  DateTime dataAlt;

  Faturar({
    this.id,
    required this.codFat,
    required this.custo,
    required this.precoFinal,
    required this.dataFaturado,
    required this.codAlu,
    required this.dataInc,
    required this.dataAlt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'CODFAT': codFat,
      'CUSTO': custo,
      'PRECOFINAL': precoFinal,
      'DATAFATURADO': dataFaturado.toIso8601String(),
      'CODALU': codAlu,
      'DATAINC': dataInc.toIso8601String(),
      'DATAALT': dataAlt.toIso8601String(),
    };
  }

  factory Faturar.fromMap(Map<String, dynamic> map) {
    return Faturar(
      id: map['ID'],
      codFat: map['CODFAT'],
      custo: map['CUSTO'],
      precoFinal: map['PRECOFINAL'],
      dataFaturado: DateTime.parse(map['DATAFATURADO']),
      codAlu: map['CODALU'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
    );
  }

  factory Faturar.fromJson(Map<String, dynamic> map) {
    return Faturar(
      id: map['ID'],
      codFat: map['CODFAT'],
      custo: map['CUSTO'],
      precoFinal: map['PRECOFINAL'],
      dataFaturado: DateTime.parse(map['DATAFATURADO']),
      codAlu: map['CODALU'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
    );
  }
}
