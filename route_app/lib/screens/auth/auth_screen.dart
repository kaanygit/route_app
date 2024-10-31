import 'package:accesible_route/bloc/auth/auth_bloc.dart';
import 'package:accesible_route/bloc/auth/auth_state.dart';
import 'package:accesible_route/constants/style.dart';
import 'package:accesible_route/generated/l10n.dart';
import 'package:accesible_route/screens/auth/forgot_password_screen.dart';
import 'package:accesible_route/screens/user/user_home_screen.dart';
import 'package:accesible_route/utils/darkmode_utils.dart';
import 'package:accesible_route/widgets/buttons.dart';
import 'package:accesible_route/widgets/flash_message.dart';
import 'package:accesible_route/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_button/sign_button.dart';

import '../../bloc/auth/auth_event.dart';
import '../../widgets/loading.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showErrorSnackBar(context, state.error);
        }
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserHomeScreen()),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: !isDarkMode
              ? Colors.white
              : Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    S.of(context).application_title,
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      enabled: true),
                  SizedBox(height: 20),
                  MyTextField(
                      controller: passwordController,
                      hintText: S.of(context).auth_password_title,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      enabled: true),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          print("Parolamı unuttum sayfa yönlendirmesi");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ForgotPasswordScreen()));
                        },
                        child: Text(
                          S.of(context).auth_forgotpassword_title,
                          style: fontStyle(15, Colors.grey, FontWeight.normal),
                        )),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyButton(
                          text: S.of(context).auth_createAccount_title,
                          borderRadius: BorderRadius.circular(16),
                          buttonColor: Colors.white,
                          buttonTextColor: Colors.black,
                          buttonTextSize: 16,
                          buttonTextWeight: FontWeight.bold,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignUpScreen()));
                          },
                          buttonWidth: ButtonWidth.xLarge),
                      SizedBox(
                        height: 20,
                      ),
                      MyButton(
                          text: S.of(context).auth_signIn_title,
                          borderRadius: BorderRadius.circular(16),
                          buttonColor: Colors.amber,
                          buttonTextColor: Colors.black,
                          borderColor: Colors.amber,
                          buttonTextSize: 16,
                          buttonTextWeight: FontWeight.bold,
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  SignInWithEmailAndPasswordEvent(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                                );
                          },
                          buttonWidth: ButtonWidth.xLarge),
                      SizedBox(height: 20),
                      SignInButton(
                          buttonType: ButtonType.google,
                          buttonSize: ButtonSize.medium,
                          btnText: S.of(context).auth_signInWithGoogle_title,
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(AuthGoogleSignInRequested());
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtils.isDarkMode(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showErrorSnackBar(context, state.error);
        }
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserHomeScreen()),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingScreen();
        }

        return Scaffold(
          backgroundColor: !isDarkMode
              ? Colors.white
              : Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    S.of(context).application_title,
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  MyTextField(
                      controller: usernameController,
                      hintText: S.of(context).auth_username_title,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      enabled: true),
                  SizedBox(height: 20),
                  MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      enabled: true),
                  SizedBox(height: 20),
                  MyTextField(
                      controller: passwordController,
                      hintText: S.of(context).auth_password_title,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      enabled: true),
                  SizedBox(height: 20),
                  MyTextField(
                      controller: passwordConfirmController,
                      hintText: S.of(context).auth_repassword_title,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      enabled: true),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyButton(
                          text: S.of(context).auth_createAccount_title,
                          borderRadius: BorderRadius.circular(16),
                          buttonColor: Colors.amber,
                          buttonTextColor: Colors.black,
                          borderColor: Colors.amber,
                          buttonTextSize: 16,
                          buttonTextWeight: FontWeight.bold,
                          onPressed: () {
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(emailController.text)) {
                              showErrorSnackBar(context,
                                  S.of(context).forgot_password_wrong1);
                              return;
                            }

                            if (passwordController.text.length < 6) {
                              showErrorSnackBar(context,
                                  S.of(context).forgot_password_wrong2);
                              return;
                            }

                            if (passwordController.text !=
                                passwordConfirmController.text) {
                              showErrorSnackBar(context,
                                  S.of(context).forgot_password_wrong3);
                              return;
                            }

                            if (usernameController.text.isEmpty) {
                              showErrorSnackBar(context,
                                  S.of(context).forgot_password_wrong4);
                              return;
                            }

                            context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    email: emailController.text,
                                    username: usernameController.text,
                                    password: passwordController.text,
                                  ),
                                );
                          },
                          buttonWidth: ButtonWidth.xLarge),
                      SizedBox(
                        height: 20,
                      ),
                      MyButton(
                          text: S.of(context).auth_signIn_title,
                          borderRadius: BorderRadius.circular(16),
                          buttonColor: Colors.white,
                          buttonTextColor: Colors.black,
                          buttonTextSize: 16,
                          buttonTextWeight: FontWeight.bold,
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AuthScreen()));
                          },
                          buttonWidth: ButtonWidth.xLarge),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
