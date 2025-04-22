import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import generated options

// Import your page widgets and the new AuthCheckScreen
import 'package:sondar/login_page.dart';
import 'package:sondar/location_page.dart';
import 'package:sondar/manual_location_page.dart';
import 'package:sondar/otp_page.dart';

void main() async {
  // Make main async
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Use generated options
    );
  } catch (e) {
    // Handle initialization error (e.g., show an error message or log)
    print('Failed to initialize Firebase: $e');
    // Optionally, you could display an error screen here instead of runApp
  }

  // Run the app
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

      initialRoute: '/login',
      // Define named routes
      routes: {
        '/location': (context) => const LocationPage(),
        '/manual-location': (context) => const ManualLocationPage(),
        '/login': (context) => const LoginPage(),
        '/otp-page': (context) => const OtpPage(),
      },
    );
  }
}
