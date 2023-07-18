import 'package:flutter/material.dart';

class AdviceBox extends StatelessWidget {
  final String advice;
  const AdviceBox({super.key, required this.advice});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Material(
      elevation: 20,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: themeData.colorScheme.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Text(
          '"$advice"',
          style: themeData.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
