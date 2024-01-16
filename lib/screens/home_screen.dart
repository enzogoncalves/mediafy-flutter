import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/misc/colors.dart';
import 'package:mediafy/pages/movies_page.dart';
import 'package:mediafy/pages/search_page.dart';
import 'package:mediafy/pages/tv_shows_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.page});

  final int page;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = const [TvShowsPage(), MoviesPage(), SearchPage()];

  AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: appColors.mainColor,
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              if (index == widget.page) return;

              if (index == 0) {
                BlocProvider.of<AppCubit>(context).goToTvSeriesPage();
              } else if (index == 1) {
                BlocProvider.of<AppCubit>(context).goToMoviesPage();
              } else if (index == 2) {
                BlocProvider.of<AppCubit>(context).goToSearchPage();
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: appColors.mainColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.withOpacity(0.5),
            iconSize: 32,
            elevation: 0,
            currentIndex: widget.page,
            items: const [
              BottomNavigationBarItem(label: "Tv Shows", icon: Icon(Icons.tv)),
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
              BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
            ],
          ),
          body: pages[widget.page]),
    );
  }
}
