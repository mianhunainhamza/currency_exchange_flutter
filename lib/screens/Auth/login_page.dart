import 'package:currency_converter/screens/Auth/sign_up_page.dart';
import 'package:currency_converter/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_pass_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _obscureText = true;
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;
  late GlobalKey<FormState> _formKey;
  bool _isLoggingIn = false; // Flag to track login state

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    offsetAnimation = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(
        parent: animationController, curve: Curves.elasticOut));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SlideTransition(
        position: offsetAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Row(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Please sign in to continue',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: mediaQuerySize.width * 0.88,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 90,
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Invalid email address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                                prefixIcon: const Icon(Icons.email),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  fontSize: mediaQuerySize.width * 0.04,
                                  color: Colors.black.withOpacity(.5),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: mediaQuerySize.width * 0.05),
                          SizedBox(
                            height: 90,
                            child: TextFormField(
                              controller: passController,
                              obscureText: _obscureText,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                                prefixIcon: const Icon(Icons.lock),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontSize: mediaQuerySize.width * 0.04,
                                  color: Colors.black.withOpacity(.5),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (c) => const ForgotPass()));
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mediaQuerySize.width * 0.1,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          _isLoggingIn = true;
                        });
                        loginUser(context, emailController, passController)
                            .then((_) {
                          setState(() {
                            _isLoggingIn = false;
                          });
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      height: mediaQuerySize.width * 0.15,
                      width: mediaQuerySize.width * 0.84,
                      child: _isLoggingIn
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "L O G I N",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: mediaQuerySize.width * 0.054,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: mediaQuerySize.width * 0.08,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mediaQuerySize.width * 0.14),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: mediaQuerySize.width - 100,
                      child: const Row(children: [
                        Flexible(
                          child: Divider(),
                        ),
                        Text(
                          "   OR   ",
                          style: TextStyle(),
                        ),
                        Flexible(
                          child: Divider(),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(height: mediaQuerySize.width * 0.1),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to log in the user
  Future<void> loginUser(BuildContext context, TextEditingController emailController,
      TextEditingController passController) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      User? userData = userCredential.user;

      if (!context.mounted) return;

      if (userData != null) {
        if (userData.emailVerified) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLogin', true);
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => HomePage()),
                (route) => false,
          );
        } else {
          await userData.sendEmailVerification();
          await showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('A verification email has been sent to your account'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An undefined error occurred";
      if (e.code == 'user-disabled') {
        errorMessage = 'User has been disabled';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many unsuccessful login attempts. Please try again later.';
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        errorMessage = 'Invalid email or password';
      } else {
        print('here is error');
        print(e);
        errorMessage = 'Invalid email or password';
      }
      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(errorMessage),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

}
