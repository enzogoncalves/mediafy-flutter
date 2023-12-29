import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/screens/home_screen.dart';
import 'package:mediafy/screens/movie_screen.dart';
import 'package:mediafy/screens/tvShow_screen.dart';
import 'package:mediafy/screens/welcome_screen.dart';

class CubitLogics extends StatefulWidget {
  const CubitLogics({super.key});

  @override
  State<CubitLogics> createState() => _CubitLogicsState();
}

class _CubitLogicsState extends State<CubitLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, CubitStates>(
      builder: (context, state) {
        if(state is WelcomeState) {
          return const WelcomeScreen();
        } else if(state is MoviesState) {
          return const HomeScreen(page: 1,);
        } else if (state is TvShowsState) {
          return const HomeScreen(page: 0,);
        } else if (state is SearchPageState) {
          return const HomeScreen(page: 2,);
        } else if (state is MovieState) {
          return const MovieScreen();
        } else if (state is LoadingMovie) {
          return const MovieScreen();
        } else if (state is TvShowState) {
          return const TvShowScreen();
        } else if (state is LoadingTvShow) {
          return const TvShowScreen();
        }else {
          return const Placeholder();
        }
      },
    );
  }
}