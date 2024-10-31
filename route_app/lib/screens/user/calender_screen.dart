import 'package:accesible_route/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  Map<DateTime, List<Event>> _events = {};
  String? _userId;
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));

    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      await _fetchCalendarData();
    }
  }

  Future<void> _fetchCalendarData() async {
    if (_userId == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(_userId);
    final docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final calendarData = data?['calendar'] ?? [];

      if (calendarData.isEmpty) {
        print("Kullanıcıya ait herhangi bir etkinlik bulunmamaktadır.");
        return;
      }

      Map<DateTime, List<Event>> loadedEvents = {};

      for (var entry in calendarData) {
        DateTime date;
        if (entry['date'] is String) {
          date = DateTime.parse(entry['date']);
        } else {
          continue;
        }

        String routeKey = entry['routeKey'];
        int routeKeyInt = int.parse(routeKey);

        final placesSnapshot =
            await FirebaseFirestore.instance.collection('places').get();

        for (var placeDoc in placesSnapshot.docs) {
          final placeData = placeDoc.data();
          int placeKey = placeData['key'];
          print(placeKey);
          if (placeKey == routeKeyInt) {
            String titleTr = placeData['title_tr'] ?? 'Başlıksız';
            print(titleTr);
            print(routeKeyInt);

            DateTime normalizedDate = DateTime(date.year, date.month, date.day);
            if (loadedEvents[normalizedDate] == null) {
              loadedEvents[normalizedDate] = [];
            }
            print("burası çalışacak mı ");
            loadedEvents[normalizedDate]!.add(Event('Gezilen Yer: $titleTr'));
            break;
          }
        }
      }

      print("Yüklenen Etkinlikler: $loadedEvents");

      setState(() {
        _events = loadedEvents;
        _selectedEvents.value = _getEventsForDay(_selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar<Event>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              eventLoader: _getEventsForDay,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.purple),
                weekendStyle: TextStyle(color: Colors.red),
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  if (value.isEmpty) {
                    return Center(
                      child: Text(
                        S.of(context).user_calender_content,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                value[index].name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Event {
  final String name;

  Event(this.name);

  @override
  String toString() => name;
}
