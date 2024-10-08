import 'package:flutter/material.dart';
import 'package:route_app/constants/style.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Calender Screem",
            style: fontStyle(40, Colors.black, FontWeight.bold)),
      ),
    );
  }
}
