import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'Auth/forgot_pass_page.dart';
import 'Auth/login_page.dart';
import 'Auth/sign_up_page.dart';

class OnBoardPage extends StatelessWidget {
  const OnBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 130,
          ),
          SizedBox(
              width: size.width,
              height: size.height * .36,
              child: Lottie.asset('assets/start.json')),
          Text('All Currency\n Support',style: GoogleFonts.libreBaskerville(fontSize:size.height * .042,fontWeight:FontWeight.w300),textAlign: TextAlign.center,),
          const SizedBox(
            height: 40,
          ),
          Text('Check 75% of the currency support \ncompared to other platforms',style: GoogleFonts.raleway(fontSize:size.height * .017),textAlign: TextAlign.center,),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0, left: 20, right: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'L O G I N',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SignupPage(),
                  ),
                );
              },
              child: const Text(
                'Create an Account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * .09,),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const ForgotPass(),
                  ),
                );
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
