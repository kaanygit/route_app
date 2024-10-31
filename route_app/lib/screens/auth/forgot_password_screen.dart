import 'package:accesible_route/constants/style.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/buttons.dart';
import 'package:accesible_route/widgets/flash_message.dart';
import 'package:accesible_route/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      showErrorSnackBar(context, S.of(context).forgot_password_unsend_message);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return Scaffold(
      backgroundColor: !isDarkMode
          ? Colors.white
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: !isDarkMode
            ? Colors.white
            : Theme.of(context).scaffoldBackgroundColor,
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
                        S.of(context).auth_forgotpasswor_inputmail,
                        style: fontStyle(
                            16,
                            !isDarkMode ? Colors.grey.shade600 : Colors.white,
                            FontWeight.normal),
                      ),
                      SizedBox(height: 10),
                      Text(
                        S.of(context).auth_forgotpasswor_inputmail_content,
                        style: fontStyle(
                            24,
                            !isDarkMode ? Colors.black : Colors.white,
                            FontWeight.bold),
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
                Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: MyButton(
                        text: S.of(context).auth_forgotpassword_submit_button,
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
                                  S.of(context).forgot_password_wrong1,
                                  style: TextStyle(
                                      color: !isDarkMode
                                          ? Colors.black
                                          : Colors.white),
                                ),
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
                      S.of(context).forgot_password_send_success,
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
