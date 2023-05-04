import 'package:flutter/material.dart';

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({super.key});

  @override
  State<ChangeTheme> createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Change Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            ThemeRadio(),
          ],
        ),
      ),
    ]);
  }
}

class ThemeRadio extends StatefulWidget {
  const ThemeRadio({super.key});
  @override
  State<ThemeRadio> createState() => _ThemeRadioState();
}

class _ThemeRadioState extends State<ThemeRadio> {
  int value = 1; //Current theme
  Widget customRadioButton(Color color1, Color color2, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = index;
        });
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: (value == index)
                ? const Color.fromARGB(124, 0, 0, 0)
                : const Color.fromARGB(50, 255, 255, 255),
          ),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              color1,
              color2,
            ],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        customRadioButton(Colors.yellow, Colors.red, 1),
        customRadioButton(const Color.fromARGB(255, 126, 6, 178),
            const Color.fromARGB(255, 255, 0, 132), 2),
        customRadioButton(Colors.green, Colors.yellow, 3),
        customRadioButton(
            Colors.blue, const Color.fromARGB(255, 174, 228, 252), 4)
      ],
    );
  }
}
