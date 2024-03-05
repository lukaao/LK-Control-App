import 'package:lk/entity/cliente.dart';

class Aluguel {
  int? id;
  int codAlu;
  int status;
  DateTime dataInicio;
  DateTime dataFinal;
  String endereco;
  double precoInicial;
  int codCli;
  int codProd;
  DateTime dataInc;
  DateTime dataAlt;
  Cliente? cliente;

  Aluguel(
      {this.id,
      required this.codAlu,
      required this.status,
      required this.dataInicio,
      required this.dataFinal,
      required this.endereco,
      required this.precoInicial,
      required this.codCli,
      required this.codProd,
      required this.dataInc,
      required this.dataAlt,
      this.cliente});

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'CODALU': codAlu,
      'STATUS': status,
      'DATAINICIO': dataInicio.toIso8601String(),
      'DATAFINAL': dataFinal.toIso8601String(),
      'ENDERECO': endereco,
      'PRECOINICIAL': precoInicial,
      'CODCLI': codCli,
      'CODPROD': codProd,
      'DATAINC': dataInc.toIso8601String(),
      'DATAALT': dataAlt.toIso8601String(),
    };
  }

  factory Aluguel.fromMap(Map<String, dynamic> map) {
    return Aluguel(
      id: map["ID"],
      codAlu: map['CODALU'],
      status: map['STATUS'],
      dataInicio: DateTime.parse(map['DATAINICIO']),
      dataFinal: DateTime.parse(map['DATAFINAL']),
      endereco: map['ENDERECO'],
      precoInicial: map['PRECOINICIAL'].toDouble(),
      codCli: map['CODCLI'],
      codProd: map['CODPROD'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
      cliente: map['CLIENTE'] != null ? Cliente.fromMap(map['CLIENTE']) : null,
    );
  }
  factory Aluguel.fromJson(Map<String, dynamic> map) {
    return Aluguel(
      id: map["ID"],
      codAlu: map['CODALU'],
      status: map['STATUS'],
      dataInicio: DateTime.parse(map['DATAINICIO']),
      dataFinal: DateTime.parse(map['DATAFINAL']),
      endereco: map['ENDERECO'],
      precoInicial: map['PRECOINICIAL'].toDouble(),
      codCli: map['CODCLI'],
      codProd: map['CODPROD'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
      cliente: Cliente.fromMap(map['CLIENTE']),
    );
  }
}
