import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error,
          color: Colors.redAccent,
          size: 40,
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Flexible(
          child: Text(
            message,
            style: themeData.textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
