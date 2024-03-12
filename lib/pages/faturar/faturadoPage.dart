import 'package:flutter/material.dart';
import 'package:lk/components/MyDialogInfoFatura.dart';
import 'package:lk/components/appbar.dart';
import 'package:lk/components/bottomNavigationbar.dart';
import 'package:lk/components/drawer.dart';
import 'package:lk/database/repository/aluguel-repository.dart';
import 'package:lk/database/repository/cliente-repository.dart';
import 'package:lk/database/repository/faturar-repository.dart';
import 'package:lk/database/repository/produto-repository.dart';
import 'package:lk/entity/aluguel.dart';
import 'package:lk/entity/cliente.dart';
import 'package:lk/entity/faturar.dart';
import 'package:lk/entity/produto.dart';
import 'package:lk/helpers/formaters.dart';
import 'package:lk/sync/sync-faturar.dart';

class FaturadoPage extends StatefulWidget {
  const FaturadoPage({super.key});

  @override
  State<FaturadoPage> createState() => _FaturadoPageState();
}

class _FaturadoPageState extends State<FaturadoPage> {
  List<Faturar> faturados = [];
  List<Faturar> faturadosFiltrados = [];
  FaturarRepository fatRepo = FaturarRepository();
  AluguelRepository aluRepo = AluguelRepository();
  ClienteRepository cliRepo = ClienteRepository();
  ProdutoRepository prodRepo = ProdutoRepository();

  bool _isLoading = true;

  _sincronizar() async {
    try {
      await SincronizarFaturar().buscarFaturar();
      List<Faturar> fats = await fatRepo.get();

      if (mounted) {
        for (var fat in fats) {
          Aluguel? alu = await aluRepo.getByCodAlu(fat.codAlu);
          Produto? aluprod = await prodRepo.getByCodProd(alu!.codProd);
          alu.produto = aluprod;
          Cliente? alucli = await cliRepo.getByCodCli(alu.codCli);
          alu.cliente = alucli;
          fat.aluguel = alu;
        }
      }

      fats.sort((a, b) => b.dataFaturado.compareTo(a.dataFaturado));
      if (mounted) {
        setState(() {
          faturados = fats;
          faturadosFiltrados = fats;
          _isLoading = false;
        });
      }
    } catch (e, stc) {
      print(e);
      print(stc);
    }
  }

  _pesquisa(value) {
    List<Faturar> fats = faturados;
    if (value.isNotEmpty) {
      fats = fats.where((element) {
        return element.aluguel!.produto!.descricao
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase()) ||
            element.aluguel!.cliente!.nome
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase()) ||
            element.dataFaturado
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase()) ||
            element.precoFinal
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase());
      }).toList();
    }
    setState(() {
      faturadosFiltrados = fats;
    });
  }

  @override
  void initState() {
    super.initState();
    _sincronizar();
    BottomNavigationController instance = BottomNavigationController.instance;
    instance.changeIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(title: "Faturados"),
        drawer: MyDrawer(),
        body: Stack(
          children: [
            if (_isLoading == false)
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        onChanged: _pesquisa,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          labelText: "Buscar",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Container(
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
                                    "Produto",
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
                                    "Data",
                                    softWrap: true,
                                  ),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                faturadosFiltrados.length,
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
                                    },
                                  ),
                                  cells: <DataCell>[
                                    DataCell(
                                      IconButton(
                                          onPressed: () {
                                            showMyDialogInfoFatura(
                                                context: context,
                                                title: "Faturado",
                                                aluguel:
                                                    faturadosFiltrados[index]
                                                        .aluguel!,
                                                faturar:
                                                    faturadosFiltrados[index]);
                                          },
                                          icon: const Icon(Icons
                                              .arrow_circle_right_outlined),
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                    DataCell(
                                      Text(
                                        faturadosFiltrados[index]
                                            .aluguel!
                                            .produto!
                                            .descricao
                                            .toString(),
                                        softWrap: true,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        formatarReal(faturadosFiltrados[index]
                                            .precoFinal),
                                        softWrap: true,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        formatarReal(
                                            faturadosFiltrados[index].custo),
                                        softWrap: true,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        formatarData(faturadosFiltrados[index]
                                            .dataFaturado),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (_isLoading == true)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColorDark),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
