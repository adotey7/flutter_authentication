part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class AuthSignOut extends AuthEvent {}

class AuthSignInWithGoogle extends AuthEvent {}

class AuthResetPassword extends AuthEvent {
  final String email;

  AuthResetPassword({required this.email});
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({
    required this.email,
    required this.password,
  });
}

class AuthSignUp extends AuthEvent {
  final String name;
  final String password;
  final String email;

  AuthSignUp({
    required this.email,
    required this.name,
    required this.password,
  });
}
