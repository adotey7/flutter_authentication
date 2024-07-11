import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRepositoryInterface {
  Future<AuthResponse> signUpUser({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthResponse> signInUser({
    required String email,
    required String password,
  });

  Future<AuthResponse> signInWithGoogle();

  Future<void> resetPassword(String email);

  Future<void> signOutUser();
}
