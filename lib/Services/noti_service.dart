import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  String message = "No message.";

 

  

  static Future<void> initNotification() async {
    _configureLocalTimeZone();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    
  }

  tz.TZDateTime _convertTime(int month, int day,int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      month,
      day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }


  List<String> dropdownItems = [
    'Never',
    '5 mins before deadline',
    '10 mins before deadline',
    '15 mins before deadline',
    '30 mins before deadline',
    '1 hour before deadline',
    '2 hours before deadline',
    '1 day before deadline',
    '2 days before deadline',
    '1 week before deadline'
  ];

  scheduledNotification({
    required String title,
    required String body,
    required int month,
    required int day,
    required int hour,
    required int minutes,
    required int id,
    required String deadline
    
  }) async {


    int x = dropdownItems.indexOf(deadline);

    if(x == 0){}
    else if(x == 1){minutes -= 5;}
    else if(x == 2){minutes -= 10;}
    else if(x == 3){minutes -= 15;}
    else if(x == 4){minutes -= 30;}
    else if(x == 5){hour -= 1;}
    else if(x == 6){hour -= 2;}
    else if(x == 7){day -= 1;}
    else if(x == 8){day -= 2;}
    else if(x == 9){day -= 7;}

    if(minutes < 0){
      minutes += 60;
      hour -= 1;
    }

    if(hour < 0){
      hour += 24;
      day -= 1;
    }

    if(day <= 0){
      if(month == 2 || month == 4 || month == 6 || month == 8 || month == 9 || month == 11 || month == 1){
        day += 31;
        month -= 1;
      }
      else if(month == 5 || month == 7 || month == 10 || month == 12){
        day += 30;
        month -= 1;
      }
      else{
        day += 28;
        month -= 1;
      }



  
    


    await FlutterLocalNotificationsPlugin().zonedSchedule(
      
      id,
      title,
      body,
      _convertTime(month,day,hour, minutes),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'
        ),
      
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'It could be anything you pass',
    );
    
    
  }


  
  

  cancelAll() async => await FlutterLocalNotificationsPlugin().cancelAll();
  cancel(id) async => await FlutterLocalNotificationsPlugin().cancel(id);

}









}






