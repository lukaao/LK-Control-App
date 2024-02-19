import 'package:flutter/material.dart';
import 'package:lk/pages/login/loginPage.dart';
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
          primaryColorDark: Colors.purple[900],
          primaryColorLight: Colors.white,
          useMaterial3: false,
          fontFamily: 'Poppins'),
      home: LoginPage(),
    ));
  }
}
