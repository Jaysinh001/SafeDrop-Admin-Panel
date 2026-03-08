import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class LoginPasswordVisibilityToggled extends LoginEvent {}

class LoginRememberMeToggled extends LoginEvent {
  final bool value;
  const LoginRememberMeToggled(this.value);

  @override
  List<Object> get props => [value];
}

class LoginSubmitted extends LoginEvent {}

class LoginErrorCleared extends LoginEvent {}

class LoginDemoCredentialsFilled extends LoginEvent {}
