import 'package:flutter/material.dart';

class TitleLarge extends StatelessWidget {
  const TitleLarge( this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold
      ),
    );
  }
}