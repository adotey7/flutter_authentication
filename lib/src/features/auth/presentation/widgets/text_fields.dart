import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

class TextFields extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData icon;
  const TextFields({
    super.key,
    this.controller,
    this.obscureText = false,
    required this.label,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 70,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            obscureText: obscureText,
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label cannot be empty';
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Pallete.borderColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
