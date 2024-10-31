import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/screens/user/user_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RouteCompleteScreen extends StatelessWidget {
  final String userId;
  final int routeKey;

  RouteCompleteScreen({required this.userId, required this.routeKey});

  Future<void> _addRouteToCalendar() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(now);

    await userDoc.update({
      'calendar': FieldValue.arrayUnion([
        {'routeKey': routeKey.toString(), 'date': formattedDate}
      ]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).route_complete_title),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              S.of(context).route_complete_tebrik,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              S.of(context).route_complete_content,
              style: TextStyle(
                fontSize: 18,
                color: Colors.green.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _addRouteToCalendar();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserHomeScreen()),
                  );
                } catch (e) {
                  print('Hata: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                S.of(context).route_complete_submit_button,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
