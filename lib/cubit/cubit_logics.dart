import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/screens/home_screen.dart';
import 'package:mediafy/screens/movie_screen.dart';
import 'package:mediafy/screens/tvShow_screen.dart';

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
            return HomeScreen(page: 1,);
          } else if (state is TvShowsState) {
            return HomeScreen(page: 0,);
          } else if (state is SearchPageState) {
            return HomeScreen(page: 2,);
          } else if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (state is MovieState) {
            return const MovieScreen();
          } else if (state is TvShowState) {
            return const TvShowScreen();
          }else {
            return const Placeholder();
          }
        },
      ),
    );
  }
}