import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedbackViewAllScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dark mode kontrolü
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).admin_feedback_all_title),
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reports').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          }

          final feedbackDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              var feedback = feedbackDocs[index];

              return Card(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    feedback['email'] ?? 'Unknown User',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    feedback['feedback'] ?? 'No feedback provided',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: isDarkMode ? Colors.white : Colors.black),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackDetailScreen(
                          feedbackId: feedback.id,
                          email: feedback['email'] ?? 'Unknown Email',
                          feedbackContent: feedback['feedback'] ?? '',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FeedbackDetailScreen extends StatefulWidget {
  final String feedbackId;
  final String email;
  final String feedbackContent;

  FeedbackDetailScreen({
    required this.feedbackId,
    required this.email,
    required this.feedbackContent,
  });

  @override
  _FeedbackDetailScreenState createState() => _FeedbackDetailScreenState();
}

class _FeedbackDetailScreenState extends State<FeedbackDetailScreen> {
  final TextEditingController _replyController = TextEditingController();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).admin_feedback_all_title_user_feedback),
        backgroundColor: isDarkMode
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${S.of(context).admin_feedback_all_title_user}: ${widget.email}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${S.of(context).admin_feedback_all_title_user_feedback}:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.feedbackContent,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _replyController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    '${S.of(context).admin_feedback_all_title_user_feedback_textfiled_content}',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey : Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendReply,
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
                child: _isSending
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        S
                            .of(context)
                            .admin_feedback_all_title_user_feedback_send_button,
                        style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendReply() async {
    setState(() {
      _isSending = true;
    });

    try {
      final replyMessage = _replyController.text;
      if (replyMessage.isNotEmpty) {
        final Email email = Email(
          body: replyMessage,
          subject: 'Geri Bildiriminiz için Yanıt',
          recipients: [widget.email],
        );

        await FlutterEmailSender.send(email);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yanıt e-posta ile gönderildi!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Yanıt gönderilemedi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yanıt gönderilemedi, tekrar deneyin.')),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }
}
