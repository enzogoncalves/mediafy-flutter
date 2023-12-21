import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/screens/home_screen.dart';
import 'package:mediafy/screens/movie_screen.dart';

class CubitLogics extends StatefulWidget {
  const CubitLogics({super.key});

  @override
  State<CubitLogics> createState() => _CubitLogicsState();
}

class _CubitLogicsState extends State<CubitLogics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppCubit, CubitStates>(
        builder: (context, state) {
          if(state is MoviesState) {
            return const HomeScreen();
          } else if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (state is MovieState) {
            print('new emit');
            return const MovieScreen();
          } else {
            return const Placeholder();
          }
        },
      ),
    );
  }
}