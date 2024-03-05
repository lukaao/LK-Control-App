import "dart:convert";

import "package:lk/database/repository/aluguel-repository.dart";
import "package:lk/entity/aluguel.dart";
import "package:lk/reqs/interno.dart";

class SincronizarAluguel {
  AluguelRepository aluRepo = AluguelRepository();

  buscarAluguel() async {
    try {
      var response = await MyReqs().get("/aluguel/listar/");
      if (response.statusCode == 200) {
        List<Aluguel> alugueis =
            List<Map<String, dynamic>>.from(json.decode(response.body))
                .map((e) => Aluguel.fromJson(e))
                .toList();

        for (var aluguel in alugueis) {
          Aluguel? aluExiste = await aluRepo.getByCodAlu(aluguel.codAlu);

          if (aluExiste == null) {
            await aluRepo.insert(aluguel);
          } else {
            aluguel.id = aluExiste.id;
            await aluRepo.update(aluguel);
          }
        }
      } else if (response.statusCode != 404) {
        throw Exception("Erro ao buscar log de Aluguel ${response.body}");
      }
    } catch (e, stc) {
      print("Erro ao buscar Aluguels! $e");
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
