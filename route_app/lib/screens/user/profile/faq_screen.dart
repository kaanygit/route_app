import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FaqItem> faqItems = [
    FaqItem(
      question: "Rota uygulamasını nasıl kullanabilirim?",
      answer:
          "Rota uygulaması, engelli bireylerin belirli noktalara erişimini kolaylaştırmak için tasarlanmıştır. Ana ekranınızdan bir yer seçebilir ve o yere ulaşırken yol üzerindeki tuvalet, market gibi önerilere ulaşabilirsiniz.",
    ),
    FaqItem(
      question: "Uygulamada hangi yerler mevcut?",
      answer:
          "Rota uygulamasında çeşitli yerler mevcuttur. Bu yerler arasında parklar, alışveriş merkezleri ve restoranlar bulunmaktadır.",
    ),
    FaqItem(
      question: "Şifremi unuttum, ne yapmalıyım?",
      answer:
          "Ana ekrandaki 'Şifremi unuttum' seçeneğine tıklayarak e-posta adresinizi girmeniz gerekmektedir. E-posta adresinize bir şifre sıfırlama bağlantısı içeren bir e-posta gönderilecektir.",
    ),
    FaqItem(
      question: "Kullanıcı bilgilerini nasıl güncelleyebilirim?",
      answer:
          "Kullanıcı bilgilerinizi güncellemek için uygulama içindeki profil bölümüne gidin ve istediğiniz bilgileri güncelleyebilirsiniz.",
    ),
    FaqItem(
      question: "Uygulama hangi dilleri destekliyor?",
      answer:
          "Rota uygulaması, Türkçe başta olmak üzere birkaç dil seçeneği sunmaktadır.",
    ),
    FaqItem(
      question: "Yolda önerilen yerleri nasıl bulabilirim?",
      answer:
          "Rota uygulaması, belirlediğiniz rotada size öneriler sunmaktadır.",
    ),
    FaqItem(
      question: "Uygulama ücretsiz mi?",
      answer:
          "Evet, Rota uygulaması ücretsizdir. Bazı ek özellikler için uygulama içi satın alma seçenekleri sunulmaktadır.",
    ),
    FaqItem(
      question: "Uygulama ile ilgili bir sorun yaşarsam ne yapmalıyım?",
      answer:
          "Eğer uygulama ile ilgili bir sorun yaşarsanız, uygulama içindeki 'Yardım' veya 'İletişim' bölümüne gidebilirsiniz.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sıkça Sorulan Sorular'),
      ),
      backgroundColor: Colors.white,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    faqItems[index].answer,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
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

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}
