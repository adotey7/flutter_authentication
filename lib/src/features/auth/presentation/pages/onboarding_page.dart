import 'package:authentiction_flutter/src/core/theme/app_pallete.dart';
import 'package:authentiction_flutter/src/features/auth/presentation/pages/Login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/custom_filled_.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
              SvgPicture.asset(
                'assets/svg/onboarding.svg',
                alignment: Alignment.center,
                width: double.infinity,
                height: 330,
              ),
              const Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Pallete.primaryColor,
                    fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomFilledButton(
                label: 'Sign In',
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
