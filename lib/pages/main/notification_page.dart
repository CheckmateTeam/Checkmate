import 'package:checkmate/Services/noti_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService noti = NotificationService();

  @override
  void initState() {
    NotificationService.initNotification();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 25,
              bottom: 5,
            ),
            child: Text(
              'Notification',
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
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Today",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(132, 0, 0, 0))),
                        Text("Mask as all read",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 0, 0))),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.6),
                      thickness: 1,
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(children: [
                        ElevatedButton(
                          child: const Text('Show notifications'),
                          onPressed: () {
                            // noti.scheduledNotification(
                            //     hour: 11, minutes: 27,id: 0);
                          },
                        ),

                        //Older from now on

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Older",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(132, 0, 0, 0))),
                          ],
                        ),

                        Divider(
                          color: Colors.grey.withOpacity(0.6),
                          thickness: 1,
                        ),
                      ])),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
