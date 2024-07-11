import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  const CustomFilledButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
        ),
      ),
    );
  }
}
