import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sondar/login_page.dart';
import 'package:sondar/location_page.dart';
import 'package:sondar/manual_location_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Networking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // Define named routes
      initialRoute: '/location',
      routes: {
        '/location': (context) => const LocationPage(),
        '/manual-location': (context) => const ManualLocationPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
