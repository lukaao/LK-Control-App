import 'package:flutter/material.dart';
import 'package:lk/entity/aluguel.dart';
import 'package:lk/entity/faturar.dart';
import 'package:lk/helpers/formaters.dart';

showMyDialogInfoFatura(
    {required BuildContext context,
    required String title,
    required Aluguel aluguel,
    required Faturar faturar,
    Widget? child}) {
  TextEditingController _clienteController = TextEditingController();
  TextEditingController _produtoController = TextEditingController();
  TextEditingController _dataFaturadoController = TextEditingController();
  TextEditingController _valorInicialController = TextEditingController();
  TextEditingController _valorFinalController = TextEditingController();
  TextEditingController _custoController = TextEditingController();

  _clienteController.text = aluguel.cliente!.nome;
  _produtoController.text = aluguel.produto!.descricao;
  _valorInicialController.text = formatarReal(aluguel.precoInicial);
  _dataFaturadoController.text = formatarData(faturar.dataFaturado);
  _valorFinalController.text = formatarReal(faturar.precoFinal);
  _custoController.text = formatarReal(faturar.custo);

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          surfaceTintColor: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      // Primeira linha
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _clienteController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Cliente',
                                enabled: false,
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              controller: _produtoController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                enabled: false,
                                labelText: 'Produto',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _valorInicialController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                enabled: false,
                                labelText: 'Valor Inicial',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              controller: _valorFinalController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                enabled: false,
                                labelText: 'Valor Final',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _custoController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                enabled: false,
                                labelText: 'Custo Operacional',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              controller: _dataFaturadoController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                enabled: false,
                                labelText: 'Data Faturado',
                                labelStyle: TextStyle(color: Colors.black),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColorDark), // Altere a cor aqui
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    },
  );
}
