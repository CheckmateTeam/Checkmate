import 'package:checkmate/provider/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class shopItem extends StatefulWidget {
  final String itemName;
  final String? itemImage;
  final String? itemDescription;
  final String? itemFunction;
  final int? itemPrice;

  const shopItem(
      {super.key,
      required this.itemName,
      this.itemDescription,
      this.itemImage,
      this.itemFunction,
      this.itemPrice});
  @override
  State<shopItem> createState() => _shopItemState();
}

class _shopItemState extends State<shopItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //functional code here
        print("clicke");
      },
      child: Container(
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
    );
  }
}
