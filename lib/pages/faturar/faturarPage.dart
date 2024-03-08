import 'package:flutter/material.dart';
import 'package:lk/components/appbar.dart';
import 'package:lk/components/bottomNavigationbar.dart';
import 'package:lk/components/buttom.dart';
import 'package:lk/entity/aluguel.dart';
import 'package:lk/entity/faturar.dart';
import 'package:lk/helpers/formaters.dart';

class FaturarPage extends StatefulWidget {
  Aluguel aluguel;
  Faturar? fatura;
  FaturarPage({super.key, required this.aluguel, this.fatura});

  @override
  State<FaturarPage> createState() => _FaturarPageState();
}

class _FaturarPageState extends State<FaturarPage> {
  Aluguel? aluguel;

  Faturar? fatura;

  DateTime? _dataSelecionada;

  TextEditingController _clienteController = TextEditingController();
  TextEditingController _produtoController = TextEditingController();
  TextEditingController _dataFaturadoController = TextEditingController();
  TextEditingController _valorInicialController = TextEditingController();
  TextEditingController _valorFinalController = TextEditingController();
  TextEditingController _custoController = TextEditingController();

  FocusNode myFocusNodeCliente = FocusNode();
  FocusNode myFocusNodeProduto = FocusNode();
  FocusNode myFocusNodeDataFaturado = FocusNode();
  FocusNode myFocusNodeValorInicial = FocusNode();
  FocusNode myFocusNodeValorFinal = FocusNode();
  FocusNode myFocusNodeCusto = FocusNode();

  _sincronizar() async {}

  _campos() async {
    if (aluguel != null) {
      _clienteController.text = aluguel!.cliente!.nome;
      _produtoController.text = aluguel!.produto!.descricao;
      _valorInicialController.text = formatarReal(aluguel!.precoInicial);
    }

    if (fatura != null) {
      _dataFaturadoController.text = formatarData(fatura!.dataFaturado);
      _valorFinalController.text = formatarReal(fatura!.precoFinal);
      _custoController.text = formatarReal(fatura!.custo);
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    var dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColorDark,

            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColorDark,
            ), // Altere a cor do calendário aqui
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (dataEscolhida != null && dataEscolhida != _dataSelecionada) {
      setState(() {
        _dataSelecionada = dataEscolhida;
        _dataFaturadoController.text = formatarData(dataEscolhida);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    aluguel = widget.aluguel;
    fatura = widget.fatura;
    _campos();
    _sincronizar();
    BottomNavigationController instance = BottomNavigationController.instance;
    instance.changeIndex(2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(title: "Faturar"),
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
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
                          focusNode: myFocusNodeCliente,
                          onSubmitted: (value) {
                            myFocusNodeCliente.unfocus();
                          },
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
                          focusNode: myFocusNodeProduto,
                          onSubmitted: (value) {
                            myFocusNodeProduto.unfocus();
                          },
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
                          focusNode: myFocusNodeValorInicial,
                          onSubmitted: (value) {
                            myFocusNodeValorInicial.unfocus();
                          },
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
                          focusNode: myFocusNodeValorFinal,
                          onSubmitted: (value) {
                            myFocusNodeValorFinal.unfocus();
                          },
                          decoration: InputDecoration(
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
                          focusNode: myFocusNodeCusto,
                          onSubmitted: (value) {
                            myFocusNodeCusto.unfocus();
                          },
                          decoration: InputDecoration(
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
                        child: InkWell(
                          onTap: () {
                            _selecionarData(context);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Data Final',
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _dataFaturadoController
                                      .text, // Exibe a data aqui
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Icon(Icons
                                    .calendar_today), // Ícone que simboliza a interação
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 120,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      if (fatura == null)
                        MyButtom(
                          label: "Faturar",
                          labelColor: Colors.white,
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 40,
                          onPressed: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (BuildContext context) =>
                            //         FaturarPage()));
                          },
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
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
