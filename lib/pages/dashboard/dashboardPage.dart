import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lk/components/appbar.dart';
import 'package:lk/components/bottomNavigationbar.dart';
import 'package:lk/components/topNavbar.dart';
import 'package:lk/database/repository/faturar-repository.dart';
import 'package:lk/entity/faturar.dart';
import 'package:lk/helpers/formaters.dart';
import 'package:lk/sync/sync-faturar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  FaturarRepository fatRepo = FaturarRepository();

  double saida = 100;
  double entrada = 10;

  _sincronizar() async {
    await SincronizarFaturar().buscarFaturar();
    List<Faturar> faturados = await fatRepo.get();
    if (mounted) {
      saida = 0;
      entrada = 0;
      for (var faturado in faturados) {
        setState(() {
          saida += faturado.custo;
          entrada += faturado.precoFinal;
        });
      }

      if (entrada == 0 && saida == 0) {
        entrada = 1;
        saida == 0;
      }
    }
  }

  List<String> items = [
    "Dia",
    "Semana",
    "Mês",
  ];

  /// List of body icon
  List<IconData> icons = [
    Icons.calendar_today,
    Icons.calendar_today,
    Icons.calendar_today,
  ];
  int current = 0;
  PageController pageController = PageController();

  int touchedIndex = -1;
  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 90.0 : 70.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Theme.of(context).primaryColorDark,
            value: entrada,
            title: formatarReal(entrada),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.black,
            // color: Colors.red,
            value: saida,
            title: formatarReal(saida),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _sincronizar();
    BottomNavigationController instance = BottomNavigationController.instance;
    instance.changeIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'Dashboard'),
        body: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 80,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centraliza os itens
                children: List.generate(items.length, (index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            current = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.all(5),
                          width: 100,
                          height: 55,
                          decoration: BoxDecoration(
                            color: current == index
                                ? Colors.white70
                                : Colors.white54,
                            borderRadius: current == index
                                ? BorderRadius.circular(6)
                                : BorderRadius.circular(3),
                            border: current == index
                                ? Border.all(
                                    color: Theme.of(context).primaryColorDark,
                                    width: 2.5)
                                : null,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icons[index],
                                  size: current == index ? 23 : 20,
                                  color: current == index
                                      ? Colors.black
                                      : Colors.grey.shade500,
                                ),
                                Text(
                                  items[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      swapAnimationDuration: Duration(milliseconds: 1000),
                      swapAnimationCurve: Curves.easeInOutQuint,
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 75,
                        sections: showingSections(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Entrada",
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Saída",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 100),
          ],
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
