import "dart:convert";
import "package:lk/database/repository/categoria-repository.dart";
import "package:lk/entity/categoria.dart";
import "package:lk/reqs/interno.dart";

class SincronizarCategoria {
  CategoriaRepository catRepo = CategoriaRepository();

  buscarCategoria() async {
    try {
      var response = await MyReqs().get("/produto/listar/categoria/");
      if (response.statusCode == 200) {
        List<Categoria> categorias =
            List<Map<String, dynamic>>.from(json.decode(response.body))
                .map((e) => Categoria.fromJson(e))
                .toList();

        for (var categoria in categorias) {
          Categoria? catexiste = await catRepo.getByCodCat(categoria.codCat);

          if (catexiste == null) {
            await catRepo.insert(categoria);
          } else {
            categoria.id = catexiste.id;
            await catRepo.update(categoria);
          }
        }
      } else if (response.statusCode != 404) {
        throw Exception("Erro ao buscar log de Categoria ${response.body}");
      }
    } catch (e, stc) {
      print("Erro ao buscar Categorias! $e");
      print(stc);
    }
  }

  // processarLogCategoria() async {
  //   List<LogCategoria> logNaoProcessados =
  //       await logRepo.getLogCategoriaNaoProcessado();
  //   for (LogCategoria log in logNaoProcessados) {
  //     if (log.Categoria != null) {
  //       Map<String, dynamic> responseMap = json.decode(log.Categoria!);

  //       Categoria proApi = Categoria.fromJson(responseMap);
  //       Categoria? probd = await prodRepo.getCategoriaByCodProd(proApi.codprod!);

  //       if (probd == null) {
  //         await prodRepo.insertCategoria(proApi);
  //       } else {
  //         proApi.id = probd.id;
  //         await prodRepo.updateCategoria(proApi);
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
  //     await logRepo.updateLogCategoria(log);
  //   }
  // }
}
