import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class NotificationService {

  String message = "No message.";

  

  static Future<void> initNotification() async {
    
    final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('checkmate.png');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification:
            (
              int id, String? title, String? body,
              String? payload
            ) async 
        {print("onDidReceiveLocalNotification called.");}
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
      
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
      
      print("onSelectNotification called.");
      
    });

  }

  sendNotification({required String body, required String title}) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channelId', 
        'channelName',
        importance: Importance.max, 
        priority: Priority.high
    );

        
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();


    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, 
        iOS:iOSPlatformChannelSpecifics);

    await notificationsPlugin.show(111, 'Hello, benznest.',
        'This is a your notifications. ', platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }
}
