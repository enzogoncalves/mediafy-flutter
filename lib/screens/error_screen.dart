import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediafy/misc/colors.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().mainColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(margin: const EdgeInsets.only(right: 40), child: SvgPicture.asset('assets/warning.svg', width: 200)),
            const SizedBox(
              height: 20,
            ),
            const Column(
              children: [
                Text(
                  "No Network Connection",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Make sure that your wifi is on",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
