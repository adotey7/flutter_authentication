import 'package:authentiction_flutter/src/core/theme/app_pallete.dart';
import 'package:authentiction_flutter/src/core/widgets/loader.dart';
import 'package:authentiction_flutter/src/features/auth/bloc/auth_bloc.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/pages/forgor_password_page.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/pages/sign_up_page.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/widgets/custom_filled_.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/text_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Login ',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is AuthSuccess) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }, builder: (context, state) {
        if (state is AuthLoading) {
          return const Loader();
        }
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  TextFields(
                    controller: _emailController,
                    hintText: 'Email address',
                    icon: Icons.email,
                    label: 'Email Address',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFields(
                    hintText: 'Password',
                    controller: _passwordController,
                    icon: Icons.shield_rounded,
                    label: 'Password',
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Pallete.primaryColor),
                        ),
                      ),
                    ],
                  ),
                  CustomFilledButton(
                    label: 'Login ',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthSignIn(
                                  email: _emailController.text,
                                  password: _passwordController.text),
                            );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log In with',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<AuthBloc>().add(AuthSignInWithGoogle());
                        },
                        child: Image.asset(
                          'assets/images/google.png',
                          height: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          print('facebook');
                        },
                        child: Image.asset(
                          'assets/images/facebook.png',
                          height: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: Pallete.borderColor,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge?.fontSize,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: Pallete.primaryColor,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
