import 'package:flutter/material.dart';
import 'package:mediafy/misc/colors.dart';
import 'package:mediafy/modules/home/pages/movies_page.dart';
import 'package:mediafy/modules/home/pages/search_page.dart';
import 'package:mediafy/modules/home/pages/tv_shows_page.dart';
import 'package:mediafy/modules/home/widgets/customBottomNavigationBar.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.page});

  int page;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = const [TvShowsPage(), MoviesPage(), SearchPage()];

  void _navigate(int index) {
    if (index == widget.page) return;

    setState(() {
      widget.page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.mainColor,
          bottomNavigationBar: CustomBottomNavigationBar(
            navigate: _navigate,
            pageIndex: widget.page,
            pages: const [
              BottomNavigationBarItem(label: "Tv Shows", icon: Icon(Icons.tv)),
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
              BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
            ],
          ),
          body: pages[widget.page]),
    );
  }
}
