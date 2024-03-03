import 'dart:convert';

import 'package:lk/entity/categoria.dart';

class Produto {
  int? id;
  int codProd;
  String codigo;
  String descricao;
  int status;
  int codCat;
  DateTime dataInc;
  DateTime dataAlt;
  Categoria? categoria;

  Produto({
    this.id,
    required this.codProd,
    required this.codigo,
    required this.descricao,
    required this.status,
    required this.codCat,
    required this.dataInc,
    required this.dataAlt,
    this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'CODPROD': codProd,
      'CODIGO': codigo,
      'DESCRICAO': descricao,
      'STATUS': status,
      'CODCAT': codCat,
      'DATAINC': dataInc.toIso8601String(),
      'DATAALT': dataAlt.toIso8601String(),
      //'CATEGORIA': categoria.toMap(),
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map["ID"],
      codProd: map['CODPROD'],
      codigo: map['CODIGO'],
      descricao: map['DESCRICAO'],
      status: map['STATUS'],
      codCat: map['CODCAT'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
      categoria:
          map['CATEGORIA'] != null ? Categoria.fromMap(map['CATEGORIA']) : null,
    );
  }
  factory Produto.fromJson(Map<String, dynamic> map) {
    return Produto(
      id: map["ID"],
      codProd: map['CODPROD'],
      codigo: map['CODIGO'],
      descricao: map['DESCRICAO'],
      status: map['STATUS'],
      codCat: map['CODCAT'],
      dataInc: DateTime.parse(map['DATAINC']),
      dataAlt: DateTime.parse(map['DATAALT']),
      categoria: Categoria.fromMap(map['CATEGORIA']),
    );
  }
}
