import 'package:checkmate/main.dart';
import 'package:checkmate/pages/authentication/signin.dart';
import 'package:checkmate/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Stack(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 1.9,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color.fromRGBO(241, 91, 91, 1),
                      Color.fromRGBO(241, 146, 91, 1),
                    ],
                  )),
            ),
            Positioned(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      const Image(
                        width: 150,
                        height: 150,
                        image: AssetImage('assets/images/logo_w.png'),
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.8,
                width: MediaQuery.of(context).size.width / 1.1,
                margin: const EdgeInsets.only(
                  top: 250,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                              .hasMatch(value)) {
                                        return 'Please enter correct email';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Email",
                                      labelText: "Email",
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    style: const TextStyle(fontSize: 10)),
                                const SizedBox(height: 10),
                                TextFormField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Password",
                                      labelText: "Password",
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                    style: const TextStyle(fontSize: 10)),
                                const SizedBox(height: 10),
                                TextFormField(
                                    controller: confirmPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Confirm Password",
                                      labelText: "Confirm Password",
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                    style: const TextStyle(fontSize: 10))
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(241, 91, 91, 1))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (passwordController.text ==
                                  confirmPasswordController.text) {
                                _auth
                                    .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text)
                                    .then((value) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Hooraay!'),
                                          content: const Text(
                                              'Your account has been created'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MainApp()),
                                                      (route) => false);
                                                },
                                                child:
                                                    const Text('Go to login'))
                                          ],
                                        );
                                      });
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Error occured')));
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Password does not match')));
                              }
                            }
                          },
                          child: const Text('Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Sign in'))
                      ],
                    ),
                  ],
                ),
              ),
            ))
          ]),
        ],
      )),
    );
  }
}
