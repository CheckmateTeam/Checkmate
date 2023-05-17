import 'package:checkmate/Services/noti_service.dart';
import 'package:checkmate/model/taskModel.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService noti = NotificationService();
  late Future<String> _myFuture;

  @override
  void initState() {
    super.initState();
    NotificationService.initNotification();
    _myFuture =
        Provider.of<CalendarModel>(context, listen: false).fetchNotiTask();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<CalendarModel>();

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
                  color:  Colors.grey.withOpacity(0.2),
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
              child: Column(
                children: [
                  SizedBox(height: 20.0), 
                  Expanded(child:
                  Container(
                    child:ListView(
                  padding:
                      const EdgeInsets.all(20.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Text("Today",
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).secondaryHeaderColor)),


                        TextButton(
                          onPressed: () {data.updateAllRead(data);},
                          child: Text("Mark as all read",
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor))),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.6),
                      thickness: 1,
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.todayNoti.length,
                              itemBuilder: (context, index) {
                                return notiList(data.todayNoti[index], data);
                            }),

                      const SizedBox(height: 20.0),


                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text("Older",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(132, 0, 0, 0),
                                ))
                      ]),


                      Divider(
                        color: Colors.grey.withOpacity(0.6),
                        thickness: 1,
                      ),


                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.olderNoti.length,
                          itemBuilder: (context, index) {
                            return notiList(data.olderNoti[index] , data);
                      }),
                    ]))
                  ]),
                  )
              )
                  ]
                  )
            ),
          ),
        ],
      ),
    );
  }



















  Widget notiList(Task task , CalendarModel data) {
    return Expanded(
      child: InkWell(
        onTap: (){
          data.updateReadTask(task);
        },

        child: Container(
          padding: const EdgeInsets.symmetric(
          vertical: 20.0),
          decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: task.isRead ? Color.fromARGB(0, 158, 158, 158) : Color.fromARGB(99, 158, 158, 158),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0,0), // changes position of shadow
            )
          ],
          borderRadius:BorderRadius.circular(10)),
          margin: const EdgeInsets.only( top: 15.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 14.0,),
            child: Row(
              crossAxisAlignment:CrossAxisAlignment.center,
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(task.taskName,
                        style: TextStyle(
                        fontSize: 20,
                        color: task.isRead ? Colors.grey : Theme.of(context).secondaryHeaderColor,
                        fontWeight:FontWeight.w700)),
                        
                        
                        Text(task.taskDesc,
                        style: TextStyle(
                        fontSize: 16,
                        color: task.isRead ? Colors.grey : Theme.of(context).secondaryHeaderColor,
                        ))
                      ],
                    ),
                  ],
                ),
                Checkbox(
                  value: !task.isRead,
                  checkColor: Theme.of(context).primaryColor,
                  activeColor: Theme.of(context).primaryColor,
                  side: BorderSide(width: 2,color: Colors.grey),
                  onChanged: (bool? value) {
                    data.updateReadTask(task);
                  },
                )
              ],
            ),
          ),
        ),
      ));
  }
}
