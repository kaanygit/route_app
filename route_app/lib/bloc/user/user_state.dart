import 'package:accesible_route/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final UserModel user;

  UserSuccess(this.user);
}

class UserFailure extends UserState {
  final String error;

  const UserFailure(this.error);

  @override
  List<Object> get props => [error];
}
