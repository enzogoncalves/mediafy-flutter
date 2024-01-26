import 'package:flutter/material.dart';
import 'package:mediafy/misc/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.navigate, required this.pages, required this.pageIndex});

  final Function(int) navigate;
  final List<BottomNavigationBarItem> pages;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: navigate,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.mainColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.withOpacity(0.5),
      iconSize: 32,
      elevation: 0,
      currentIndex: pageIndex,
      items: pages,
      enableFeedback: false,
    );
  }
}
