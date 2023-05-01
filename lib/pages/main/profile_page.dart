import 'package:checkmate/provider/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<Database>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
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
                              Consumer<Database>(
                                builder: (context, db, child) => Text(
                                  db.userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 0.8,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Edit Name"),
                                          content: TextField(
                                            decoration: const InputDecoration(
                                              hintText: "Enter your name",
                                            ),
                                            controller: _nameController,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                context
                                                    .read<Database>()
                                                    .changeUsername(
                                                        _nameController.text);
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Username changed"),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            241, 91, 91, 1),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Save"),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: const Icon(
                                  Icons.edit_outlined,
                                  color: Color.fromARGB(255, 218, 110, 96),
                                ),
                              )
                            ],
                          ),
                          Consumer<Database>(
                            builder: (context, db, child) => Text(
                              db.userEmail,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Consumer<Database>(
                            builder: (context, db, child) => Text(
                              "Points: ${db.userPoints}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
                    Colors.black87, context, false, onTap: () {
                  print("Points shop");
                }),
                menuList("Sign out", Icons.logout, false,
                    Color.fromRGBO(241, 91, 91, 1), context, false, onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Sign out"),
                          content:
                              const Text("Are you sure you want to sign out?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                FirebaseAuth.instance.signOut();
                              },
                              child: const Text("Sign out"),
                            ),
                          ],
                        );
                      });
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
                      value: false,
                      onChanged: (value) {},
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
