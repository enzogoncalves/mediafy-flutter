import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/misc/colors.dart';
import 'package:mediafy/router/pages_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppCubit _appCubit;
  late bool isFirstInitialization;

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  Future<void> _onInit() async {
    _appCubit = Modular.get<AppCubit>();
    isFirstInitialization = await _appCubit.isFirstInitialization();
    await Future.delayed(const Duration(seconds: 1));
    if (isFirstInitialization) {
      Modular.to.pushReplacementNamed(PagesName.welcome);
    } else {
      Modular.to.pushReplacementNamed(PagesName.movies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: const Center(
        child: Text(
          "Mediafy",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
