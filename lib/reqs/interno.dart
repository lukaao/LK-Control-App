import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyReqs {
  String myUrl = "http://172.19.192.1:3000";

  get(String uri, {Map<String, dynamic>? body, required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String baseUrl = myUrl;
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      String strBody = json.encode(body!);
      var url = Uri.parse(baseUrl + uri);
      var response = await http.post(
        url,
        body: strBody,
        headers: headers,
      );
      return response;
    } catch (error) {
      throw Exception('Erro ao chamar API:${error.toString()}');
    }
  }

  post(String uri, {Map<String, dynamic>? body, required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String baseUrl = myUrl;
    try {
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      String strBody = json.encode(body!);
      var url = Uri.parse(baseUrl + uri);
      var response = await http.post(
        url,
        body: strBody,
        headers: headers,
      );
      return response;
    } catch (error) {
      throw Exception('Erro ao chamar API:${error.toString()}');
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
