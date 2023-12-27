import 'package:flutter/material.dart';

class NoCastProfilePath extends StatelessWidget {
  const NoCastProfilePath({super.key, required this.posterHeight});

  final double posterHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: posterHeight / 1.5,
      height: posterHeight,
      child: Center(
        child: Icon(Icons.person, color: Colors.grey[700], size: 102,),
      )
    );
  }
}