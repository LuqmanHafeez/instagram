import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/feed_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/search_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:instagram/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
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
    model.User? user = Provider.of<UserProvider>(context).getUser;
    debugPrint("user.id: ${user?.uid.toString()}");
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: PageView(
          children: [
            FeedScreen(),
            SearchScreen(),
            AddPost(),
            Text("Favourite"),
            user == null ? SizedBox.shrink() : ProfileScreen(uid: user.uid),
            // Container(
            //   child: Text("Profile"),
            // ),
          ],
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (value) => onPageChanged(value),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: mobileBackgroundColor,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: '',
              // backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              label: '',
              // backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
              label: '',
              // backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              label: '',
              // backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              ),
              label: '',
              // backgroundColor: primaryColor,
            ),
          ],
          onTap: (page) {
            navigationTap(page);
          },
        ),
      ),
    );
  }
}
