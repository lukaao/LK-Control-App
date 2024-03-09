import 'package:flutter/material.dart';
import 'package:lk/pages/dashboard/dashboardPage.dart';
import 'package:lk/pages/produto/produtoPage.dart';
import 'package:overlay_support/overlay_support.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'LK Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColorDark: Color.fromARGB(255, 54, 15, 102),
          primaryColorLight: Colors.white,
          useMaterial3: false,
          fontFamily: 'Poppins'),
      home: DashboardPage(),
    ));
  }
}
