import 'package:flutter/material.dart';
import 'package:lk/components/appbar.dart';
import 'package:lk/components/bottomNavigationbar.dart';
import 'package:lk/components/drawer.dart';
import 'package:lk/database/repository/categoria-repository.dart';
import 'package:lk/database/repository/produto-repository.dart';
import 'package:lk/entity/categoria.dart';
import 'package:lk/entity/produto.dart';
import 'package:lk/pages/produto/detailProdutoPage.dart';
import 'package:lk/sync/sync-categoria.dart';
import 'package:lk/sync/sync-produtos.dart';

class ProdutosPage extends StatefulWidget {
  final Function(Produto)? callBack;
  bool? filtro;
  ProdutosPage({super.key, this.filtro, this.callBack});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  bool _isLoading = true;
  List<Produto> produtos = [];
  List<Produto> produtosFiltrados = [];
  CategoriaRepository catRepo = CategoriaRepository();
  ProdutoRepository prodRepo = ProdutoRepository();

  bool filtro = false;

  _sincronizar() async {
    await SincronizarCategoria().buscarCategoria();
    await SincronizarProduto().buscarProduto();

    if (filtro == false) {
      List<Produto> prods = await prodRepo.get();

      for (var prod in prods) {
        Categoria? catprod = await catRepo.getByCodCat(prod.codCat);
        prod.categoria = catprod;
      }

      if (mounted) {
        setState(() {
          produtos = prods;
          produtosFiltrados = prods;
          _isLoading = false;
        });
      }
    } else if (filtro == true) {
      List<Produto> prods = await prodRepo.getByStatus();

      for (var prod in prods) {
        Categoria? catprod = await catRepo.getByCodCat(prod.codCat);
        prod.categoria = catprod;
      }

      if (mounted) {
        setState(() {
          produtos = prods;
          produtosFiltrados = prods;
          _isLoading = false;
        });
      }
    }
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
    filtro = widget.filtro ?? false;
    BottomNavigationController instance = BottomNavigationController.instance;
    instance.changeIndex(1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: "Produtos"),
        drawer: filtro == false ? MyDrawer() : null,
        floatingActionButton: filtro == true
            ? null
            : FloatingActionButton(
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
                          if (widget.callBack != null && filtro == true) {
                            widget.callBack!(prod);
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DetailProdutoPage(
                                      produto: prod,
                                    )));
                          }
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
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prod.descricao ?? '',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),
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
                                SizedBox(height: 5),
                                Text(
                                  "Cód Produto: ${prod.codigo.toString()}",
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Categoria: ${prod.categoria?.descricao.toString()}",
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
        bottomNavigationBar: filtro == false ? BottomNavigation() : null,
      ),
    );
  }
}
