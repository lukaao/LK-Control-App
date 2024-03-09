import 'dart:ffi';

import 'package:intl/intl.dart';

String formatarReal(double number) {
  double precoInicial = number;

  // Criar um formato para moeda brasileira (BRL)
  final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  // Formatando o preço inicial
  String precoFormatado = formatoMoeda.format(precoInicial);

  return precoFormatado;
}

String formatarParaDuasCasasDecimais(String input) {
  try {
    double numero = double.parse(input);
    String numeroFormatado = numero.toStringAsFixed(2);
    return numeroFormatado;
  } catch (e) {
    print(e);
    return "Formato inválido";
  }
}

String formatarData(DateTime data) {
  String dia = data.day.toString().padLeft(2, '0');
  String mes = data.month.toString().padLeft(2, '0');
  String ano = data.year.toString();

  String dataFormatada = '$dia/$mes/$ano';
  return dataFormatada;
}
