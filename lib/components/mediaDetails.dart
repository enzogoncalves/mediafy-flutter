import 'package:flutter/material.dart';

class MediaDetail extends StatelessWidget {
  const MediaDetail({super.key, required this.header, required this.data });

  final String header;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
        ),

        Text(
          data,
          style: const TextStyle(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}