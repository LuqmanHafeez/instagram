import 'package:easy_sidemenu/easy_sidemenu.dart';
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
  int selectedIndex = 0;
  late PageController pageController;
  late SideMenuController sideMenuController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    sideMenuController = SideMenuController();
    sideMenuController.addListener((index) {
      pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
    sideMenuController.dispose();
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

  sideMenu() {
    return SideMenu(
      controller: sideMenuController,
      title: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 16.0, left: 0, right: 0),
        child: SvgPicture.asset("assets/instagram.svg"),
      ),
      style: SideMenuStyle(selectedColor: Colors.transparent),
      items: [
        SideMenuItem(
          priority: 0,
          title: 'Home',
          badgeColor: _page == 0 ? Colors.black : Colors.black,
          onTap: (index, _) {
            sideMenuController.changePage(index);
          },
          icon: const Icon(Icons.home),
        ),
        SideMenuItem(
          priority: 1,
          title: 'Search',
          badgeColor: _page == 1 ? Colors.black : Colors.black,
          onTap: (index, _) {
            sideMenuController.changePage(index);
          },
          icon: const Icon(Icons.search),
        ),
        SideMenuItem(
          priority: 2,
          title: 'Create',
          badgeColor: _page == 2 ? Colors.black : Colors.black,
          onTap: (index, _) {
            sideMenuController.changePage(index);
          },
          icon: const Icon(Icons.add_circle),
        ),
        SideMenuItem(
          priority: 3,
          title: 'Notifications',
          badgeColor: _page == 3 ? Colors.black : Colors.black,
          onTap: (index, _) {
            sideMenuController.changePage(index);
          },
          icon: const Icon(Icons.favorite_border),
          badgeContent: const CircleAvatar(
            backgroundColor: Colors.red,
          ),
        ),
        SideMenuItem(
          priority: 4,
          title: 'Profile',
          badgeColor: _page == 4 ? Colors.black : Colors.black,
          onTap: (index, _) {
            sideMenuController.changePage(index);
          },
          icon: const Icon(Icons.person),
        ),
      ],
    );
  }

  // secondMethodSideMenu() {
  //   return NavigationRail(
  //     leading: Padding(
  //       padding: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 10.0),
  //       child: SvgPicture.asset("assets/instagram.svg"),
  //     ),
  //     destinations: const [
  //       NavigationRailDestination(
  //           icon: Icon(Icons.home, color: Colors.black),
  //           label: Text(
  //             "Home",
  //             style: TextStyle(color: Colors.black),
  //             selectionColor: Colors.black,
  //           )),
  //       NavigationRailDestination(
  //           icon: Icon(Icons.search, color: Colors.black),
  //           label: Text(
  //             "Search",
  //             style: TextStyle(color: Colors.black),
  //             selectionColor: Colors.black,
  //           )),
  //       NavigationRailDestination(
  //           icon: Icon(Icons.add_circle, color: Colors.black),
  //           label: Text(
  //             "Create",
  //             style: TextStyle(color: Colors.black),
  //             selectionColor: Colors.black,
  //           )),
  //       NavigationRailDestination(
  //           icon: Icon(Icons.favorite, color: Colors.black),
  //           label: Text(
  //             "Notification",
  //             style: TextStyle(color: Colors.black),
  //             selectionColor: Colors.black,
  //           )),
  //       NavigationRailDestination(
  //           icon: Icon(Icons.person, color: Colors.black),
  //           label: Text(
  //             "Profile",
  //             style: TextStyle(color: Colors.black),
  //             selectionColor: Colors.black,
  //           )),
  //     ],
  //     labelType: NavigationRailLabelType.all,
  //     selectedLabelTextStyle: const TextStyle(color: Colors.black),
  //     unselectedLabelTextStyle: const TextStyle(color: Colors.grey),
  //     selectedIconTheme: const IconThemeData(color: Colors.black),
  //     unselectedIconTheme: const IconThemeData(color: Colors.grey),
  //     backgroundColor: Colors.white,
  //     selectedIndex: selectedIndex,
  //     onDestinationSelected: (value) {
  //       selectedIndex = value;
  //       navigationTap(value);
  //       debugPrint("Selected Index :" + selectedIndex.toString());
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: Colors.white,
        //   title: SvgPicture.asset(
        //     "assets/instagram.svg",
        //     color: Colors.black,
        //   ),
        //   centerTitle: false,
        // ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            sideMenu(),
            //secondMethodSideMenu(),
            const VerticalDivider(
              color: Colors.grey,
            ),

            Expanded(
              child: PageView(
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
            ),
          ],
        ),
      ),
    );
  }
}
