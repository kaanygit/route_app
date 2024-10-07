import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_app/bloc/auth/auth_bloc.dart';
import 'package:route_app/bloc/auth/auth_event.dart';
import 'package:route_app/bloc/auth/auth_state.dart';
import 'package:route_app/bloc/user/user_bloc.dart';
import 'package:route_app/bloc/user/user_state.dart';
import 'package:route_app/main.dart';
import 'package:route_app/widgets/error_screen.dart';
import 'package:route_app/widgets/loading.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserLoading) {
        return LoadingScreen();
      } else if (state is UserSuccess) {
        final user = state.user;
        print(user);
        return Scaffold(
          appBar: AppBar(
            title: Text(user.email),
          ),
          body: Text("hello"),
        );
      } else {
        return SimpleErrorScreen(errorMessage: "Veriler getirelemedi");
      }
    });
  }
}
