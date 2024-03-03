import "dart:convert";
import "package:lk/database/repository/produto-repository.dart";
import "package:lk/entity/produto.dart";
import "package:lk/reqs/interno.dart";
import "package:shared_preferences/shared_preferences.dart";

class SincronizarProduto {
  ProdutoRepository prodRepo = ProdutoRepository();

  buscarProduto() async {
    try {
      var response = await MyReqs().get("/produto/listar/");
      if (response.statusCode == 200) {
        List<Produto> produtos =
            List<Map<String, dynamic>>.from(json.decode(response.body))
                .map((e) => Produto.fromJson(e))
                .toList();

        for (var produto in produtos) {
          Produto? prodexiste = await prodRepo.getByCodProd(produto.codProd);

          if (prodexiste == null) {
            await prodRepo.insert(produto);
          } else {
            produto.id = prodexiste.id;
            await prodRepo.update(produto);
          }
        }
      } else if (response.statusCode != 404) {
        throw Exception("Erro ao buscar log de Produto ${response.body}");
      }
    } catch (e, stc) {
      print("Erro ao buscar log de produto! $e");
      print(stc);
    }
  }

  // processarLogProduto() async {
  //   List<LogProduto> logNaoProcessados =
  //       await logRepo.getLogProdutoNaoProcessado();
  //   for (LogProduto log in logNaoProcessados) {
  //     if (log.produto != null) {
  //       Map<String, dynamic> responseMap = json.decode(log.produto!);

  //       Produto proApi = Produto.fromJson(responseMap);
  //       Produto? probd = await prodRepo.getProdutoByCodProd(proApi.codprod!);

  //       if (probd == null) {
  //         await prodRepo.insertProduto(proApi);
  //       } else {
  //         proApi.id = probd.id;
  //         await prodRepo.updateProduto(proApi);
  //       }

  //       if (responseMap["Categoria"] != null) {
  //         Categoria catApi = Categoria.fromMap(responseMap["Categoria"]);
  //         Categoria? catbd =
  //             await catRepo.getCategoriaByCodcatprod(catApi.CODCATPROD!);

  //         if (catbd == null) {
  //           await catRepo.insertCategoria(catApi);
  //         } else {
  //           catApi.ID = catbd.ID;
  //           await catRepo.updateCategorias(catApi);
  //         }
  //       }

  //       if (responseMap["UnidadeMedidas"] != null) {
  //         UnidadeMedida unMedApi =
  //             UnidadeMedida.fromMap(responseMap["UnidadeMedidas"]);
  //         UnidadeMedida? unMedbd =
  //             await unMedidaRepo.getUnidadeMedidaByCodunmed(unMedApi.codUnMed!);

  //         if (unMedbd == null) {
  //           await unMedidaRepo.insertUnidadeMedida(unMedApi);
  //         } else {
  //           unMedApi.id = unMedbd.id!;
  //           await unMedidaRepo.updateUnidadeMedida(unMedApi);
  //         }
  //       }
  //     }

  //     log.processado = "S";
  //     await logRepo.updateLogProduto(log);
  //   }
  // }
}
