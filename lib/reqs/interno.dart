import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyReqs {
  String myUrl = "http://172.19.192.1:3000";

  // _validarSessao(int statusCode) {
  //   if (statusCode == 401) {
  //     throw UnauthorizedExcetion();
  //   }
  // }

  Future<Response> get(uri) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("TOKEN");
      var headers = {"Authorization": "Bearer $token"};
      var url = Uri.parse(myUrl + uri);
      var response = await http.get(
        url,
        headers: headers,
      );
      // _validarSessao(response.statusCode);

      return response;
    } catch (error) {
      // if (error is UnauthorizedExcetion) {
      //   rethrow;
      // }
      throw Exception("Erro ao chamar API:${error.toString()}");
    }
  }

  Future<Response> post(String uri, {Map<String, dynamic>? body}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };

      String? bodyStr;
      if (body != null) {
        bodyStr = json.encode(body);
      }
      var url = Uri.parse(myUrl + uri);
      var response = await http.post(
        url,
        body: bodyStr,
        headers: headers,
      );

      // _validarSessao(response.statusCode);

      return response;
    } catch (error) {
      throw Exception("Erro ao chamar API:${error.toString()}");
    }
  }

  Future<Response> patch(String uri, {Map<String, dynamic>? body}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("token");
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      var url = Uri.parse(myUrl + uri);
      var response = await http.patch(
        url,
        body: json.encode(body!),
        headers: headers,
      );

      // _validarSessao(response.statusCode);

      return response;
    } catch (error) {
      // if (error is UnauthorizedExcetion) {
      //   rethrow;
      // }
      throw Exception("Erro ao chamar API:${error.toString()}");
    }
  }

  login(String usuario, String senha) async {
    Map<String, dynamic> body = {
      "USUARIO": usuario,
      "SENHA": senha,
    };
    var myResponse = await http.post(
      Uri.parse("$myUrl/auth/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(body),
    );

    if (myResponse.statusCode == 201) {
      Map<String, dynamic> response = json.decode(myResponse.body);
      return response;
    } else {
      throw Exception("Usuário ou senha invalido.");
    }
  }
}
