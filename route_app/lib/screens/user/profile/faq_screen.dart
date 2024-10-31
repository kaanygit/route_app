import 'package:accesible_route/bloc/language/language_bloc.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/models/faq_model.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FaqItem> faqItems = [];

  @override
  void initState() {
    super.initState();

    String currentLanguage =
        BlocProvider.of<LanguageBloc>(context).state.locale.languageCode;

    faqItems = [
      FaqItem(
        question: currentLanguage == 'en'
            ? "How can I use the route app?"
            : "Rota uygulamasını nasıl kullanabilirim?",
        answer: currentLanguage == 'en'
            ? "The Route app is designed to make it easier for disabled individuals to access certain points. You can select a location from your main screen and receive recommendations like restrooms and markets along the way."
            : "Rota uygulaması, engelli bireylerin belirli noktalara erişimini kolaylaştırmak için tasarlanmıştır. Ana ekranınızdan bir yer seçebilir ve o yere ulaşırken yol üzerindeki tuvalet, market gibi önerilere ulaşabilirsiniz.",
      ),
      FaqItem(
        question: currentLanguage == 'en'
            ? "Which places are available in the app?"
            : "Uygulamada hangi yerler mevcut?",
        answer: currentLanguage == 'en'
            ? "The app offers various places including mosques, museums, and cultural sites."
            : "Uygulamada çeşitli yerler mevcuttur. Bu yerler arasında camiler, müzeler ve çeşitli kültürel alanlar bulunmaktadır.",
      ),
      FaqItem(
        question: currentLanguage == 'en'
            ? "I forgot my password, what should I do?"
            : "Şifremi unuttum, ne yapmalıyım?",
        answer: currentLanguage == 'en'
            ? "You can click on the 'Forgot my password' option on the login screen, enter your email, and receive a password reset link. Please check your spam folder if you don't see the email."
            : "Giriş yapma ekranındaki 'Şifremi unuttum' seçeneğine tıklayıp e-posta adresinizi girmeniz yeterlidir. Size şifre sıfırlama bağlantısı gönderilecektir. Gelen kutunuzda bulamazsanız spam klasörünü kontrol ediniz.",
      ),
      FaqItem(
        question: currentLanguage == 'en'
            ? "Is the app free?"
            : "Uygulama ücretsiz mi?",
        answer: currentLanguage == 'en'
            ? "Yes, the app is completely free. However, there are optional in-app purchases for extra features."
            : "Evet, uygulama tamamen ücretsizdir. Ancak ek özellikler için uygulama içi satın alma seçenekleri mevcuttur.",
      ),
      FaqItem(
        question: currentLanguage == 'en'
            ? "What should I do if I experience a problem?"
            : "Uygulama ile ilgili bir sorun yaşarsam ne yapmalıyım?",
        answer: currentLanguage == 'en'
            ? "If you experience any problems, you can send feedback directly through the app without needing to fill out a form."
            : "Uygulama ile ilgili bir sorun yaşarsanız, geri bildirim göndermeden hızlıca uygulama üzerinden bize bildirebilirsiniz.",
      ),
      FaqItem(
        question: currentLanguage == 'en'
            ? "What languages does the app support?"
            : "Uygulama hangi dilleri destekliyor?",
        answer: currentLanguage == 'en'
            ? "The app supports both English and Turkish."
            : "Uygulama İngilizce ve Türkçe dillerini desteklemektedir.",
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
                    color: isDarkMode ? Colors.black : Colors.black),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    faqItems[index].answer,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.black : Colors.black),
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
