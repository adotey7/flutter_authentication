import 'package:authentiction_flutter/src/core/widgets/loader.dart';
import 'package:authentiction_flutter/src/features/auth/bloc/auth_bloc.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/pages/forgor_password_page.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/pages/login_page.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/pages/onboarding_page.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/pages/sign_up_page.dart';
import 'package:authentiction_flutter/src/features/main/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return const HomePage();
          } else if (state is AuthLoading) {
            return const Scaffold(
              body: Loader(),
            );
          } else if (state is AuthError) {
            return const LoginPage();
          } else if (state is AuthInitial) {
            return const LoginPage(); // Default case for AuthInitial and AuthUnauthenticated
          } else {
            return const OnboardingPage();
          }
        },
      ),
  '/login': (context) => const LoginPage(),
  '/signup': (context) => const SignUpPage(),
  '/home': (context) => const HomePage(),
  '/forgot-password': (context) => const ForgotPasswordPage(),
};
