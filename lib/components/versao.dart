// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// class VersaoCom extends StatefulWidget {
//   const VersaoCom({super.key});

//   @override
//   State<VersaoCom> createState() => _VersaoComState();
// }

// class _VersaoComState extends State<VersaoCom> {
//   String? version;
//   String? appName;

//   Future<void> getVersion() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       version = packageInfo.version;
//       appName = packageInfo.appName;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getVersion();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       "V$version - $appName",
//       style: const TextStyle(
//           fontSize: 11,
//           fontFamily: 'Poppins',
//           color: Color.fromARGB(255, 255, 255, 255)),
//     );
//   }
// }
