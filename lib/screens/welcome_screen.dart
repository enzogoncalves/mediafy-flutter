import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediafy/cubit/cubits.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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

              const SizedBox(height: 60,),

              const Text(
                "Welcome to Mediafy!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500
                ),
              ),
              
              const SizedBox(height: 10,),

              const SizedBox(
                width: 300,
                child: Text(
                  "You can use it to search any movie or tv show and see all the relevant informations about,",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 60,),

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AppCubit>(context).goToMoviesPage();
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 18
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 33, 122, 196)
                  ),
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