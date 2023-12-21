import 'package:flutter/material.dart';
import 'package:mediafy/misc/colors.dart';
import 'package:mediafy/pages/movies_page.dart';
import 'package:mediafy/pages/search_page.dart';
import 'package:mediafy/pages/tv_shows_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 1;

  List<Widget> pages = const [
    TvShowsPage(),
    HomePage(),
    SearchPage()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            setState(() {
              pageIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.mainColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          iconSize: 32,
          elevation: 0,
          currentIndex: pageIndex,
          items: const [
            BottomNavigationBarItem(
              label: "Tv Shows",
              icon: Icon(Icons.tv)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home"
            ),
            BottomNavigationBarItem(
              label: "Search",
              icon: Icon(Icons.search)
            ),

          ],
        ),
        body: pages[pageIndex]
      ),
    );
  }
}