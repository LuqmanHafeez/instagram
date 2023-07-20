import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  navigationTap(int page) {
    debugPrint("page : $page");
    pageController.jumpToPage(page);
  }

  onPageChanged(int value) {
    debugPrint("value: $value");
    setState(() {
      _page = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: webBackgroundColor,
      appBar: AppBar(
          backgroundColor: webBackgroundColor,
          title: SvgPicture.asset(
            "assets/instagram.svg",
            color: Colors.white,
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                navigationTap(0);
              },
              icon: const Icon(Icons.home),
              color: _page == 0 ? primaryColor : secondaryColor,
            ),

            // backgroundColor: primaryColor,
            IconButton(
              onPressed: () {
                navigationTap(1);
              },
              icon: const Icon(Icons.search),
              color: _page == 1 ? primaryColor : secondaryColor,
            ),

            // backgroundColor: primaryColor,
            IconButton(
              onPressed: () {
                navigationTap(2);
              },
              icon: const Icon(Icons.add_circle),
              color: _page == 2 ? primaryColor : secondaryColor,
            ),

            // backgroundColor: primaryColor,

            IconButton(
              onPressed: () {
                navigationTap(3);
              },
              icon: const Icon(Icons.favorite),
              color: _page == 3 ? primaryColor : secondaryColor,
            ),

            // backgroundColor: primaryColor,

            IconButton(
              onPressed: () {
                navigationTap(4);
              },
              icon: const Icon(Icons.person),
              color: _page == 4 ? primaryColor : secondaryColor,
            ),

            // backgroundColor: primaryColor,
          ]),
      body: PageView(
        children: [
          FeedScreen(),
          SearchScreen(),
          AddPost(),
          Text("Favourite"),
          ProfileScreen(uid: user!.uid),
        ],
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (value) => onPageChanged(value),
      ),
    );
  }
}
