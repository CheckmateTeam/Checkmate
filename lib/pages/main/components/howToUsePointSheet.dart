import 'package:flutter/material.dart';

class HowToUsePointSheet extends StatefulWidget {
  const HowToUsePointSheet({super.key});

  @override
  State<HowToUsePointSheet> createState() => _HowToUsePointSheetState();
}

class _HowToUsePointSheetState extends State<HowToUsePointSheet> {
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('How to use points.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text('Lerem ipsum', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    ]);
  }
}
