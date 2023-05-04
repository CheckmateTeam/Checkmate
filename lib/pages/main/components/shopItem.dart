import 'package:checkmate/provider/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class shopItem extends StatefulWidget {
  final String itemName;
  final String? itemImage;
  final String? itemDescription;

  const shopItem(
      {super.key,
      required this.itemName,
      this.itemDescription,
      this.itemImage});
  @override
  State<shopItem> createState() => _shopItemState();
}

class _shopItemState extends State<shopItem> {
  // void handleOnPress() {
  //   Container(decoration: BoxDecoration(boxShadow: ),)
  // }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
    // onTap: handleOnPress,  
    child:  Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 87, 87, 87)),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
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
                ],
              ),
            ])))
            
            );
  }
}
