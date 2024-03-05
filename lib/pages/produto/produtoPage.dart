import 'package:flutter/material.dart';
import 'package:lk/components/appbar.dart';
import 'package:lk/components/bottomNavigationbar.dart';
import 'package:lk/components/drawer.dart';
import 'package:lk/components/layoutTelas.dart';
import 'package:lk/database/configDb.dart';
import 'package:lk/database/repository/categoria-repository.dart';
import 'package:lk/database/repository/produto-repository.dart';
import 'package:lk/entity/categoria.dart';
import 'package:lk/entity/produto.dart';
import 'package:lk/pages/produto/detailProdutoPage.dart';
import 'package:lk/sync/sync-categoria.dart';
import 'package:lk/sync/sync-produtos.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  bool _isLoading = true;
  List<Produto> produtos = [];
  List<Produto> produtosFiltrados = [];
  CategoriaRepository catRepo = CategoriaRepository();
  ProdutoRepository prodRepo = ProdutoRepository();

  _sincronizar() async {
    await SincronizarCategoria().buscarCategoria();
    await SincronizarProduto().buscarProduto();

    List<Produto> prods = await prodRepo.get();

    for (var prod in prods) {
      Categoria? catprod = await catRepo.getByCodCat(prod.codCat);
      prod.categoria = catprod;
    }

    setState(() {
      produtos = prods;
      produtosFiltrados = prods;
      _isLoading = false;
    });
  }

  _pesquisa(value) {
    List<Produto> prods = produtos;
    if (value.isNotEmpty) {
      prods = prods.where((element) {
        return element.descricao
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase()) ||
            element.codigo
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase()) ||
            element.status
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase()) ||
            element.categoria!.descricao
                .toString()
                .toUpperCase()
                .contains(value.toString().toUpperCase());
      }).toList();
    }
    setState(() {
      produtosFiltrados = prods;
    });
  }

  @override
  void initState() {
    super.initState();
    _sincronizar();
    BottomNavigationController instance = BottomNavigationController.instance;
    instance.changeIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: "Produtos"),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => DetailProdutoPage()));
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
                TextFormField(
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Total de produtos: ${produtosFiltrados.length}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: produtosFiltrados.length,
                    itemBuilder: (context, index) {
                      Produto prod = produtosFiltrados[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DetailProdutoPage(
                                    produto: prod,
                                  )));
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: ListTile(
                                title: Text(
                                  prod.descricao ?? '',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status: ${(prod.status == 0) ? "Indisponível" : (prod.status == 1) ? "Disponível" : "Inativo"}",
                                      style: TextStyle(
                                        color: (prod.status == 1)
                                            ? Colors.green[800]
                                            : (prod.status == 0)
                                                ? Colors.red
                                                : Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "Cód Produto: ${prod.codigo.toString()}",
                                    ),
                                    Text(
                                      "Categoria: ${prod.categoria?.descricao.toString()}",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ],
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
