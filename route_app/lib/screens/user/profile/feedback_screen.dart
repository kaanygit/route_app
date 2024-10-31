import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).user_profile_feedback_title),
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: _isSubmitted
          ? Container(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified,
                      color: Colors.green,
                      size: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).user_profile_feedback_title_submit,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).user_feedback_screen_titles,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 6,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          S.of(context).user_feedback_screen_textfield_content,
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        S.of(context).user_feedback_screen_send_button_title,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _submitFeedback() async {
    final feedback = _feedbackController.text;
    if (feedback.isEmpty) {
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user?.uid ?? 'Unknown UID';
      String email = user?.email ?? 'Unknown Email';

      await FirebaseFirestore.instance.collection('reports').add({
        'uid': uid,
        'email': email,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isSubmitted = true;
      });
    } catch (e) {
      print('Geri bildirim gönderilemedi: $e');
    }
  }
}
