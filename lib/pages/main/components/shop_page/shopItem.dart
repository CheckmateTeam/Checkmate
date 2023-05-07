import 'package:checkmate/provider/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class shopItem extends StatefulWidget {
  final String itemName;
  final String? itemImage;
  final String? itemDescription;
  final int? itemPrice;
  final int currentPoint;

  const shopItem(
      {super.key,
      required this.itemName,
      this.itemDescription,
      this.itemImage,
      this.itemPrice, required this.currentPoint,});
  @override
  State<shopItem> createState() => _shopItemState();
}

class _shopItemState extends State<shopItem> {
  int _currentPoint = 0;

  @override
  void initState() {
    super.initState();
    _currentPoint = int.parse(context.read<Database>().userPoints);
    // ((event) {
    //   var dataSnapshot = event.snapshot;
    //   setState(() {
    //     _currentPoint = dataSnapshot.value ?? 0;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        //point transaction
        // _currentPoint = int.parse(context.watch<Database>().userPoints);
        if (widget.itemPrice != null && _currentPoint >= widget.itemPrice!) {
          context.read<Database>().buyItem(widget.itemPrice!);
          print(_currentPoint);
          _currentPoint = _currentPoint - widget.itemPrice!;
          print(widget.itemName);
          print(widget.itemPrice);
          print(_currentPoint);
          setState(() {});
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
                              TextSpan(text: "You have purchased"),
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
                              Navigator.of(context).pop(widget.itemPrice);
                            },
                            child: const Text("OK"))
                      ]);
                });
          }
        } else{
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
          if (_currentPoint < widget.itemPrice! && widget.itemPrice != null)
            Container(
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
            ),
        ],
      ),
    );
  }
}
