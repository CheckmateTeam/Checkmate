import 'package:checkmate/model/taskModel.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Tablecalendar extends StatefulWidget {
  const Tablecalendar({super.key});

  @override
  State<Tablecalendar> createState() => _TablecalendarState();
}

class _TablecalendarState extends State<Tablecalendar> {
  @override
  Widget build(BuildContext context) {
    var calendarmodel = context.watch<CalendarModel>();
    return Column(
      children: [
        TableCalendar<Task>(
          locale: Localizations.localeOf(context).languageCode,
          calendarStyle: const CalendarStyle(
            markerDecoration: BoxDecoration(
              color: Color.fromRGBO(241, 91, 91, 1),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Color.fromRGBO(53, 53, 53, 1),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Color.fromRGBO(241, 91, 91, 1),
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
            markersAlignment: Alignment.bottomCenter,
          ),
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: calendarmodel.focusedDay,
          selectedDayPredicate: (day) =>
              isSameDay(calendarmodel.selectedDay, day),
          rangeStartDay: calendarmodel.rangeStart,
          rangeEndDay: calendarmodel.rangeEnd,
          calendarFormat: calendarmodel.calendarFormat,
          eventLoader: calendarmodel.getTasksForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          onFormatChanged: (format) {
            if (calendarmodel.calendarFormat != format) {
              calendarmodel.onFormatChanged(format);
            }
          },
          onDaySelected: calendarmodel.onDaySelected,
          onPageChanged: (focusedDay) {
            calendarmodel.onPageChanged(focusedDay);
          },
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
