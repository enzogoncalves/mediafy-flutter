import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediafy/misc/colors.dart';
import 'package:tmdb_api/tmdb_api.dart';

class ServerErrorScreen extends StatelessWidget {
  const ServerErrorScreen({super.key, required this.tmdbError, required this.parentFunction});

  final TmdbError tmdbError;
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/server_down.svg', width: 300),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      const Text(
                        "Oops, an error occurred while trying to request the data",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                            onPressed: () async {
                              await parentFunction();
                            },
                            child: const Text(
                              "Try again",
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'error status code: ${tmdbError.status_code}',
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
