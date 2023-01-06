import 'package:authentication/screens/homeScreen.dart';
import 'package:authentication/screens/login_screen.dart';
import 'package:authentication/screens/secret_screen.dart';
import 'package:authentication/shared_preferences/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData(
          colorScheme: const ColorScheme.dark(
              primary: Colors.black54, onPrimary: Colors.white)),
      routes: {
        HomeScreen.routeName1: (context) => const LoginScreen(),
        HomeScreen.routeName2: (context) => const Secrets(),
        Secrets.routeName: (context) => const HomeScreen(),
        LoginScreen.routeName: (context) => const Secrets(),
      },
    );
  }
}
