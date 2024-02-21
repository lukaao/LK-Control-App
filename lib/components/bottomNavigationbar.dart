import "package:flutter/material.dart";
import "package:lk/pages/login/loginPage.dart";
import "package:lk/pages/produto/produtoPage.dart";

class BottomNavigation extends StatelessWidget {
  final List<Widget?> _routes = [
    ProdutosPage(),
    ProdutosPage(),
    ProdutosPage(),
    ProdutosPage()
  ];

  BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: _buildBottomNavigationBarItems(),
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Colors.grey,
        currentIndex: BottomNavigationController.instance.index,
        onTap: (value) {
          if (value <= 3) {
            BottomNavigationController.instance.changeIndex(value);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => _routes[value]!),
            );
          } else {
            Scaffold.of(context).openDrawer();
          }
        },
        selectedLabelStyle: const TextStyle(fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.widgets),
        label: "Inicio",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.local_shipping),
        label: "Produto",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.paste),
        label: "Aluguel",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.attach_money),
        label: "Faturado",
      ),
    ].asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return _buildBottomNavigationBarItem(index, item.label!);
    }).toList();
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      int index, String label) {
    return BottomNavigationBarItem(
      icon: _getIconForIndex(index),
      label: label,
    );
  }

  Widget _getIconForIndex(int index) {
    final isSelected = index == BottomNavigationController.instance.index;
    return Column(
      children: [
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            width: 30,
            height: 1.5,
            //color: Theme.of(context).primaryColor,
            color: const Color(0xFF2E3092),
          ),
        Icon(
          _getIconDataForIndex(index),
          size: 35,
        ),
      ],
    );
  }

  IconData _getIconDataForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.widgets;
      case 1:
        return Icons.local_shipping;
      case 2:
        return Icons.content_paste_go_sharp;
      case 3:
        return Icons.attach_money;
      default:
        return Icons.home;
    }
  }
}

class BottomNavigationController {
  static final BottomNavigationController instance =
      BottomNavigationController();

  int index = 0;
  void changeIndex(int newIndex) {
    index = newIndex;
  }
}
