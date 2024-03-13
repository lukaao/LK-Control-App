import 'package:flutter/material.dart';
import 'package:lk/components/appbar.dart';
import 'package:lk/components/bottomNavigationbar.dart';
import 'package:lk/components/drawer.dart';

import 'package:lk/database/repository/aluguel-repository.dart';

import 'package:lk/database/repository/cliente-repository.dart';
import 'package:lk/database/repository/produto-repository.dart';
import 'package:lk/entity/aluguel.dart';
import 'package:lk/entity/cliente.dart';
import 'package:lk/entity/produto.dart';
import 'package:lk/pages/aluguel/detailAlguelPage.dart';

import 'package:lk/sync/sync-alugueis.dart';

import 'package:lk/sync/sync-cliente.dart';
import 'package:lk/sync/sync-produtos.dart';

class AluguelPage extends StatefulWidget {
  const AluguelPage({super.key});

  @override
  State<AluguelPage> createState() => _AluguelPageState();
}

class _AluguelPageState extends State<AluguelPage> {
  bool _isLoading = true;
  List<Aluguel> alugueis = [];
  List<Aluguel> alugueisFiltrados = [];

  ProdutoRepository prodRepo = ProdutoRepository();
  AluguelRepository aluRepo = AluguelRepository();
  ClienteRepository cliRepo = ClienteRepository();

  _sincronizar() async {
    await SincronizarProduto().buscarProduto();
    await SincronizarAluguel().buscarAluguel();
    await SincronizarCliente().buscarCliente();

    List<Aluguel> alus = await aluRepo.getByStatus(1);

    for (var alu in alus) {
      Produto? aluprod = await prodRepo.getByCodProd(alu.codProd);
      alu.produto = aluprod;
      Cliente? alucli = await cliRepo.getByCodCli(alu.codCli);
      alu.cliente = alucli;
    }
    if (mounted) {
      setState(() {
        alugueis = alus;
        alugueisFiltrados = alus;
        _isLoading = false;
      });
    }
  }

  _pesquisa(value) {
    List<Aluguel> alus = alugueis;
    if (value.isNotEmpty) {
      alus = alus.where((element) {
        return element.produto!.descricao
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase()) ||
            element.produto!.codigo
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase()) ||
            element.cliente!.nome
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase()) ||
            element.endereco
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase());
      }).toList();
    }
    setState(() {
      alugueisFiltrados = alus;
    });
  }

  @override
  void initState() {
    super.initState();
    _sincronizar();
    BottomNavigationController instance = BottomNavigationController.instance;
    instance.changeIndex(2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: "Alugueis"),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => DetailAluguelPage()));
            // MyDataBase.dropDatabase();
          },
          backgroundColor: Theme.of(context).primaryColorDark,
          child: Icon(Icons.add),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Total de alugueis: ${alugueisFiltrados.length}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: alugueisFiltrados.length,
                    itemBuilder: (context, index) {
                      Aluguel alu = alugueisFiltrados[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailAluguelPage(
                                    aluguel: alu,
                                  )));
                        },
                        child: Card(
                          elevation: 2, // Adiciona elevação
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Borda circular
                          ),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alu.cliente!.nome.toUpperCase() ?? '',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Status: Em andamento",
                                  style: TextStyle(color: Colors.green[800]),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Contato: ${alu.cliente!.contato.toString()}",
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Produto: ${alu.produto!.descricao.toString()}",
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Cód. Prod: ${alu.produto!.codigo.toString()}",
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Endereço: ${alu.endereco.toString()}",
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
