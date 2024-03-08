import 'package:flutter/material.dart';
import 'package:lk/components/MyDialogInfoFatura.dart';
import 'package:lk/components/appbar.dart';
import 'package:lk/components/bottomNavigationbar.dart';
import 'package:lk/components/buttom.dart';
import 'package:lk/database/repository/faturar-repository.dart';
import 'package:lk/entity/aluguel.dart';
import 'package:lk/entity/faturar.dart';
import 'package:lk/helpers/formaters.dart';
import 'package:lk/pages/faturar/faturarPage.dart';
import 'package:lk/sync/sync-alugueis.dart';
import 'package:lk/sync/sync-cliente.dart';
import 'package:lk/sync/sync-faturar.dart';

class DetailAluguelPage extends StatefulWidget {
  Aluguel? aluguel;
  DetailAluguelPage({super.key, this.aluguel});

  @override
  State<DetailAluguelPage> createState() => _DetailAluguelPageState();
}

class _DetailAluguelPageState extends State<DetailAluguelPage> {
  Aluguel? aluguel;
  List<Faturar> fatura = [];

  DateTime? _dataSelecionada;

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

  FaturarRepository fatRepo = FaturarRepository();

  _sincronizar() async {
    await SincronizarAluguel().buscarAluguel();
    await SincronizarCliente().buscarCliente();
    await SincronizarFaturar().buscarFaturar();

    Faturar? fat;

    if (aluguel != null) {
      fat = await fatRepo.getByCodAlu(aluguel!.codAlu);
    }

    if (mounted && fat != null) {
      setState(() {
        fatura.add(fat!);
      });
    }
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
      _valorController.text = aluguel!.precoInicial.toString();
    }
  }

  Future<void> _selecionarData(BuildContext context, controller) async {
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
        controller.text = formatarData(dataEscolhida);
      });
    }
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
                        child: InkWell(
                          onTap: () {
                            _selecionarData(context, _datainicioController);
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Data Inicio',
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
                                  _datainicioController
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
                      SizedBox(width: 20),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _selecionarData(context, _datafinalController);
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
                                  _datafinalController
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
                            prefixText: 'R\$ ',
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
                      if (aluguel != null && aluguel!.status == 1)
                        MyButtom(
                          label: "Faturar",
                          labelColor: Colors.white,
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 40,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => FaturarPage(
                                      aluguel: aluguel!,
                                    )));
                          },
                        ),
                      if (aluguel != null && aluguel!.status == 1)
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

                  (fatura.length > 0)
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
                                    "Valor",
                                    softWrap: true,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Custo",
                                    softWrap: true,
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    "Data Faturado",
                                    softWrap: true,
                                  ),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                fatura.length,
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
                                            showMyDialogInfoFatura(
                                                context: context,
                                                title: "Fatura",
                                                aluguel: aluguel!,
                                                faturar: fatura[index]);
                                          },
                                          icon: const Icon(Icons
                                              .arrow_circle_right_outlined),
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                    DataCell(
                                      Text(
                                        formatarReal(fatura[index]!.precoFinal),
                                        softWrap: true,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        formatarReal(fatura[index]!.custo),
                                        softWrap: true,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        "${fatura[index]!.dataFaturado.month.toString().padLeft(2, '0')}/${fatura[index]!.dataFaturado.day.toString().padLeft(2, '0')}",
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
