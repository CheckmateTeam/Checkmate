import 'package:checkmate/pages/authentication/forgot.dart';
import 'package:checkmate/pages/authentication/signup.dart';
import 'package:checkmate/pages/tutorial/tutorial_page.dart';
import 'package:checkmate/provider/db.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPass = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //Google sign in
  Future googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential user = await _auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      final dbProvider = Provider.of<Database>(context, listen: false);
      // ignore: use_build_context_synchronously
      final taskprovider = Provider.of<CalendarModel>(context, listen: false);
      if (user.additionalUserInfo!.isNewUser) {
        dbProvider.addNewUser(user.user!.email!, user.user!.displayName!);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TutorialPage()),
        );
      } else {
        dbProvider.updateLogin();

        taskprovider.clearAll();
        taskprovider.fetchTask();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        print('The account already exists with a different credential.');
      } else if (e.code == 'invalid-credential') {
        print('Error occurred while accessing credentials. Try again.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                          'Sign In',
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Email",
                                    labelText: "Email",
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 20),
                              TextField(
                                  controller: passwordController,
                                  obscureText: showPass,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Password",
                                    labelText: "Password",
                                    prefixIcon: Icon(Icons.search),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showPass = !showPass;
                                          });
                                        },
                                        icon: showPass
                                            ? Icon(Icons.visibility)
                                            : Icon(Icons.visibility_off)),
                                  ),
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [],
                              ),
                            ],
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.6,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(241, 91, 91, 1))),
                            onPressed: () {
                              _auth
                                  .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text)
                                  .then((value) {
                                context.read<Database>().updateLogin();
                                context.read<CalendarModel>().clearAll();
                                context.read<CalendarModel>().fetchTask();
                              }).catchError((e) => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Login failed"),
                                            content: const Text(
                                                "Please check your email and password"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("OK"))
                                            ],
                                          )));
                            },
                            child: const Text('Sign in',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPage()));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 117, 117, 117),
                              fontSize: 14),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()));
                              },
                              child: const Text('Sign up'))
                        ],
                      ),
                      SignInButton(
                        Buttons.Google,
                        onPressed: () {
                          googleSignIn();
                        },
                      ),
                    ],
                  ),
                ),
              ))
            ]),
          ],
        )),
      ),
    );
  }
}
