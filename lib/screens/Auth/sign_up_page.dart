import 'package:currency_converter/screens/Auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool tickMark = false;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  bool obscureText = true;
  bool _isSigningUp = false; // Flag to track signup state

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var mediaQuerySize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SlideTransition(
          position: _offsetAnimation,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: mediaQuery.size.height * 0.01,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: mediaQuerySize.width * 0.10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: Text(
                        "Enter the correct details below",
                        style: TextStyle(
                          fontSize: mediaQuerySize.width * 0.03,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.width * 0.06),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: mediaQuery.size.width * 0.9,
                        child: SizedBox(
                          height: 90,
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              prefixIcon: const Icon(CupertinoIcons.person),
                              labelText: 'User Name',
                              labelStyle: TextStyle(
                                fontSize: mediaQuery.size.width * 0.04,
                                color: Colors.black,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.width * 0.04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: mediaQuery.size.width * 0.9,
                        child: SizedBox(
                          height: 90,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value!.trim().isEmpty ||
                                  !value.trim().contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontSize: mediaQuery.size.width * 0.04,
                                color: Colors.black,
                              ),
                              prefixIcon: const Icon(Icons.email_outlined),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.width * 0.04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: mediaQuery.size.width * 0.9,
                        child: SizedBox(
                          height: 90,
                          child: TextFormField(
                            controller: passController,
                            obscureText: obscureText,
                            validator: (value) {
                              if (value!.trim().length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: 'Password',
                              prefixIcon: const Icon(CupertinoIcons.lock),
                              labelStyle: TextStyle(
                                fontSize: mediaQuery.size.width * 0.04,
                                color: Colors.black,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(
                                  obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.width * 0.07),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                tickMark = !tickMark;
                              });
                            },
                            child: tickMark
                                ? const Icon(CupertinoIcons.check_mark)
                                : const Icon(CupertinoIcons.square,
                                color: CupertinoColors.inactiveGray),
                          ),
                          const Text(" I've read and agree to "),
                          const Text(
                            "Terms & Conditions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.width * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (!tickMark) {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text(
                                        "Agree to Terms and Conditions"),
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
                            } else {
                              // Call signup function
                              signUpUser(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passController.text.trim(),
                              );
                            }
                          }
                        },
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            height: mediaQuery.size.width * 0.15,
                            width: mediaQuery.size.width * 0.9,
                            child: _isSigningUp
                                ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: mediaQuerySize.width * 0.054,
                                      fontWeight: FontWeight.bold,
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to sign up the user
  void signUpUser(String accountName, String email, String password) async {
    setState(() {
      _isSigningUp = true;
    });

    try {
      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Save additional user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': accountName,
        });
        // Navigate to home page
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      print("Error signing up: $e");
      // Handle signup errors
      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred while signing up. Please try again.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isSigningUp = false;
      });
    }
  }
}
