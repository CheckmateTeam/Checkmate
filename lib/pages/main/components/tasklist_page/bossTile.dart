import 'package:checkmate/pages/challenge/mainChallenge.dart';
import 'package:flutter/material.dart';

class BossTile extends StatelessWidget {
  const BossTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainChallenge()));
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(99, 158, 158, 158),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 2), // changes position of shadow
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Image(image: AssetImage("assets/boss/boss.png")),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Current boss",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text("Reaper",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                Text("250/300")
              ],
            ),
            IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.primaries[0]),
                  shape: MaterialStateProperty.all(const CircleBorder()),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainChallenge()));
                },
                icon: const Icon(Icons.arrow_forward_ios),
                color: Colors.white)
          ],
        ),
      ),
    );
  }
}
