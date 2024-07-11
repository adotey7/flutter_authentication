import 'dart:async';

import 'package:authentiction_flutter/src/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;
  AuthBloc({
    required this.authRepository,
    required this.secureStorage,
    required this.sharedPreferences,
  }) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthSignInWithGoogle>(_onAuthSignInWithGoogle);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthResetPassword>(_onAuthResetPassword);

    on<AuthSignOut>(_onAuthSignOut);
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter emit) async {
    emit(AuthLoading());

    try {
      final isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        final accessToken = await secureStorage.read(key: 'authToken');

        if (accessToken != null) {
          final response =
              await Supabase.instance.client.auth.getUser(accessToken);

          if (response.user != null) {
            emit(AuthSuccess());
            return;
          }

          await secureStorage.delete(key: 'authToken');
          await sharedPreferences.setBool('isLoggedIn', false);
          emit(AuthInitial());
        } else {
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthSignUp(AuthSignUp event, Emitter emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.signUpUser(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      if (response.user == null) {
        throw Exception('User is null!');
      }

      await _saveSession(response.session!.accessToken);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _saveSession(String accessToken) async {
    try {
      await secureStorage.write(key: 'authToken', value: accessToken);
      await sharedPreferences.setBool('isLoggedIn', true);
    } catch (e) {
      // Nothing to do here
    }
  }

  void _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signOutUser();
      emit(AuthInitial());
      await secureStorage.delete(key: 'authToken');
      await sharedPreferences.setBool('isLoggedIn', false);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.signInUser(
          email: event.email, password: event.password);
      if (response.user == null) {
        throw Exception('Something went wrong');
      }

      await _saveSession(response.session!.accessToken);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthSignInWithGoogle(
      AuthSignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.signInWithGoogle();

      if (response.user == null) {
        throw Exception('User is null');
      }

      await _saveSession(response.session!.accessToken);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthResetPassword(
      AuthResetPassword event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      await authRepository.resetPassword(event.email);

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
