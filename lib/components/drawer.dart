import 'package:flutter/material.dart';
import 'package:lk/pages/login/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName = "";
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("USUARIO");
    prefs.remove("SENHA");

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  _buscarUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("USUARIO") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _buscarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: DrawerHeader(
              child: Image.asset('assets/images/LKpreto.png'),
            ),
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(20),
                color: Theme.of(context).primaryColorDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Olá, $userName",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          onPressed: logout,
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.white,
                            ),
                          ),
                          label: const Text(
                            "Sair",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )
                      ],
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
