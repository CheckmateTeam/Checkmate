import 'package:checkmate/main.dart';
import 'package:checkmate/provider/db.dart';
import 'package:checkmate/provider/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'point_shop_page.dart';

import 'components/changeTheme.dart';
import 'components/howToUsePointSheet.dart';

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
                                                  SnackBar(
                                                    content: Text(
                                                        "Username changed"),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
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
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Theme.of(context).primaryColor,
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
                    Theme.of(context).secondaryHeaderColor, context, false, onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PointShopPage()));
                }),
                menuList(
                    "How to points can be use?",
                    Icons.question_mark_rounded,
                    false,
                    Theme.of(context).secondaryHeaderColor,
                    context,
                    false, onTap: () {
                  showModalBottomSheet<dynamic>(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const HowToUsePointSheet());
                }),
                menuList("Change theme", Icons.edit_outlined, false,
                    Theme.of(context).secondaryHeaderColor, context, false, onTap: () {
                  showModalBottomSheet<dynamic>(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const ChangeTheme());
                }),
                menuList("Dark mode", Icons.dark_mode_outlined, true,
                    Theme.of(context).secondaryHeaderColor, context, false,
                    onTap: () {}),
                menuList("Sign out", Icons.logout, false,
                    Theme.of(context).primaryColor, context, false, onTap: () {
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
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainApp()));
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
                      value: context.watch<ThemeProvider>().isDark,
                      onChanged: (value) {
                        context.read<ThemeProvider>().setIsDark(value);
                      },
                      inactiveTrackColor: Color.fromARGB(255, 255, 255, 255),
                      activeTrackColor: Theme.of(context).primaryColor,
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
