import 'package:authentiction_flutter/src/core/secrets/app_secretes.dart';
import 'package:authentiction_flutter/src/features/auth/repository/auth_repository_interface.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository implements AuthRepositoryInterface {
  final SupabaseClient supabaseClient;
  final GoogleSignIn googleSignIn;

  AuthRepository(this.supabaseClient, this.googleSignIn);

  @override
  Future<AuthResponse> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      return response;
    } on AuthException catch (e) {
      throw e.message;
    }
  }

  @override
  Future<AuthResponse> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
          'email': email,
        },
      );

      return response;
    } on AuthException catch (e) {
      throw e.message;
    }
  }

  @override
  Future<void> signOutUser() async {
    try {
      await googleSignIn.signOut();
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw e.message;
    }
  }

  @override
  Future<AuthResponse> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: AppSecret.androidClientID,
      serverClientId: AppSecret.webClientID,
    );

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in Cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthResponse response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      return response;
    } on AuthException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      rethrow;
    }
  }
}
