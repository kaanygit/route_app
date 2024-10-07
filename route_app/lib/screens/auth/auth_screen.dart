import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/auth/auth_bloc.dart';
import 'package:route_app/bloc/auth/auth_event.dart';
import 'package:route_app/bloc/auth/auth_state.dart';
import 'package:route_app/constants/style.dart';
import 'package:route_app/screens/auth/forgot_password_screen.dart';
import 'package:route_app/screens/user/user_home_screen.dart';
import 'package:route_app/widgets/buttons.dart';
import 'package:route_app/widgets/flash_message.dart';
import 'package:route_app/widgets/loading.dart';
import 'package:route_app/widgets/text_field.dart';
import 'package:sign_button/sign_button.dart';

// class AuthScreen extends StatelessWidget {
//   const AuthScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text(
//               'Rota App',
//               style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 50),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               },
//               child: const Text('Login'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => SignUpScreen()),
//                 );
//               },
//               child: const Text('Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class AuthScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.white,
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
                    'Rota App',
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
                      hintText: "Password",
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
                          "Forgot Password",
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
                          text: "Create Account",
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
                          text: "Sign In",
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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showErrorSnackBar(context, state.error);
        }
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserHomeScreen()),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingScreen();
        }

        return Scaffold(
          backgroundColor: Colors.white,
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
                    'Rota App',
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  MyTextField(
                      controller: usernameController,
                      hintText: "Username",
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
                      hintText: "Password",
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      enabled: true),
                  SizedBox(height: 20),
                  MyTextField(
                      controller: passwordConfirmController,
                      hintText: "Re-Password",
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
                          text: "Sign Up",
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
                                  'Lütfen geçerli bir e-posta giriniz.');
                              return;
                            }

                            if (passwordController.text.length < 6) {
                              showErrorSnackBar(context,
                                  'Parola en az 6 karakter olmalıdır.');
                              return;
                            }

                            if (passwordController.text !=
                                passwordConfirmController.text) {
                              showErrorSnackBar(
                                  context, 'Parolalar eşleşmiyor.');
                              return;
                            }

                            if (usernameController.text.isEmpty) {
                              showErrorSnackBar(
                                  context, 'Kullanıcı adı boş bırakılamaz.');
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
                          text: "Login",
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

        // return Scaffold(
        //   appBar: AppBar(
        //     title: Text('Sign Up'),
        //   ),
        //   body: Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         Text(
        //           'Create a new account',
        //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //           textAlign: TextAlign.center,
        //         ),
        //         SizedBox(height: 20),
        //         TextFormField(
        //           controller: usernameController,
        //           decoration: InputDecoration(
        //             labelText: 'Username',
        //             border: OutlineInputBorder(),
        //           ),
        //         ),
        //         SizedBox(height: 10),
        //         TextFormField(
        //           controller: emailController,
        //           decoration: InputDecoration(
        //             labelText: 'Email',
        //             border: OutlineInputBorder(),
        //           ),
        //         ),
        //         SizedBox(height: 10),
        //         TextFormField(
        //           controller: passwordController,
        //           decoration: InputDecoration(
        //             labelText: 'Password',
        //             border: OutlineInputBorder(),
        //           ),
        //           obscureText: true,
        //         ),
        //         SizedBox(height: 20),
        //         ElevatedButton(
        //           onPressed: () {
        //             context.read<AuthBloc>().add(
        //                   SignUpEvent(
        //                     email: emailController.text,
        //                     username: usernameController.text,
        //                     password: passwordController.text,
        //                   ),
        //                 );
        //           },
        //           child: Text('Sign Up'),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}
