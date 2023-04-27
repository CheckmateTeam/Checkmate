import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class createTask extends StatefulWidget {
  const createTask({super.key});

  @override
  State<createTask> createState() => _createTaskState();
}

class _createTaskState extends State<createTask> {
  List<String> dropdownItems = [
    'Never',
    'xxx before deadline',
    'xxd before deadline',
    'xxc before deadline',
  ];

  String dropdownValue = 'Never';
  TextEditingController taskName = TextEditingController();
  TimeOfDay timestart = TimeOfDay.now();
  TimeOfDay timeend = TimeOfDay.now();
  DateTime datestart = DateTime.now();
  DateTime dateend = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Create New Task",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Divider(),
              Text("Topic",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("START",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: datestart,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050));

                          if (date != null) {
                            setState(() {
                              datestart = date;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.primaries[0],
                            ),
                            SizedBox(width: 5),
                            Text(
                                "${datestart.day}  ${DateFormat('MMMM').format(DateTime(0, datestart.month))}  ${datestart.year}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.primaries[0])),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? time = await showTimePicker(
                              context: context, initialTime: timestart);
                          if (time != null) {
                            setState(() {
                              timestart = time;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text("${timestart.hour}",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(" : ",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text("${timestart.minute}",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("END",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: dateend,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050));

                          if (date != null) {
                            setState(() {
                              dateend = date;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.primaries[0],
                            ),
                            SizedBox(width: 5),
                            Text(
                                "${dateend.day}  ${DateFormat('MMMM').format(DateTime(0, dateend.month))}  ${dateend.year}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.primaries[0])),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? time = await showTimePicker(
                              context: context, initialTime: timeend);
                          if (time != null) {
                            setState(() {
                              timeend = time;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text("${timeend.hour}",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(" : ",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text("${timeend.minute}",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  )
                ],
              ),
              Text("Cycle",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text("Please use points to enable this feature",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 163, 163, 163),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.shopping_basket_outlined,
                    color: Colors.white,
                  ),
                  label: Text("Go to points shop",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
              // Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Color.fromARGB(255, 87, 87, 87)!),
              //     borderRadius: BorderRadius.circular(40),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Text("Once",
              //           style: TextStyle(
              //               fontSize: 14, fontWeight: FontWeight.bold)),
              //       Text("Daily",
              //           style: TextStyle(
              //               fontSize: 14, fontWeight: FontWeight.bold)),
              //       Text("Weekly",
              //           style: TextStyle(
              //               fontSize: 14, fontWeight: FontWeight.bold)),
              //       Text("Monthly",
              //           style: TextStyle(
              //               fontSize: 14, fontWeight: FontWeight.bold)),
              //     ],
              //   ),
              // ),
              SizedBox(height: 10),
              Text("Notify",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              SizedBox(
                width: 350,
                child: DropdownButton(
                  isExpanded: true,
                  value: dropdownValue,
                  items: dropdownItems
                      .map((item) => DropdownMenuItem(
                            child: Text(item),
                            value: item,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value.toString();
                    });
                  },
                ),
              ),
              SizedBox(height: 5),
              Text("Description",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          ElevatedButton(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(170, 40)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent)),
              onPressed: () {},
              child: Text("Create",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}
