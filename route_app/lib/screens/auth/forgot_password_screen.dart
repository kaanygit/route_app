import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:route_app/constants/style.dart';
import 'package:route_app/widgets/buttons.dart';
import 'package:route_app/widgets/flash_message.dart';
import 'package:route_app/widgets/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailSent = false;

  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _isEmailSent = true;
      });
    } catch (e) {
      print("Şifre sıfırlama maili gönderilemedi: $e");
      showErrorSnackBar(context, "Hata: Şifre sıfırlama maili gönderilemedi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: !_isEmailSent
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Input Your Email",
                        style: fontStyle(
                            16, Colors.grey.shade600, FontWeight.normal),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Lütfen şifre sıfırlama için e-posta adresinizi girin.',
                        style: fontStyle(24, Colors.black, FontWeight.bold),
                      ),
                      SizedBox(height: 50),
                      MyTextField(
                          controller: _emailController,
                          hintText: "Email",
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          enabled: true),
                    ],
                  ),
                ),
                // Positioned ile butonu en alta sabitliyoruz
                Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: MyButton(
                        text: "Şifre Sıfırlama Maili Gönder",
                        buttonColor: Colors.amber,
                        buttonTextColor: Colors.black,
                        buttonTextSize: 16,
                        buttonTextWeight: FontWeight.bold,
                        borderRadius: BorderRadius.circular(16),
                        onPressed: () {
                          final email = _emailController.text.trim();
                          if (email.isNotEmpty) {
                            _resetPassword(email);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Lütfen geçerli bir e-posta adresi giriniz."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        buttonWidth: ButtonWidth.large))
              ],
            )
          : Container(
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
                      'Mail gönderildi! Lütfen e-postanızı kontrol edin.',
                      style: fontStyle(24, Colors.green, FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
