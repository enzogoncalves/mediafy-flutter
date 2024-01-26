import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediafy/misc/colors.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen(this.parentFunction, {super.key});

  final Function() parentFunction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
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
            Column(
              children: [
                const Text(
                  "No Network Connection",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                const Text(
                  "Make sure that your wifi is on",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: parentFunction,
                    style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20), foregroundColor: Colors.black),
                    child: const Text("Try Again"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
