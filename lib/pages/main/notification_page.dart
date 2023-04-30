import 'package:checkmate/provider/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';





import 'package:checkmate/pages/main/utilities/utils.dart';
import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
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
                padding: const EdgeInsets.only(top:20.0,left: 20.0,right: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Today",
                          style: TextStyle(
                          fontSize: 14,
                          
                          color: Color.fromARGB(132, 0, 0, 0))
                        ),

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
                      
                      child:SingleChildScrollView(child:  
                      Column(
                        children:[
                          ValueListenableBuilder<List<Event>>(
                            valueListenable: _selectedEvents,
                            builder: (context, value, _) {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [

                                          // Task tile here =>>
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                print(value[index].title);
                                              },
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
                                                margin: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          
                                                          const SizedBox(
                                                              width: 15.0),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                value[index].title,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 16),
                                                              ),
                                                              Text("Topic's Tag")
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Checkbox(
                                                        
                                                        checkColor: Colors.red,
                                                        value: true,
                                                        onChanged: (bool? value) {

                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 8.0),
                                        
                                        ],
                                        
                                        
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                      )
                                    ],
                                  );
                                },
                              );
                              
                            },
                            
                          ),


                          //Older from now on
                        
                          Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Older",
                                style: TextStyle(
                                fontSize: 14,
                                
                                color: Color.fromARGB(132, 0, 0, 0))
                              ),
                            ],
                          ),

                          Divider(
                                color: Colors.grey.withOpacity(0.6),
                                thickness: 1,
                              ),
                          

                          
                        ]
                      

                      
                    )
                    ) ,
                    ),
                    
                    //go yo challenge
                    Positioned(
                      left: 200,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Container()));
                          },
                          child: Icon(
                            Icons.fire_extinguisher_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                          )),
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

