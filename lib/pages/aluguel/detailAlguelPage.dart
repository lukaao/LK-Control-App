import 'package:flutter/material.dart';
import 'package:lk/components/appbar.dart';
import 'package:lk/components/bottomNavigationbar.dart';
import 'package:lk/components/buttom.dart';
import 'package:lk/database/repository/aluguel-repository.dart';
import 'package:lk/database/repository/categoria-repository.dart';
import 'package:lk/database/repository/cliente-repository.dart';

import 'package:lk/entity/aluguel.dart';
import 'package:lk/entity/categoria.dart';
import 'package:lk/entity/cliente.dart';
import 'package:lk/entity/produto.dart';
import 'package:lk/helpers/formaters.dart';
import 'package:lk/pages/produto/produtoPage.dart';
import 'package:lk/sync/sync-alugueis.dart';
import 'package:lk/sync/sync-categoria.dart';
import 'package:lk/sync/sync-cliente.dart';

class DetailAluguelPage extends StatefulWidget {
  Aluguel? aluguel;
  DetailAluguelPage({super.key, this.aluguel});

  @override
  State<DetailAluguelPage> createState() => _DetailAluguelPageState();
}

class _DetailAluguelPageState extends State<DetailAluguelPage> {
  Aluguel? aluguel;

  TextEditingController _statusController = TextEditingController();
  TextEditingController _clienteController = TextEditingController();
  TextEditingController _produtoController = TextEditingController();
  TextEditingController _contatoController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _datainicioController = TextEditingController();
  TextEditingController _datafinalController = TextEditingController();
  TextEditingController _valorController = TextEditingController();

  FocusNode myFocusNodeCliente = FocusNode();
  FocusNode myFocusNodeProduto = FocusNode();
  FocusNode myFocusNodeContato = FocusNode();
  FocusNode myFocusNodeEndereco = FocusNode();
  FocusNode myFocusNodeDataInicio = FocusNode();
  FocusNode myFocusNodeDataFinal = FocusNode();
  FocusNode myFocusNodeValor = FocusNode();

  _sincronizar() async {
    await SincronizarAluguel().buscarAluguel();
    await SincronizarCliente().buscarCliente();
  }

  _campos() async {
    if (aluguel != null) {
      if (aluguel!.status == 0) {
        _statusController.text = "Faturado";
      } else if (aluguel!.status == 1) {
        _statusController.text = "Em andamento";
      } else {
        _statusController.text = "Cancelado";
      }
      _clienteController.text = aluguel!.cliente!.nome;
      _contatoController.text = aluguel!.cliente!.contato;
      _produtoController.text = aluguel!.produto!.descricao;
      _enderecoController.text = aluguel!.endereco;
      _datainicioController.text = formatarData(aluguel!.dataInicio);
      _datafinalController.text = formatarData(aluguel!.dataFinal);
      _valorController.text = formatarReal(aluguel!.precoInicial);
    }

    // _descricaoController.text = produto!.descricao;
    // _codigoController.text = produto!.codigo;
  }

  @override
  void initState() {
    super.initState();
    aluguel = widget.aluguel;
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
        appBar: MyAppBar(title: "Aluguel"),
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
                          decoration: InputDecoration(
                            labelText: 'Cliente',
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
                          controller: _contatoController,
                          focusNode: myFocusNodeContato,
                          onSubmitted: (value) {
                            myFocusNodeContato.unfocus();
                          },
                          decoration: InputDecoration(
                            labelText: 'Contato',
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
                          controller: _enderecoController,
                          focusNode: myFocusNodeEndereco,
                          onSubmitted: (value) {
                            myFocusNodeEndereco.unfocus();
                          },
                          decoration: InputDecoration(
                            labelText: 'Endreço',
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
                      (aluguel != null)
                          ? Expanded(
                              child: TextField(
                                controller: _statusController,
                                style: TextStyle(
                                    color: (_statusController.text ==
                                            "Em andamento")
                                        ? Colors.green
                                        : (_statusController.text == "Faturado")
                                            ? Colors.orange
                                            : Colors.grey),
                                decoration: InputDecoration(
                                  labelText: 'Status',
                                  labelStyle: TextStyle(color: Colors.black),
                                  enabled: false,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .primaryColorDark), // Altere a cor aqui
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: '',
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: InputBorder.none,
                                  enabled: false,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Colors.white), // Altere a cor aqui
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _datainicioController,
                          focusNode: myFocusNodeDataInicio,
                          onSubmitted: (value) {
                            myFocusNodeDataInicio.unfocus();
                          },
                          decoration: InputDecoration(
                            labelText: 'Data Inicio',
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
                          controller: _datafinalController,
                          focusNode: myFocusNodeDataFinal,
                          onSubmitted: (value) {
                            myFocusNodeDataFinal.unfocus();
                          },
                          decoration: InputDecoration(
                            labelText: 'Data Final',
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

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _produtoController,
                          focusNode: myFocusNodeProduto,
                          onSubmitted: (value) {
                            myFocusNodeProduto.unfocus();
                          },
                          decoration: InputDecoration(
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
                      SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: _valorController,
                          focusNode: myFocusNodeValor,
                          onSubmitted: (value) {
                            myFocusNodeValor.unfocus();
                          },
                          decoration: InputDecoration(
                            labelText: 'Valor',
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
                    height: 120,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      if (aluguel != null)
                        MyButtom(
                          label: "Faturar",
                          labelColor: Colors.white,
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 40,
                          onPressed: () {},
                        ),
                      if (aluguel != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 10,
                        ),
                      MyButtom(
                        label: (aluguel != null) ? 'Salvar' : "Alugar",
                        labelColor: Colors.white,
                        color: Theme.of(context).primaryColorDark,
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        onPressed: () {},
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
