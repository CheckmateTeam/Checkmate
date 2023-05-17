import 'package:checkmate/provider/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class shopItem extends StatefulWidget {
  final String itemName;
  final String? itemImage;
  final String? itemDescription;
  final int? itemPrice;
  final int currentPoint;

  const shopItem({
    super.key,
    required this.itemName,
    this.itemDescription,
    this.itemImage,
    this.itemPrice,
    required this.currentPoint,
  });
  @override
  State<shopItem> createState() => _shopItemState();
}

// ignore: camel_case_types
class _shopItemState extends State<shopItem> {
  int _currentPoint = 0;
  late ValueNotifier<int> _currentPointNotifier;
  @override
  void initState() {
    super.initState();

    final db = Provider.of<Database>(context, listen: false);
    _currentPoint = int.parse(db.userPoints);
    _currentPointNotifier = ValueNotifier<int>(_currentPoint);
  }

  void UpgradeUserDamage() async {
    int currentDamage = 0;
    final userCollection = FirebaseFirestore.instance.collection('user_info');
    final querySnapshot = await userCollection
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    querySnapshot.docs.forEach((doc) async {
      currentDamage = doc.data()['UserDamage'] ?? 0;

      int newDamage = currentDamage + 100;
      await doc.reference.update({'UserDamage': newDamage});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final db = Provider.of<Database>(context, listen: false);
        if (widget.itemPrice != null && _currentPoint >= widget.itemPrice!) {
          db.buyItem(widget.itemPrice!);
          _currentPoint -= widget.itemPrice!;
          _currentPointNotifier.value = _currentPoint;
          if (widget.itemName == "Random New Theme") {
            // only for random theme
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text("You have got"),
                      content: Column(
                        children: [
                          CircleAvatar(
                              radius: 150,
                              child: Image.asset(
                                "assets/theme/Ogtheme.png",
                              )),
                          const Text(
                            "\n OG Theme",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ), //Theme name and color

                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(widget.itemPrice);
                            },
                            child: const Text("OK"))
                      ]);
                });
          } else {
            // other items
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text("Item Purchased!"),
                      content: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16, height: 1.5),
                            children: <TextSpan>[
                              const TextSpan(text: "You have purchased"),
                              TextSpan(
                                  text: "\n ${widget.itemName} ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: "\n for ${widget.itemPrice} points!"),
                            ]),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              UpgradeUserDamage();
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ]);
                });
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text("Not enough points!"),
                    content: const Text(
                        "You do not have enough points to purchase this item!"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(widget.itemPrice);
                          },
                          child: const Text("OK"))
                    ]);
              });
        }
      },
      child: Stack(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 197, 197, 197)),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    widget.itemImage ?? "assets/items/comingsoon.png",
                    height: 50,
                    width: 50,
                  ),
                ),
                Text(
                  widget.itemName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (widget.itemPrice != null)
                  Text(
                    "${widget.itemPrice} Points",
                  ),
              ],
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: _currentPointNotifier,
            builder: (context, value, child) {
              if (widget.itemPrice != null && value < widget.itemPrice!) {
                return Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 100,
                  ),
                );
              } else {
                return const SizedBox(); // Empty container when the condition is not met
              }
            },
          ),
        ],
      ),
    );
  }
}
