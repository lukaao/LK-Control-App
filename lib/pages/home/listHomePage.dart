import 'package:flutter/material.dart';
import 'package:lk/components/appbar.dart';
import 'package:lk/components/bottomNavigationbar.dart';

class ListHomePage extends StatefulWidget {
  const ListHomePage({super.key});

  @override
  State<ListHomePage> createState() => _ListHomePageState();
}

class _ListHomePageState extends State<ListHomePage> {
  Widget buildCard(String title, String summary, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: color,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                  child: Text(
                    summary,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//   Widget buildCard(String title, String summary, Color color) {
//   return Card(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10.0),
//     ),
//     elevation: 4, // Adiciona uma sombra ao card
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: color, // Cor da parte superior
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(10.0),
//               topRight: Radius.circular(10.0),
//             ),
//           ),
//           padding: EdgeInsets.all(8.0),
//           child: Text(
//             title,
//             style: TextStyle(
//               color: Colors.white, // Cor do título
//               fontSize: 17,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             summary,
//             style: TextStyle(fontSize: 14),
//           ),
//         ),
//       ],
//     ),
//   );
// }

  @override
  void initState() {
    super.initState();

    BottomNavigationController instance = BottomNavigationController.instance;
    instance.changeIndex(3);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: "Home"),
        body: Column(
          children: [
            buildCard("Meu Plano", "Resumo do plano aqui",
                Theme.of(context).primaryColorDark),
            buildCard("Cadastros", "Resumo dos cadastros aqui",
                Theme.of(context).primaryColorDark),
            buildCard("Suporte", "Resumo do suporte aqui",
                Theme.of(context).primaryColorDark),
            buildCard("Sobre", "Resumo sobre aqui",
                Theme.of(context).primaryColorDark),
          ],
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
