import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FaqItem> faqItems = [
    FaqItem(
      question: "How do I reset my password?",
      answer:
          "To reset your password, go to the Settings, select 'Account', and choose 'Reset Password'.",
    ),
    FaqItem(
      question: "Where can I find my order history?",
      answer:
          "You can find your order history in the 'Orders' section of your profile.",
    ),
    FaqItem(
      question: "How do I change my email address?",
      answer:
          "Go to Settings, then select 'Account Information' and you will find an option to change your email address.",
    ),
    FaqItem(
      question: "Is my personal data secure?",
      answer:
          "Yes, we take your privacy seriously and implement strict security measures to protect your data.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqItems[index].question,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(faqItems[index].answer),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}
