import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/models/faq_model.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FaqItem> faqItems = [];

  @override
  void initState() {
    super.initState();

    faqItems = [
      FaqItem(
        question: S.of(context).faq_question_1,
        answer: S.of(context).faq_answer_1,
      ),
      FaqItem(
        question: S.of(context).faq_question_2,
        answer: S.of(context).faq_answer_2,
      ),
      FaqItem(
        question: S.of(context).faq_question_3,
        answer: S.of(context).faq_answer_3,
      ),
      FaqItem(
        question: S.of(context).faq_question_4,
        answer: S.of(context).faq_answer_4,
      ),
      FaqItem(
        question: S.of(context).faq_question_5,
        answer: S.of(context).faq_answer_5,
      ),
      FaqItem(
        question: S.of(context).faq_question_6,
        answer: S.of(context).faq_answer_6,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).user_profile_faq_title),
      ),
      backgroundColor:
          isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: ExpansionTile(
              title: Text(
                faqItems[index].question,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.black : Colors.black,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    faqItems[index].answer,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.black : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
