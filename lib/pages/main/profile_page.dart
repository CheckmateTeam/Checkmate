import 'package:checkmate/provider/db.dart';
import 'package:checkmate/provider/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<Database>(context).userEmail;
    final userName = Provider.of<Database>(context).userName;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            top: 25,
            bottom: 5,
          ),
          child: Text(
            'Profile',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/images/avatar_01.png'),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("Edit");
                                },
                                child: const Icon(
                                  Icons.edit_outlined,
                                  color: Color.fromARGB(255, 218, 110, 96),
                                ),
                              )
                            ],
                          ),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            "Poinst: 525 points",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                menuList("Points shop", Icons.shopping_bag_outlined, false,
                    Colors.black87, context, false, onTap: () {
                  print("Points shop");
                }),
                menuList(
                    "How to points can be use?",
                    Icons.question_mark_rounded,
                    false,
                    Colors.black87,
                    context,
                    false, onTap: () {
                  print("Points shop");
                }),
                menuList("Change theme", Icons.edit_outlined, false,
                    Colors.black87, context, false, onTap: () {
                  print("Points shop");
                }),
                menuList("Dark mode", Icons.dark_mode_outlined, true,
                    Colors.black87, context, isDark, onTap: () {
                  print("Points shop");
                }),
                menuList("Sign out", Icons.logout, false,
                    Color.fromRGBO(241, 91, 91, 1), context, false, onTap: () {
                  FirebaseAuth.instance.signOut();
                }),
              ],
            ),
          ),
        ),
        // ElevatedButton(
        //     onPressed: () async {
        //       await FirebaseAuth.instance.signOut();
        //     },
        //     child: const Text('Sign out'))
      ],
    );
  }
}

Widget menuList(String title, IconData icon, bool isToggle, Color fontColor,
    BuildContext context, bool isDark,
    {Function()? onTap}) {
  bool isDark = Provider.of<ThemeProvider>(context).isDark;
  if (isToggle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: InkWell(
        splashColor: Colors.grey,
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: fontColor,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 15,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: fontColor,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                      value: isDark,
                      onChanged: (value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      },
                      inactiveTrackColor: Color.fromARGB(255, 255, 255, 255),
                      activeTrackColor: Color.fromARGB(255, 218, 110, 96),
                      activeColor: Color.fromARGB(255, 255, 255, 255)),
                ],
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 194, 193, 193),
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: InkWell(
        splashColor: Colors.grey,
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: fontColor,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 15,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: fontColor,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 194, 193, 193),
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
