import 'package:checkmate/Services/noti_service.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                                color: Color.fromARGB(255, 255, 0, 0))
                                ),
                      ],
                    ),




                    Divider(
                      color: Colors.grey.withOpacity(0.6),
                      thickness: 1,
                    ),
                    
                    
                    
                    
                    
                    Expanded(
                      child: Column (
                        children:
                        [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.selectedTasks.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [          

                                        // Task tile here =>>
                                        Expanded(
                                          child: InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 20.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                        99, 158, 158, 158),
                                                    spreadRadius: 0,
                                                    blurRadius: 10,
                                                    offset: Offset(0,
                                                        2), // changes position of shadow
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              margin:
                                                  const EdgeInsets.only(left: 10.0,top: 10.0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(14.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const SizedBox(width: 15.0),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              data.selectedTasks[index].taskName,
                                                              style: const TextStyle(
                                                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)
                                                                
                                                            ) ,
                                                            Text(data.selectedTasks[index].taskDesc)
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Checkbox(
                                                      value: true,
                                                      checkColor:Colors.red,
                                                      activeColor:Colors.red,
                                                      onChanged: (bool? value) {
                                                        value = !value!;
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              ),

                              const SizedBox(height: 20.0),



                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                Text("Older",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(132, 0, 0, 0),
                                  )
                                )
                              ]),


                              Divider(
                                color: Colors.grey.withOpacity(0.6),
                                thickness: 1,
                              ),
                              






                              ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.selectedTasks.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [          

                                        // Task tile here =>>
                                        Expanded(
                                          child: InkWell(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 20.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                        99, 158, 158, 158),
                                                    spreadRadius: 0,
                                                    blurRadius: 10,
                                                    offset: Offset(0,
                                                        2), // changes position of shadow
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              margin:
                                                  const EdgeInsets.only(left: 10.0,top: 10.0),
                                              child: Padding(
                                                padding: const EdgeInsets.all(14.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const SizedBox(width: 15.0),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              data.selectedTasks[index].taskName,
                                                              style: const TextStyle(
                                                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700)
                                                                
                                                            ) ,
                                                            Text(data.selectedTasks[index].taskDesc)
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Checkbox(
                                                      value: true,
                                                      checkColor:Colors.red,
                                                      activeColor:Colors.red,
                                                      onChanged: (bool? value) {
                                                        value = !value!;
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              ),
                            ]
                          )







                          

                        
                          
                    )
                    
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
