import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediafy/cubit/cubit_logics.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/services/media_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  runApp(const MyApp());

  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AppCubit(
          media: MediaServices()
        ),
        child: const CubitLogics(),
      )
    );
  }
}