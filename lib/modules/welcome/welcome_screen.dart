import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/router/pages_name.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late AppCubit _appCubit;

  @override
  void initState() {
    super.initState();
    _appCubit = Modular.get<AppCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/welcome-image.svg",
                width: 300,
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                "Welcome to Mediafy!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 300,
                child: Text(
                  "You can use it to search any movie or tv show and see all the relevant informations about,",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    _appCubit.changeFirstInitialization();
                    Modular.to.pushReplacementNamed(PagesName.movies);
                  },
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 18), foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 33, 122, 196)),
                  child: const Text(
                    "Begin",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
