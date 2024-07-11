import 'package:authentiction_flutter/src/core/theme/app_pallete.dart';
import 'package:authentiction_flutter/src/core/widgets/loader.dart';
import 'package:authentiction_flutter/src/features/auth/bloc/auth_bloc.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/pages/Login_page.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/widgets/custom_filled_.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isChecked = false;

  @override
  void dispose() {
    _nameController.dispose();
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
          'Sign Up',
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
          Navigator.of(context).pushNamed('/home');
        }
      }, builder: (context, state) {
        if (state is AuthLoading) {
          return const Loader();
        }
        return SingleChildScrollView(
          child: Padding(
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
                      controller: _nameController,
                      hintText: 'Full Name',
                      icon: Icons.person_2_rounded,
                      label: 'Full Name',
                    ),
                    const SizedBox(
                      height: 15,
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
                    CheckboxListTile.adaptive(
                        value: _isChecked,
                        title: const Text('I agree to the Terms & Conditions'),
                        activeColor: Pallete.primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _isChecked = val!;
                          });
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomFilledButton(
                      label: 'Sign Up',
                      onPressed: _isChecked
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      AuthSignUp(
                                        email: _emailController.text.trim(),
                                        name: _nameController.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                      ),
                                    );
                              }
                            }
                          : null,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign Up with',
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
                            context
                                .read<AuthBloc>()
                                .add(AuthSignInWithGoogle());
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
                            //  TODO: Add facebook authentication
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
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Pallete.borderColor,
                            fontSize:
                                Theme.of(context).textTheme.bodyLarge?.fontSize,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
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
          ),
        );
      }),
    );
  }
}
