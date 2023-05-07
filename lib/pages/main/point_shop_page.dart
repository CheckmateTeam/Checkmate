import 'package:checkmate/provider/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/shop_page/shopItem.dart';

class PointShopPage extends StatefulWidget {
  const PointShopPage({Key? key}) : super(key: key);

  @override
  _PointShopPageState createState() => _PointShopPageState();
}

class _PointShopPageState extends State<PointShopPage> {
  int _pointController = 0;
  

  @override
  void initState() {
    super.initState();
    Provider.of<Database>(context, listen: false).init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    int currentPoint = int.parse(context.watch<Database>().userPoints);
    _pointController = currentPoint;

    return Scaffold(
        body: Column(children: [
      const Padding(
        padding: EdgeInsets.only(
          top: 40,
          bottom: 5,
        ),
        child: Text(
          'Points Shop',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Consumer<Database>(
        builder: (context, db, child) => Text(
          db.userName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
          textScaleFactor: 0.8,
        ),
      ),
      Consumer<Database>(
          builder: (context, db, child) {
            final currentPoint = int.parse(db.userPoints);
            _pointController = currentPoint;
            return Text(
              "Current Points: $_pointController",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            );
          },
        ),
      const Padding(
        padding: EdgeInsets.only(
          bottom: 10,
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListView(children: [
          //start here
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("App Fetures"),
                const Divider(),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: <Widget>[
                    shopItem(
                        itemName: "Random New Theme",
                        itemDescription: "Theme for you",
                        itemImage: "assets/items/gacha.png",
                        itemPrice: 2000,
                        currentPoint: _pointController,),
                    shopItem(
                        itemName: "Cycle feature",
                        itemDescription: "Theme for you",
                        itemImage: "assets/items/cycleTask.png",
                        itemPrice: 100,
                        currentPoint: _pointController,),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                const Text("Challenge Upgrade"),
                const Divider(),
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: <Widget>[
                    shopItem(
                      itemName: "Hit Harder",
                      itemDescription: "Hit harder in challenges",
                      itemImage: "assets/items/atkUp.png",
                      itemPrice: 500,
                      currentPoint: _pointController,
                    ),
                    shopItem(
                      itemName: "Za Warudo",
                      itemDescription: "Add time in challenges",
                      itemImage: "assets/items/addTime.png",
                      itemPrice: 800,
                      currentPoint: _pointController,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            //Return button
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(170, 40)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.redAccent)),
                onPressed: () {
                  // ignore: avoid_print
                  Navigator.pop(context);
                },
                child: const Text("Return",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
          )
        ]),
      ))
    ]));
  }
}

// Future<void> _pointUse(BuildContext context) async {
//     final currentPoint = await Navigator.push(
//       context,

//       ,
//     );
//   }