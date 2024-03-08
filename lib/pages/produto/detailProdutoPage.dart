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
import 'package:lk/pages/aluguel/detailAlguelPage.dart';
import 'package:lk/sync/sync-alugueis.dart';
import 'package:lk/sync/sync-categoria.dart';
import 'package:lk/sync/sync-cliente.dart';

class DetailProdutoPage extends StatefulWidget {
  Produto? produto;
  DetailProdutoPage({super.key, this.produto});

  @override
  State<DetailProdutoPage> createState() => _DetailProdutoPageState();
}

class _DetailProdutoPageState extends State<DetailProdutoPage> {
  List<String> categorias = [];
  List<Aluguel> alugueis = [];
  CategoriaRepository catRepo = CategoriaRepository();
  String? categoriaSelecionada;

  Produto? produto;

  TextEditingController _statusController = TextEditingController();
  TextEditingController _codigoController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  FocusNode myFocusNodeDescricao = FocusNode();
  FocusNode myFocusNodeCodigo = FocusNode();

  AluguelRepository aluRepo = AluguelRepository();
  ClienteRepository cliRepo = ClienteRepository();

  _sincronizar() async {
    await SincronizarCategoria().buscarCategoria();
    await SincronizarAluguel().buscarAluguel();
    await SincronizarCliente().buscarCliente();

    List<Categoria> cats = await catRepo.get();

    for (var cat in cats) {
      setState(() {
        categorias.add(cat.descricao);
      });
    }

    List<Aluguel> alus = await aluRepo.getByCodProd(produto!.codProd);

    for (var alu in alus) {
      Cliente? alucli = await cliRepo.getByCodCli(alu.codCli);
      alu.cliente = alucli;
      alu.produto = produto;
    }
    alus.sort((a, b) => b.dataInicio.compareTo(a.dataInicio));

    if (mounted) {
      setState(() {
        alugueis.addAll(alus);
        alugueis = alus;
      });
    }
  }

  _campos() async {
    if (produto != null) {
      if (produto!.status == 0) {
        _statusController.text = "Indisponível";
      } else if (produto!.status == 1) {
        _statusController.text = "Disponível";
      } else {
        _statusController.text = "Inativo";
      }

      Categoria? cat = await catRepo.getByCodCat(produto!.codCat);
      categoriaSelecionada = cat!.descricao;

      _descricaoController.text = produto!.descricao;
      _codigoController.text = produto!.codigo;
    }
  }

  @override
  void initState() {
    super.initState();
    produto = widget.produto;
    _campos();
    _sincronizar();
    BottomNavigationController instance = BottomNavigationController.instance;
    instance.changeIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(title: "Produto"),
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
                          controller: _codigoController,
                          focusNode: myFocusNodeCodigo,
                          onSubmitted: (value) {
                            myFocusNodeCodigo.unfocus();
                          },
                          decoration: InputDecoration(
                            labelText: 'Código',
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
                          controller: _descricaoController,
                          focusNode: myFocusNodeDescricao,
                          onSubmitted: (value) {
                            myFocusNodeDescricao.unfocus();
                          },
                          decoration: InputDecoration(
                            labelText: 'Descrição',
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
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Categoria',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark),
                            ),
                          ),
                          hint: const Text('Categoria'),
                          value: categoriaSelecionada,
                          onChanged: (String? novoValor) {
                            setState(() {
                              categoriaSelecionada = novoValor!;
                            });
                          },
                          items: categorias.map((String categoria) {
                            return DropdownMenuItem<String>(
                              value: categoria.toString(),
                              child: Text(categoria.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 20),
                      (produto != null)
                          ? Expanded(
                              child: TextField(
                                controller: _statusController,
                                style: TextStyle(
                                    color:
                                        (_statusController.text == "Disponível")
                                            ? Colors.green
                                            : (_statusController.text ==
                                                    "Indisponível")
                                                ? Colors.red
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
                  const SizedBox(
                    height: 120,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      // MyButtom(
                      //   label: 'Adicionar',
                      //   width: MediaQuery.of(context).size.width * 0.4,
                      //   height: 40,
                      //   onPressed: () {},
                      // ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.1,
                      //   height: 10,
                      // ),
                      MyButtom(
                        label: (produto != null) ? 'Salvar' : "Cadastrar",
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

                  (produto != null)
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            child: DataTable(
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    "Ação",
                                    softWrap: true,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Status",
                                    softWrap: true,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "DTINC",
                                    softWrap: true,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "DTFIM",
                                    softWrap: true,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Cliente",
                                    softWrap: true,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Valor",
                                    softWrap: true,
                                  ),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                alugueis.length,
                                (index) => DataRow(
                                  color:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.08);
                                    }

                                    if (index.isEven) {
                                      return Colors.grey.withOpacity(0.3);
                                    }
                                    return null;
                                  }),
                                  cells: <DataCell>[
                                    DataCell(
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        DetailAluguelPage(
                                                  aluguel: alugueis[index],
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons
                                              .arrow_circle_right_outlined),
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                    DataCell(
                                      Text(
                                        (alugueis[index].status == 0)
                                            ? "Faturado"
                                            : (alugueis[index].status == 1)
                                                ? "Em andamento"
                                                : "Cancelado",
                                        softWrap: true,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        "${alugueis[index].dataInicio.month.toString().padLeft(2, '0')}/${alugueis[index].dataInicio.day.toString().padLeft(2, '0')}",
                                        softWrap: true,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        "${alugueis[index].dataFinal.month.toString().padLeft(2, '0')}/${alugueis[index].dataFinal.day.toString().padLeft(2, '0')}",
                                        softWrap: true,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        alugueis[index]
                                            .cliente!
                                            .nome
                                            .toString(),
                                        softWrap: true,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        formatarReal(
                                            alugueis[index].precoInicial),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
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
