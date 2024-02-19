import 'package:flutter/material.dart';
import 'package:lk/components/buttom.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading = false;

  FocusNode myFocusNodeUsuario = FocusNode();
  FocusNode myFocusNodeSenha = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColorDark,
            body: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    // padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Image.asset("assets/images/LKbranco.png"),
                  ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  Container(
                    child: Text("Bem vindo(a)!",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      focusNode: myFocusNodeUsuario,
                      onFieldSubmitted: (value) {
                        myFocusNodeUsuario.unfocus();
                        myFocusNodeSenha.requestFocus();
                      },
                      controller: _usuarioController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        label: Text(
                          "Usuário",
                          style: TextStyle(color: Colors.white),
                        ),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      focusNode: myFocusNodeSenha,
                      onFieldSubmitted: (value) {
                        myFocusNodeSenha.unfocus();
                      },
                      controller: _senhaController,
                      keyboardType: TextInputType.text,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        label: Text(
                          "Senha",
                          style: TextStyle(color: Colors.white),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 90),
                  Container(
                    child: MyButtom(
                        height: 40,
                        width: 150,
                        label: "Avançar",
                        onPressed: () {}),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("Esqueci a senha",
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ]),
              ),
            )));
  }
}
