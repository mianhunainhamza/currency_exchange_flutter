import 'package:currency_converter/screens/home_page.dart';
import 'package:currency_converter/screens/onBoard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home:const AuthChecker()
    );
  }
}
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  AuthCheckerState createState() => AuthCheckerState();
}

class AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && isLogin) {
      // User is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // User is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can show a loading indicator or splash screen here
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
