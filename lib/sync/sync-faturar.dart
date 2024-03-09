import "dart:convert";

import "package:lk/database/repository/faturar-repository.dart";
import "package:lk/entity/faturar.dart";
import "package:lk/reqs/interno.dart";

class SincronizarFaturar {
  FaturarRepository fatRepo = FaturarRepository();

  buscarFaturar() async {
    try {
      var response = await MyReqs().get("/aluguel/listar/faturados");
      if (response.statusCode == 200) {
        List<Faturar> faturados =
            List<Map<String, dynamic>>.from(json.decode(response.body))
                .map((e) => Faturar.fromJson(e))
                .toList();

        for (var faturado in faturados) {
          Faturar? fatExiste = await fatRepo.getByCodFat(faturado.codFat);

          if (fatExiste == null) {
            await fatRepo.insert(faturado);
          } else {
            faturado.id = fatExiste.id;
            await fatRepo.update(faturado);
          }
        }
      } else if (response.statusCode != 404) {
        throw Exception("Erro ao buscar de Faturados ${response.body}");
      }
    } catch (e, stc) {
      print("Erro ao buscar Faturados! $e");
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
